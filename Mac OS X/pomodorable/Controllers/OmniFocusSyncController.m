//
//  OmniFocusSyncController.m
//  pomodorable
//
//  Created by Kyle kinkade on 5/20/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import "OmniFocusSyncController.h"

@interface OmniFocusSyncController (private)

- (int)getOmniFocusPlannedCountFromContextWithID:(NSString *)contextID;

@end

@implementation OmniFocusSyncController

#pragma mark - OmniFocus synchronization methods

- (id)init
{
    self = [super init];
    if (self)
    {
        self.syncThread = nil;
    }
    return self;
}


- (BOOL)sync
{
    NSArray *runningApps1 = [NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.omnigroup.OmniFocus"];
    NSArray *runningApps2 = [NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.omnigroup.OmniFocus.MacAppStore"];
    
    if ([runningApps1 count] == 0 && [runningApps2 count] == 0)
        return NO;
    
    if(!importedIDs)
    {
        [super sync];
        self.syncThread = [[NSThread alloc] initWithTarget:self selector:@selector(threadSync) object:nil];
        [self.syncThread start];
    }

    return YES;
}

- (void)presentOmniFocusAlert
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applescriptAppicationNotInFolder" object:@"OmniFocus"];
}
- (void)threadSync
{
    @autoreleasepool {
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
//        NSAppleEventDescriptor *minutes = [ed descriptorAtIndex:3];
        
        int count = (int)[IDs numberOfItems];
        
        int i = 1;
        for(; i <= count; i++)
        {
            //setup name and id
            NSString *ID = [[IDs descriptorAtIndex:i] stringValue];
            NSString *name = [[names descriptorAtIndex:i] stringValue];
            
            NSNumber *status = [NSNumber numberWithBool:NO]; //for now defaulting to incomplete
            NSNumber *source = [NSNumber numberWithInt:ActivitySourceOmniFocus];

//            NSString *minutesString = [[minutes descriptorAtIndex:i] stringValue];
//            int minutes = [minutesString intValue];
//            NSNumber *pomodoroMinutes = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"pomodoroMinutes"];
//            int minutesPlannedCount = 0;
//            if(minutes)
//                minutesPlannedCount = minutes / [pomodoroMinutes intValue];
//            
//            minutesPlannedCount = MIN(minutes, MAX_EGG_COUNT);
//            
//            NSNumber *plannedCount = [NSNumber numberWithInt:minutesPlannedCount];
            
            NSNull *plannedCount = [NSNull null];
            NSDictionary *syncDictionary = [NSDictionary dictionaryWithObjectsAndKeys:ID,@"ID",status,@"status",name,@"name",plannedCount, @"plannedCount", source, @"source", nil];
            
            [self syncWithDictionary:syncDictionary];
        }
        
        [self completeActivitiesForSource:ActivitySourceOmniFocus withDictionary:importedIDs];
        [self cleanUpSync];
        
        self.importedIDs = nil;
    }
}

- (void)syncActivity:(Activity *)activity
{
    //if it doesn't have an external id, then don't sync. duh :-P
    if([activity.source intValue] != ActivitySourceOmniFocus)
        return;
    
    NSString *scriptName = @"OmniFocusChangeTodo";
    NSString *statusString = (activity.completed) ? @"true" : @"false";
    NSString *activityID = [activity.sourceID copy];
    NSString *nameString = activity.name;
    [[ScriptManager sharedManager] executeScript:scriptName withParameters:[NSArray arrayWithObjects:activityID, statusString, nameString, nil]];
}

- (int)getOmniFocusPlannedCountFromContextWithID:(NSString *)contextID
{
    int result = 0;
    NSAppleEventDescriptor *ed = [[ScriptManager sharedManager] executeScript:@"OmniFocusGetTaskContext" withParameter:contextID];
    
    //if this is null, then things isn't running.
    DescType descType = [ed descriptorType];
    if(descType == 'null')
        return 0;
    
    int count = (int)[ed numberOfItems];
    
    int i = 1;
    for(; i <= count; i++)
    {
        NSAppleEventDescriptor *item = [ed descriptorAtIndex:i];
        int itemIntValue = [[item stringValue] intValue];
        if(itemIntValue > result)
            result = itemIntValue;
    }
    
    return result;
}

- (NSString *)appID
{
    return @"com.omnigroup.omnifocus";
}

@end
