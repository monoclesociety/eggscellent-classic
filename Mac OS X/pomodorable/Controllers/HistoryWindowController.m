//
//  NoteWindowController.m
//  pomodorable
//
//  Created by Kyle Kinkade on 2/28/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import "HistoryWindowController.h"
#import "HistoryTableCellView.h"
#import "ColorView.h"

@implementation HistoryWindowController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize activitySortDescriptors;

#pragma mark - memory based methods

- (id)initWithWindowNibName:(NSString *)windowNibName
{
    if(self = [super initWithWindowNibName:windowNibName])
    {
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
     
    //unify the background color for the contentView of the window as well as the content view of the scroll view
    ((ColorView *)self.window.contentView).backgroundColor =
    historyTableView.backgroundColor = 
    contentView.backgroundColor = [NSColor colorWithDeviceRed:0.969 green:0.965 blue:0.702 alpha:1.000];
    
    //set up the gradients!
    NSColor *stickyNoteColor = [NSColor colorWithDeviceRed:0.969 green:0.965 blue:0.702 alpha:1.000];
    NSColor *stickyNoteClearColor = [NSColor colorWithDeviceRed:0.969 green:0.965 blue:0.702 alpha:0.000];
    topGradient.topColor = stickyNoteColor;
    topGradient.bottomColor = stickyNoteClearColor;
    bottomGradient.topColor = stickyNoteClearColor;
    bottomGradient.bottomColor = stickyNoteColor;
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

- (NSArray *)activitySortDescriptors
{
    return [NSArray arrayWithObjects:
            [NSSortDescriptor sortDescriptorWithKey:@"completed"
                                          ascending:NO],
            nil];
}

- (NSPredicate *)filterPredicate
{
    return nil;
}

- (void)updateFirstAndLastDatesWithDelta:(int)delta
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setLocale:[NSLocale currentLocale]];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSUInteger components = NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents* comps = [calendar components:components
                                          fromDate:now];
    
    // set first of the month
    [comps setDay:1];
    firstDay = [calendar dateFromComponents:comps];

    // set last of month
    [comps setMonth:[comps month]+1];
    lastDay = [calendar dateFromComponents:comps];

    //this code is saved here because it is used for when we want weeks at a time.
//    NSUInteger components = NSYearForWeekOfYearCalendarUnit |NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
//    NSDateComponents *nowComponents = [calendar components:components fromDate:now];
//    [nowComponents setWeek:[nowComponents week] - delta];
//
//    [nowComponents setWeekday:1]; // 2: monday
//    firstDay = [calendar dateFromComponents:nowComponents];
//
//    [nowComponents setWeekday:7]; // 7: saturday
//    lastDay = [calendar dateFromComponents:nowComponents];
}

- (void)filterUpThatPredicate
{
    [self updateFirstAndLastDatesWithDelta:0];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"completed != nil AND (completed > %@ AND completed < %@)", firstDay, lastDay, nil];
   
    arrayController.fetchPredicate = predicate;
}

#pragma mark - IBActions

- (IBAction)close:(id)sender;
{
    [self close];
}


//- (void)showActivity:(Activity *)a forButton:(NSButton *)button;
//{
//    if(!popOver)
//    {
//        popOverController = [[HistoryPopOverViewController alloc] initWithNibName:@"HistoryPopOverViewController" bundle:nil];
//        popOver = [[RBLPopover alloc] initWithContentViewController:(NSViewController *)popOverController];
//    }
//    
//    popOver.behavior = RBLPopoverViewControllerBehaviorTransient;
//    [popOver showRelativeToRect:[button bounds] ofView:button preferredEdge:CGRectMinXEdge];
//    popOverController.activity = a;
//    popOver.backgroundView.fillColor = [NSColor colorWithCalibratedWhite:0.9254901961f alpha:1];
//    [popOver.contentViewController.view setNeedsDisplay:YES];
//}

#pragma mark - Image Drop NoteTextView Notifications

- (void)imageDropped:(NSNotification *)note
{
    
}

#pragma mark - TableView Delegate and Datasource methods

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    HistoryTableCellView *result = [historyTableView makeViewWithIdentifier:@"HistoryTableCellView" owner:self];
    
    Activity *a = [arrayController.arrangedObjects objectAtIndex:row];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"MMM dd"];
    
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *date = [formatter stringFromDate:a.completed];
    
    result.dateLabel.stringValue = [NSString stringWithFormat:@"%@", date, nil];
    
    
    int timerCount = (int)[a.completedEggs count];
    if(timerCount)
    {
        NSString *timerString = (timerCount > 1) ? @"%d timers" : @"%d timer";
        result.timersLabel.stringValue = [NSString stringWithFormat:timerString, timerCount, nil];
    
        int internal = [a.internalInterruptionCount intValue];
        int external = [a.externalInterruptionCount intValue];
        int totalDistractions = internal + external;
    
        if(totalDistractions)
            result.distractionsLabel.stringValue = [NSString stringWithFormat:@"%d distractions", totalDistractions, nil];
    }
    return result;
}

//- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row
//{
//    OverviewTableRowView *rowView = [[OverviewTableRowView alloc] init];
//    return rowView;
//}
//
//- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex
//{
//    return YES;
//}
////
//- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
//{
//    NSLog(@"OMFG HUUUU");
//}

@end