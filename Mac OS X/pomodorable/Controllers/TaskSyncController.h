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

@protocol TaskSyncControllerDatasource <NSObject>

@end

@interface TaskSyncController : NSObject
{
    NSArray *activities;
    NSMutableDictionary *importedIDs;
}
@property (strong, nonatomic) NSMutableDictionary *importedIDs;

- (BOOL)sync;
- (void)syncActivity:(Activity *)activity;
- (void)cleanUpSync;

- (void)completeActivitiesForSource:(ActivitySource)source withDictionary:(NSDictionary *)activityIDs;
- (BOOL)syncWithDictionary:(NSDictionary *)dictionary;

- (int)countFromString:(NSString *)countString;

@end
