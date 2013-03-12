//
//  RemindersSyncController.h
//  pomodorable
//
//  Created by Kyle kinkade on 5/20/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#ifdef __MAC_10_8
#import <EventKit/EventKit.h>
#endif

#import <Foundation/Foundation.h>
#import "TaskSyncController.h"

@class EKEventStore;
@interface RemindersSyncController : TaskSyncController
{
    BOOL lameSyncActivityHack;
}
@property (strong) EKEventStore *mainStore;
@property (strong) EKCalendar *defaultCalendar;
- (void)superSync;
- (NSArray *)calendarsForReminders;

@end
