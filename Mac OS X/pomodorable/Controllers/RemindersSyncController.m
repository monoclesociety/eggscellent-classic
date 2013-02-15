//
//  RemindersSyncController.m
//  pomodorable
//
//  Created by Kyle kinkade on 5/20/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import "RemindersSyncController.h"

@implementation RemindersSyncController
#ifdef __MAC_10_8

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialize self.
        mainStore = [[EKEventStore alloc] initWithAccessToEntityTypes:EKEntityMaskReminder];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(storeChanged:)
                                                     name:EKEventStoreChangedNotification
                                                   object:mainStore];
        [self superSync];
    }
    return self;
}

- (void)superSync;
{
    self.importedIDs = [NSMutableDictionary dictionary];
    
    // Get the appropriate calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Create the start date components
    NSDateComponents *startDateComponents = [[NSDateComponents alloc] init];
    startDateComponents.day = -60;
    NSDate *startDate = [calendar dateByAddingComponents:startDateComponents
                                                  toDate:[NSDate date]
                                                 options:0];
    
    // Create the end date components
    NSDateComponents *endDateComponents = [[NSDateComponents alloc] init];
    endDateComponents.day = 1;
    NSDate *endDate = [calendar dateByAddingComponents:endDateComponents
                                                       toDate:[NSDate date]
                                                      options:0];
    
    // Create the predicate. eventStore is an instance variable.
    NSPredicate *predicate = [mainStore predicateForIncompleteRemindersWithDueDateStarting:startDate
                                                                                    ending:endDate
                                                                                 calendars:nil];
    
    
    [mainStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders)
     {
         for(EKReminder *reminder in reminders)
         {
             NSString *ID = reminder.calendarItemExternalIdentifier;//.calendarItemIdentifier;
             NSString *name = reminder.title;
             NSNull *plannedCount = [NSNull null];
             NSNumber *source = [NSNumber numberWithInt:ActivitySourceReminders];
             NSNumber *status = [NSNumber numberWithBool:reminder.completed];
             
             NSDictionary *syncDictionary = [NSDictionary dictionaryWithObjectsAndKeys:ID,@"ID",status,@"status",name,@"name",plannedCount, @"plannedCount", source, @"source", nil];
             
             [self syncWithDictionary:syncDictionary];
         }
         
         [self completeActivitiesForSource:ActivitySourceThings withDictionary:importedIDs];
         [self cleanUpSync];
     }];
}

- (BOOL)sync
{
    return YES;
}

- (void)syncActivity:(Activity *)activity
{
    if([activity.source intValue] != ActivitySourceReminders)
        return;

    EKReminder *reminder = (EKReminder *)[[mainStore calendarItemsWithExternalIdentifier:activity.sourceID] lastObject];
    reminder.completed = [activity.completed boolValue];
    reminder.title = activity.name;
    
    lameSyncActivityHack = YES;
    [mainStore saveReminder:reminder commit:YES error:NULL];
}

- (void)dealloc
{
    mainStore = nil;

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

#endif
@end
