//
//  TaskSyncController.h
//  pomodorable
//
//  Created by Kyle Kinkade on 11/23/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptManager.h"
#import "ModelStore.h"

#define SYNC_COMPLETED_WITH_CHANGES @"SYNC_COMPLETED_WITH_CHANGES"

extern NSString * const kPlannedCountKey;

@interface TaskSyncController : NSObject
{
    ActivitySource source;
    int syncCount;
    int currentCount;
    BOOL tasksChanged;
    
    dispatch_queue_t queue;
}
@property (strong, nonatomic) NSMutableDictionary *importedIDs;
@property (strong) NSManagedObjectContext *pmoc;

+ (TaskSyncController *)currentController;
+ (void)setCurrentController:(TaskSyncController *)controller;

- (BOOL)sync;
- (void)syncActivity:(Activity *)activity;
- (void)saveNewActivity:(Activity *)activity;
- (void)cleanUpSync;
- (void)prepare;

- (void)completeActivities;
- (void)syncWithDictionary:(NSDictionary *)dictionary;

@end
