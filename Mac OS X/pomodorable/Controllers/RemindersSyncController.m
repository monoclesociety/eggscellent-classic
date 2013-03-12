//
//  RemindersSyncController.m
//  pomodorable
//
//  Created by Kyle kinkade on 5/20/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import "RemindersSyncController.h"

@implementation RemindersSyncController
@synthesize mainStore = _mainStore;
@synthesize defaultCalendar = _defaultCalendar;

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialize self.
        self.mainStore = [[EKEventStore alloc] initWithAccessToEntityTypes:EKEntityMaskReminder];

//        EKCalendar *shouldFail = [self.mainStore calendarWithIdentifier:@"imasuck!"];
//        EKCalendar *adf = self.mainStore.defaultCalendarForNewReminders;
//        NSLog(@"default calendar: %@", adf.title, nil);
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(storeChanged:)
                                                     name:EKEventStoreChangedNotification
                                                   object:_mainStore];
    }
    return self;
}

- (void)superSync;
{
    self.importedIDs = [NSMutableDictionary dictionary];
    
    // Get the appropriate calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
     
    // Create the end date components
    NSDateComponents *endDateComponents = [[NSDateComponents alloc] init];
    endDateComponents.day = 1;
    NSDate *endDate = [calendar dateByAddingComponents:endDateComponents
                                                       toDate:[NSDate date]
                                                      options:0];
    
    // Create the predicate. eventStore is an instance variable.
    NSPredicate *predicate = [_mainStore predicateForIncompleteRemindersWithDueDateStarting:nil
                                                                                    ending:endDate
                                                                                 calendars:nil];

    [_mainStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders)
    {
//        NSLog(@"number of reminders: %ld", (unsigned long)[reminders count
//                                                           ], nil);
         for(EKReminder *reminder in reminders)
         {
             NSString *ID = reminder.calendarItemExternalIdentifier;
             NSString *name = reminder.title;
             NSNull *plannedCount = [NSNull null];
             NSNumber *source = [NSNumber numberWithInt:ActivitySourceReminders];
             NSNumber *status = [NSNumber numberWithBool:reminder.completed];
             
             NSDictionary *syncDictionary = [NSDictionary dictionaryWithObjectsAndKeys:ID,@"ID",status,@"status",name,@"name",plannedCount, @"plannedCount", source, @"source", nil];
             
             [self syncWithDictionary:syncDictionary];
         }
         
         [self completeActivitiesForSource:ActivitySourceReminders withDictionary:importedIDs];
         [self cleanUpSync];
     }];
}

- (BOOL)sync
{
    if(lameSyncActivityHack)
    {
        lameSyncActivityHack = NO;
        return NO;
    }

    [self superSync];
    return YES;
}

- (void)syncActivity:(Activity *)activity
{
    if([activity.source intValue] != ActivitySourceReminders)
        return;

    EKReminder *reminder = (EKReminder *)[[_mainStore calendarItemsWithExternalIdentifier:activity.sourceID] lastObject];
    reminder.completed = [activity.completed boolValue];
    reminder.title = activity.name;
    
    lameSyncActivityHack = YES;
    [_mainStore saveReminder:reminder commit:YES error:NULL];
}

- (void)dealloc
{
    _mainStore = nil;
}

#pragma mark - EKEventStore Notifications

- (void)storeChanged:(NSNotification *)notification
{
    if(lameSyncActivityHack)
    {
        lameSyncActivityHack = NO;
        return;
    }
    [self superSync];
}

#pragma mark - EKEventStore Stack

- (NSArray *)calendarsForReminders
{
    NSArray *arr = nil;
    arr = [_mainStore calendarsForEntityType:EKEntityTypeReminder];
    return arr;
}

- (void)setSystemReminderAsDefault
{
    EKCalendar *defCalendar = _mainStore.defaultCalendarForNewReminders;
    self.defaultCalendar = defCalendar;
    [[NSUserDefaults standardUserDefaults] setValue:_defaultCalendar.calendarIdentifier forKey:@"remindersCalendarIdentifier"];
}

- (void)setDefaultCalendar:(EKCalendar *)defaultCalendar
{
    _defaultCalendar = defaultCalendar;
    NSString *sourceIdentifier = _defaultCalendar.calendarIdentifier;
    [[NSUserDefaults standardUserDefaults] setObject:sourceIdentifier forKey:@"remindersCalendarIdentifier"];
}

- (EKCalendar *)defaultCalendar
{
    if(_defaultCalendar)
        return _defaultCalendar;
    
    NSString *calendarIdentifier = [[NSUserDefaults standardUserDefaults] stringForKey:@"remindersCalendarIdentifier"];
    if(!calendarIdentifier)
    {
        [self setSystemReminderAsDefault];
    }
    else
    {
        _defaultCalendar = [_mainStore calendarWithIdentifier:calendarIdentifier];
        if(!_defaultCalendar)
        {
            [self setSystemReminderAsDefault];
        }
    }
    
    return _defaultCalendar;
}
@end
