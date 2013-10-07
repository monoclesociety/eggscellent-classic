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
    BOOL tasksChanged;
    NSMutableDictionary *importedIDs;
}
@property (strong, nonatomic) NSMutableDictionary *importedIDs;

+ (TaskSyncController *)currentController;
+ (void)setCurrentController:(TaskSyncController *)controller;

- (BOOL)sync;
- (void)syncActivity:(Activity *)activity;
- (void)saveNewActivity:(Activity *)activity;
- (void)cleanUpSync;

- (void)completeActivitiesForSource:(ActivitySource)source withDictionary:(NSDictionary *)activityIDs;
- (BOOL)syncWithDictionary:(NSDictionary *)dictionary;

@end
