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
@interface TaskSyncController : NSObject
{
    ActivitySource source;
    NSMutableDictionary *importedIDs;
    
    int syncCount;
    int currentCount;
    BOOL tasksChanged;
}
@property (strong, nonatomic) NSMutableDictionary *importedIDs;

+ (TaskSyncController *)currentController;
+ (void)setCurrentController:(TaskSyncController *)controller;

- (BOOL)sync;
- (void)syncActivity:(Activity *)activity;
- (void)saveNewActivity:(Activity *)activity;
- (void)cleanUpSync;

- (void)completeActivities;
- (void)syncWithDictionary:(NSDictionary *)dictionary;

@end
