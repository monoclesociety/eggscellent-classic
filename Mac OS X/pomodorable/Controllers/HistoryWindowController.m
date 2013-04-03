//
//  NoteWindowController.m
//  pomodorable
//
//  Created by Kyle Kinkade on 2/28/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import "HistoryWindowController.h"
#import "ColorView.h"

@implementation HistoryWindowController
@synthesize managedObjectContext = _managedObjectContext;

#pragma mark - memory based methods

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) 
    {
        // Initialization code here.
        _managedObjectContext = [[ModelStore sharedStore] managedObjectContext];
    }

    return self;
}

#pragma mark - NSWindowController Lifecycle

- (void)windowDidLoad
{
    //set up all the pretty window stuffs
    [super windowDidLoad];
    [self.window setLevel:NSFloatingWindowLevel];
    [self.window setAcceptsMouseMovedEvents:YES];
    [self.window setMovableByWindowBackground:YES];
    [self.window setOpaque:NO];
    [self.window setStyleMask:NSResizableWindowMask];
    
    [self filterUpThatPredicate];//look i'm sure you from the future is all like "what a lame name, why did he even do that? cause I can. eat it."
    
    //set up "clear" button font and color
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];    
    pStyle.alignment = NSCenterTextAlignment;
    NSColor *txtColor = [NSColor colorWithDeviceRed:0.423 green:0.415 blue:0.317 alpha:1];
    NSFont *txtFont = [NSFont systemFontOfSize:12];
    
    NSDictionary *txtDict = [NSDictionary dictionaryWithObjectsAndKeys:pStyle, NSParagraphStyleAttributeName, txtFont, NSFontAttributeName, txtColor,  NSForegroundColorAttributeName, nil];
    NSAttributedString *stopString = [[NSMutableAttributedString alloc] initWithString:@"Done" attributes:txtDict];
    [clearButton setAttributedTitle:stopString];
    
    //unify the background color for the contentView of the window as well as the content view of the scroll view
    ((ColorView *)self.window.contentView).backgroundColor =
    contentView.backgroundColor =
    scrollContentView.backgroundColor = [NSColor colorWithDeviceRed:0.969 green:0.965 blue:0.702 alpha:1.000];
}

- (void)showWindow:(id)sender
{
    [super showWindow:sender];
    
    arrayController.filterPredicate = [self filterPredicate];
}

- (void)close
{
    [super close];
}

#pragma mark - Internal methods

- (NSPredicate *)filterPredicate
{
    return nil;
}

- (void)filterUpThatPredicate
{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setLocale:[NSLocale currentLocale]];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *nowComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];
    today = [calendar dateFromComponents:nowComponents];
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"completed != nil", today, nil];
    [fetchRequest setPredicate:predicate];
    
    arrayController.fetchPredicate = predicate;
}

#pragma mark - IBActions

- (IBAction)clearTextSelected:(id)sender;
{
    
}

- (IBAction)close:(id)sender;
{
    [self close];
}

#pragma mark - Image Drop NoteTextView Notifications

- (void)imageDropped:(NSNotification *)note
{
    
}

@end