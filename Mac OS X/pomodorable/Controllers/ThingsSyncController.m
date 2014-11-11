//
//  ThingsSyncController.m
//  pomodorable
//
//  Created by Kyle kinkade on 5/20/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import "ThingsSyncController.h"

@implementation ThingsSyncController

- (id)init
{
    self = [super init];
    if (self)
    {
        source = ActivitySourceThings;
    }
    return self;
}


#pragma mark - Things synchronization methods

- (BOOL)sync
{
    if([[NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.culturedcode.things"] count] == 0)
        return NO;
    
    if(!self.importedIDs)
    {
        [self prepare];
        [self superSync];
    }
    
    return YES;
}

- (void)presentThingsAlert
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applescriptAppicationNotInFolder" object:@"Things"];
}

- (void)superSync
{
    dispatch_async(queue, ^{
        
        NSAppleEventDescriptor *ed = [[ScriptManager sharedManager] executeScript:@"ThingsGetTodos"];

        if(!ed)
        {
            [self performSelectorOnMainThread:@selector(presentThingsAlert) withObject:nil waitUntilDone:NO];
            return;
        }
        
        self.importedIDs = [NSMutableDictionary dictionary];
        //if this is null, then things isn't running.
        DescType descType = [ed descriptorType];
        if(descType == 'null')
            return;
        
        NSAppleEventDescriptor *IDs = [ed descriptorAtIndex:1];
        NSAppleEventDescriptor *names = [ed descriptorAtIndex:2];
        NSAppleEventDescriptor *statuses = [ed descriptorAtIndex:3];
        NSAppleEventDescriptor *tagNames = [ed descriptorAtIndex:4];
        
        syncCount = (int)[IDs numberOfItems];
        if(!syncCount)
        {
            [self completeActivities];
            return;
        }

        tasksChanged = NO;
        int i = 1;
        for(; i <= syncCount; i++)
        {
            //set up id and name
            NSString *ID = [[IDs descriptorAtIndex:i] stringValue];
            if(!ID)
                continue;
            
            NSString *name = [[names descriptorAtIndex:i] stringValue];
            if(!ID)
                name = @"";
            
            //set up status
            NSString *statusString = [[statuses descriptorAtIndex:i] stringValue];
            NSNumber *status = [NSNumber numberWithInt:([statusString isEqualToString:@"tdcm"]) ? 1 : 0];
            
            //set up the tags
            NSNumber *plannedCount = [self extractPlannedCountFromTagNames:[[tagNames descriptorAtIndex:i] stringValue]];
            
            //set up source and piece it all together
            NSDictionary *syncDictionary = [NSDictionary dictionaryWithObjectsAndKeys:ID,@"ID",status,@"status",name,@"name", plannedCount, kPlannedCountKey, nil];
            
            [self syncWithDictionary:syncDictionary];
        }
    });
}

- (NSNumber *)extractPlannedCountFromTagNames:(NSString *)tagNames
{
    //TagNames contains a csv tags list
    tagNames = [tagNames lowercaseString];
    NSArray *tags = [tagNames componentsSeparatedByString:@","];
    
    NSInteger plannedCount = 1;
    for (NSString *tag in tags) {
        BOOL tagContainsEggs = [tag rangeOfString:@"eggs"].location != NSNotFound;
        BOOL tagContainsPomodoro = [tag rangeOfString:@"pomodoro"].location != NSNotFound;
        if (tagContainsEggs || tagContainsPomodoro) {
            plannedCount = MAX(plannedCount, [tag integerValue]);
        }
    }
    
    return @(MIN(plannedCount, MAX_EGG_COUNT));
}

- (void)saveNewActivity:(Activity *)activity;
{
    
    dispatch_async(queue, ^{
        
        NSString *scriptName = @"ThingsAddTodo";
        NSAppleEventDescriptor *ed = [[ScriptManager sharedManager] executeScript:scriptName withParameter:activity.name];
        
        //Things gives us an ID back, so let's save it to the activity
        NSAppleEventDescriptor *ID = [ed descriptorForKeyword:'seld'];
        activity.source = [NSNumber numberWithInt:ActivitySourceThings];
        activity.sourceID = [ID stringValue];

        [[ModelStore sharedStore] save];
        
    });

}

- (void)syncActivity:(Activity *)activity
{
    if([activity.source intValue] != ActivitySourceThings)
        return;
    
    NSString *statusString = (activity.completed || [activity.removed boolValue]) ? @"completed" : @"open";
    NSString *nameString = activity.name;
    NSString *activityID = [activity.sourceID copy];
    NSArray *array = [[NSArray alloc] initWithObjects:activityID, statusString, nameString, nil];
    [self performSelectorInBackground:@selector(syncActivityThread:) withObject:array];
}

- (void)syncActivityThread:(NSArray *)activity
{
    @autoreleasepool
    {
        NSString *scriptName = @"ThingsChangeTodo";
        [[ScriptManager sharedManager] executeScript:scriptName withParameters:activity];
    }
}

@end