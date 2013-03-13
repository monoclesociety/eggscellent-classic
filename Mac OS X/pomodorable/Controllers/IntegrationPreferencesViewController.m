//
//  IntegrationPreferencesViewController.m
//  pomodorable
//
//  Created by Kyle Kinkade on 11/22/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//
#ifdef __MAC_10_8
#import <EventKit/EventKit.h>
#import "RemindersSyncController.h"
#endif

#import "AppDelegate.h"
#import "IntegrationPreferencesViewController.h"
#import "NSAttributedString+Hyperlink.h"

@implementation IntegrationPreferencesViewController
@synthesize window;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange:)
                                                 name:NSControlTextDidEndEditingNotification
                                               object:taskAwayMessage];
    
    int selectedTag = [[[NSUserDefaults standardUserDefaults] valueForKey:@"taskManagerType"] intValue];
    [taskSyncIntegration selectItemWithTag:selectedTag];
    
    
    if(NSClassFromString(@"NSUserNotification"))
    {
        NSMenuItem *reminderitem = [taskSyncIntegration itemAtIndex:1];
        [reminderitem setHidden:NO];
    }
}

- (void)viewWillAppear
{
    [self setupTaskList];
}

#pragma mark - Helper methods

- (void)setupURL:(NSURL *)url forTextField:(NSTextField *)textField
{
    // both are needed, otherwise hyperlink won't accept mousedown
    [textField setAllowsEditingTextAttributes: YES];
    [textField setSelectable: YES];
    
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc] init];
    [string appendAttributedString:[NSAttributedString hyperlinkFromString:textField.stringValue withURL:url]];
    
    // set the attributed string to the NSTextField
    [textField setAttributedStringValue: string];
}

- (void)setupTaskList
{
    if((int)[taskSyncIntegration selectedTag] == ActivitySourceReminders)
    {
        [taskList setHidden:NO];
        [taskListDescription setHidden:NO];
        [self populateRemindersList];
    }
    else
    {
        [taskList setHidden:YES];
        [taskListDescription setHidden:YES];
    }
}

- (void)populateRemindersList
{
    [taskList removeAllItems];
    AppDelegate *appDelegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
    RemindersSyncController *reminders = (RemindersSyncController *)appDelegate.taskSyncController;
    lists = [reminders calendarsForReminders];
    
    for(EKCalendar *list in lists)
    {
        [taskList addItemWithTitle:list.title];
    }
    
    EKCalendar *defaultList = [reminders defaultCalendar];
    [taskList selectItemWithTitle:defaultList.title];
}

#ifdef __MAC_10_8
#endif

#pragma mark - MASPreferencesViewController Methods

- (NSString *)identifier
{
    return @"Integration Preferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:@"tools"];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Integration", @"Toolbar item name for the General preference pane");
}

- (CGFloat)initialHeightOfView;
{
    return self.view.frame.size.height;
}

#pragma mark - IBActions

- (IBAction)helpSelected:(id)sender
{
    [[NSApplication sharedApplication] showHelp:nil];
}

- (IBAction)taskSyncChanged:(id)sender
{
    NSNumber *newlySelectedTag = [NSNumber numberWithInt:(int)[taskSyncIntegration selectedTag]];

    [[NSUserDefaults standardUserDefaults] setValue:newlySelectedTag forKey:@"taskManagerType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"taskManagerTypeChanged" object:newlySelectedTag];
    
    [self setupTaskList];
}

- (IBAction)taskListChanged:(id)sender;
{
    NSInteger index = taskList.indexOfSelectedItem;
    EKCalendar *calendar = [lists objectAtIndex:index];
    
    AppDelegate *appDelegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
    RemindersSyncController *reminders = (RemindersSyncController *)appDelegate.taskSyncController;
    reminders.defaultCalendar = calendar;
}

#pragma mark NSTextField Delegate Methods

- (void)textDidChange:(NSNotification *)aNotification
{
    BOOL konamiCode = [taskAwayMessage.stringValue isEqualToString:@"primer"];
    [[NSUserDefaults standardUserDefaults] setBool:konamiCode forKey:@"konami code"];
}

@end
