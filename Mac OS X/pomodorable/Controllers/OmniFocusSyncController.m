//
//  OmniFocusSyncController.m
//  pomodorable
//
//  Created by Kyle kinkade on 5/20/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import "OmniFocusSyncController.h"

@implementation OmniFocusSyncController

#pragma mark - OmniFocus synchronization methods

- (id)init
{
    self = [super init];
    if (self)
    {
        source = ActivitySourceOmniFocus;
    }
    return self;
}

- (BOOL)sync
{
    NSArray *runningApps1 = [NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.omnigroup.OmniFocus2"];
    NSArray *runningApps2 = [NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.omnigroup.OmniFocus2.MacAppStore"];
    
    if ([runningApps1 count] == 0 && [runningApps2 count] == 0)
        return NO;
    
    if(!self.importedIDs)
    {
        [self prepare];
        [self superSync];
    }

    return YES;
}

- (void)presentOmniFocusAlert
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applescriptAppicationNotInFolder" object:@"OmniFocus"];
}

- (void)superSync
{
    dispatch_async(queue, ^{
        
        NSAppleEventDescriptor *ed = [[ScriptManager sharedManager] executeScript:@"OmniFocusGetTodos"];
        
        if(!ed)
        {
            [self performSelectorOnMainThread:@selector(presentOmniFocusAlert) withObject:nil waitUntilDone:NO];
            return;
        }
        
        self.importedIDs = [NSMutableDictionary dictionary];
        //if this is null, then OmniFocus isn't running.
        DescType descType = [ed descriptorType];
        if(descType == 'null')
            return;
        
        NSAppleEventDescriptor *IDs     = [ed descriptorAtIndex:1];
        NSAppleEventDescriptor *names   = [ed descriptorAtIndex:2];
        NSAppleEventDescriptor *completeds   = [ed descriptorAtIndex:3];
        
        syncCount = (int)[IDs numberOfItems];
        if(!syncCount)
        {
            [self completeActivities];
            return;
        }
        
        int i = 1;
        for(; i <= syncCount; i++)
        {
            //setup name and id
            NSString *ID = [[IDs descriptorAtIndex:i] stringValue];
            NSString *name = [[names descriptorAtIndex:i] stringValue];
            
            Boolean b = [[completeds descriptorAtIndex:i] booleanValue];
            BOOL completed = b ? YES : NO;
            
            NSNumber *status = [NSNumber numberWithBool:completed]; //for now defaulting to incomplete
            NSDictionary *syncDictionary = [NSDictionary dictionaryWithObjectsAndKeys:ID,@"ID",status,@"status",name,@"name", nil];
            
            [self syncWithDictionary:syncDictionary];
        }
        
    });
}

- (void)saveNewActivity:(Activity *)activity;
{
    dispatch_async(queue, ^{
        
        NSString *scriptName = @"OmniFocusAddTodos";
        NSAppleEventDescriptor *ed = [[ScriptManager sharedManager] executeScript:scriptName withParameter:activity.name];
        
        //Things gives us an ID back, so let's save it to the activity
        NSAppleEventDescriptor *ID = [ed descriptorForKeyword:'seld'];
        NSString *idValue = [ID stringValue];
        activity.sourceID = idValue;
        activity.source = [NSNumber numberWithInt:ActivitySourceOmniFocus];
        
        [[ModelStore sharedStore] save];
        
    });
}

- (void)syncActivity:(Activity *)activity
{
    //if it doesn't have an external id, then don't sync. duh :-P
    if([activity.source intValue] != ActivitySourceOmniFocus)
        return;
    
    NSString *scriptName = @"OmniFocusChangeTodo";
    NSString *statusString = (activity.completed || [activity.removed boolValue]) ? @"true" : @"false";
    NSString *activityID = [activity.sourceID copy];
    NSString *nameString = activity.name;
    [[ScriptManager sharedManager] executeScript:scriptName withParameters:[NSArray arrayWithObjects:activityID, statusString, nameString, nil]];
}

- (NSString *)appID
{
    return @"com.omnigroup.OmniFocus2";
}

@end
