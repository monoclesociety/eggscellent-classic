//
//  HistoryTableCellView.m
//  Eggscellent
//
//  Created by Kyle kinkade on 4/13/13.
//  Copyright (c) 2013 Monocle Society LLC. All rights reserved.
//

#import "HistoryTableCellView.h"

@implementation HistoryTableCellView
@synthesize dateLabel;
@synthesize timersLabel;
@synthesize distractionsLabel;
@synthesize checkmarkButton;

- (IBAction)toggleCompleteActivity:(id)sender
{
    Activity *a = (Activity *)self.objectValue;
    BOOL completed = (a.completed);
    
    NSDate *completedDate = completed ? nil : [NSDate date];
    a.completed = completedDate;
    [a save];
    
    if(a == [Activity currentActivity] && [EggTimer currentTimer].status == TimerStatusRunning)
    {
        [[EggTimer currentTimer] stop];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //center the text
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    pStyle.alignment = NSCenterTextAlignment;
    NSColor *txtColor = [NSColor colorWithSRGBRed:.4588235294 green:.4431372549 blue:.3490196078 alpha:1.0f];
    NSFont *txtFont = [NSFont fontWithName:@"Helvetica Neue" size:14];
    
    //set up stop/start/resume strings
    NSDictionary *txtDict = [NSDictionary dictionaryWithObjectsAndKeys:pStyle, NSParagraphStyleAttributeName,
                             txtFont, NSFontAttributeName,
                             txtColor,  NSForegroundColorAttributeName,
                             nil];
    NSMutableAttributedString *checkmark = [[NSMutableAttributedString alloc] initWithString:@"✓" attributes:txtDict];
    [checkmarkButton setAttributedTitle:checkmark];
}

//- (void)drawRect:(NSRect)dirtyRect
//{
//    [super drawRect:dirtyRect];
//    CGFloat maxY = NSMaxY(self.frame);
//    CGContextRef c = (CGContextRef )[[NSGraphicsContext currentContext] graphicsPort];
//    
//    CGColorRef black = CGColorCreateGenericRGB(83.0/255.0, 177.0/255.0, 215.0/255.0, 1);
//    CGContextSetStrokeColorWithColor(c, black);
//    CGContextBeginPath(c);
//    CGContextMoveToPoint(c, 0.0f, maxY - 2.5f);
//    CGContextAddLineToPoint(c, self.frame.size.width, maxY - 2.5f);
//    CGContextSetLineWidth(c, 1);
//    CGContextSetLineCap(c, kCGLineCapSquare);
//    CGContextClosePath(c);
//    CGContextStrokePath(c);
//    CGColorRelease(black);
//    
////    CGColorRef lightGrey = CGColorCreateGenericRGB(1, 1, 1, 1);
////    CGContextSetStrokeColorWithColor(c, lightGrey);
////    CGContextTranslateCTM(c, 0, 1);
////    CGContextBeginPath(c);
////    CGContextMoveToPoint(c, 0.0f, maxY - 4.5f);
////    CGContextAddLineToPoint(c, 320.0f, maxY - 4.5f);
////    CGContextSetLineWidth(c, 1);
////    CGContextSetLineCap(c, kCGLineCapSquare);
////    CGContextClosePath(c);
////    CGContextStrokePath(c);
////    CGColorRelease(lightGrey);
//}

@end
