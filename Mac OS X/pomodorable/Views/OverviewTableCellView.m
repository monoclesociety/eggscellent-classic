//
//  OverviewTableCellView.m
//  pomodorable
//
//  Created by Kyle Kinkade on 11/9/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//

#import "OverviewTableCellView.h"
#import "ModelStore.h"
#import "NS(Attributed)String+Geometrics.h"
#import "EggTimer.h"
#import "PomodoroBadgeView.h"
#import "TaskSyncController.h"

@implementation OverviewTableCellView
@synthesize selected = _selected;
@synthesize backgroundClip;
@synthesize editContainerView;
@synthesize tableView;

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(textDidEndEditing:) 
                                                 name:NSControlTextDidEndEditingNotification 
                                               object:self.textField];
    
    //BIND: ribbon view values
    [ribbonView bind:@"plannedPomodoroCount"
            toObject:self
         withKeyPath:@"objectValue.plannedCount"
             options:nil];
    
    [ribbonView bind:@"completePomodoroCount"
            toObject:self
         withKeyPath:@"objectValue.completedEggs.@count"
             options:nil];
    
    [ribbonView bind:@"completed"
            toObject:self
         withKeyPath:@"objectValue.completed"
             options:nil];
    
    //BIND: Pomodoro counter values
    [pomodoroCounterView bind:@"plannedCount"
                     toObject:self
                  withKeyPath:@"objectValue.plannedCount"
                      options:nil];
    
    
    //BIND: interruption Label values
    increasePomodoroCountButton.toolTip = @"increase egg count (⌘ →)";
    decreasePomodoroCountButton.toolTip = @"decrease egg count (⌘ ←)";
    
    //set coverupview
    coverupView.backgroundColor = [NSColor colorWithCalibratedWhite:0.9254901961f alpha:1];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setObjectValue:(id)anObjectValue
{
    [super setObjectValue:anObjectValue];
    if(anObjectValue)
    {
        Activity *a = (Activity *)self.objectValue;
        
        //try to set the initial height of the textField
        CGFloat titleHeight = [OverviewTableCellView heightOfTitle:[a.name copy]];
        CGRect f = self.textField.frame;
        f.size.height = titleHeight;
        f.origin.y = NSMaxY(self.frame) - titleHeight - 11;
        self.textField.frame = f;

        externalInterruptionLabel.stringValue = [[a externalInterruptionCount] stringValue];
        internalInterruptionLabel.stringValue = [[a internalInterruptionCount] stringValue];
        [ribbonView setNeedsDisplay:YES];
    }
}

+ (CGFloat)heightOfTitle:(NSString *)title;
{
    CGFloat height = 0;
    NSFont *tFont = [NSFont fontWithName:@"Lucida Grande" size:12];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:tFont,NSFontAttributeName,nil];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:title attributes:attributes];
    height = [attributedString heightForWidth:242];
    
    //let's add in that weird adjustment shall we? it says 15, but every one is off by 1.5
    CGFloat additionalWeirdHeight = (height / 15) * 1.5;
    height += additionalWeirdHeight;
    
//    NSLog(@"\r\n====\r\nHeight: %f\r\nTitle: %@\r\n====\r\n", height, title);
    return height;
}

+ (CGFloat)heightForTitle:(NSString *)title selected:(BOOL)selected;
{
    CGFloat height = 70;

    height = [OverviewTableCellView heightOfTitle:title];
    
    //don't forget the padding on the top and bottom
    height += 22;
    
    if(height < 52)
        height = 52;
    
    if(selected)
        height += 100;
    
    return height;
}

- (void)setSelected:(BOOL)selected
{
    //get the selection height used for all of this
    CGFloat selectionHeight = [OverviewTableCellView heightForTitle:self.textField.stringValue selected:NO];
    [coverupView setHidden:!selected];
    if(selected)
    {
        
        [self.textField setEditable:YES];
        
        //change frame of selection box
        CGRect r = coverupView.frame;
        
        selectionHeight -= 6;
        r.size.height = selectionHeight;
        r.origin.y = NSMaxY(self.frame) - selectionHeight - 6;
        coverupView.frame = r;
        
        BOOL tofu = [((Activity *)self.objectValue).completed boolValue];        
        editContainerView.hidden = tofu;
    }
    else
    {
        [self.textField setEditable:NO];    
        
        //hide selector box
        editContainerView.hidden = YES;
    }
    _selected = selected;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
        CGFloat maxY = NSMaxY(self.frame);
        CGContextRef c = (CGContextRef )[[NSGraphicsContext currentContext] graphicsPort];
    
        CGColorRef black = CGColorCreateGenericRGB(0.7411764706f, 0.7411764706f, 0.7411764706f, 1);
        CGContextSetStrokeColorWithColor(c, black);
        CGContextBeginPath(c);
        CGContextMoveToPoint(c, 0.0f, maxY - 2.5f);
        CGContextAddLineToPoint(c, 320.0f, maxY - 2.5f);
        CGContextSetLineWidth(c, 1);
        CGContextSetLineCap(c, kCGLineCapSquare);
        CGContextClosePath(c);
        CGContextStrokePath(c);
        CGColorRelease(black);
        
        CGColorRef lightGrey = CGColorCreateGenericRGB(1, 1, 1, 1);
        CGContextSetStrokeColorWithColor(c, lightGrey);
        CGContextTranslateCTM(c, 0, 1);
        CGContextBeginPath(c);
        CGContextMoveToPoint(c, 0.0f, maxY - 4.5f);
        CGContextAddLineToPoint(c, 320.0f, maxY - 4.5f);
        CGContextSetLineWidth(c, 1);
        CGContextSetLineCap(c, kCGLineCapSquare);
        CGContextClosePath(c);
        CGContextStrokePath(c);        
        CGColorRelease(lightGrey);
}

#pragma mark - Custom methods

- (void)modifyPomodoroCount:(int)delta
{
    Activity *a = (Activity *)self.objectValue;
    int currentCount = [a.plannedCount intValue];
    if((currentCount + delta) > MAX_EGG_COUNT || (currentCount + delta) < 1)
        return;
    
    a.plannedCount = [NSNumber numberWithInt:[a.plannedCount intValue] + delta];
    pomodoroCounterView.plannedCount = a.plannedCount;
    
    //set ribbon value
    ribbonView.plannedPomodoroCount = [a.plannedCount intValue];
    ribbonView.completePomodoroCount = (int)[a.completedEggs count];
    [ribbonView setNeedsDisplay:YES];
    
    [a save];
}

#pragma mark - IBActions

- (IBAction)increasePomodoroCount:(id)sender;
{
    [self modifyPomodoroCount:1];
}

- (IBAction)decreasePomodoroCount:(id)sender;
{
    [self modifyPomodoroCount:-1];
}

- (IBAction)externalInterruptionSelected:(id)sender;
{
    Activity *a = (Activity *)self.objectValue;
    Egg *p = [[a.eggs allObjects] lastObject];
    
    NSNumber *newInterruptionCount = [NSNumber numberWithInt:[p.externalInterruptions intValue] + 1];
    p.externalInterruptions = newInterruptionCount;
    externalInterruptionLabel.stringValue = [[a externalInterruptionCount] stringValue];
}

- (IBAction)internalInterruptionSelected:(id)sender;
{
    Activity *a = (Activity *)self.objectValue;
    Egg *p = [[a.eggs allObjects] lastObject];
    p.internalInterruptions = [NSNumber numberWithInt:[p.internalInterruptions intValue] + 1];
    internalInterruptionLabel.stringValue = [[a internalInterruptionCount] stringValue];
}

- (IBAction)toggleCompleteActivity:(id)sender;
{
    Activity *a = (Activity *)self.objectValue;
    BOOL completed = [a.completed boolValue];
    a.completed = [NSNumber numberWithBool:!completed];
    [a save];

    ribbonView.completed = !completed;
    [ribbonView setNeedsDisplay:YES];

    if(a == [Activity currentActivity] && [EggTimer currentTimer].status == TimerStatusRunning)
    {
        [[EggTimer currentTimer] stop];
    }
}

#pragma mark - NSTextField Delegate Methods

- (void)textDidEndEditing:(NSNotification *)aNotification
{
    Activity *a = (Activity *)self.objectValue;
    a.name = self.textField.stringValue;
    
    if(!a.sourceID)
       [[TaskSyncController currentController] saveNewActivity:a];
    [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVITY_MODIFIED object:a];
}

@end