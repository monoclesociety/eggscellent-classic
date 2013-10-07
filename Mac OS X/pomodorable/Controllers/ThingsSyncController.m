//
//  ThingsSyncController.m
//  pomodorable
//
//  Created by Kyle kinkade on 5/20/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import "ThingsSyncController.h"

@implementation ThingsSyncController
@synthesize syncThread;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.syncThread = nil;
    }
    return self;
}


#pragma mark - Things synchronization methods

- (BOOL)sync
{
    if([[NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.culturedcode.things"] count] == 0)
        return NO;
    
    if(!importedIDs)
    {
        [super sync];
        self.syncThread = [[NSThread alloc] initWithTarget:self selector:@selector(threadSync) object:nil];
        [self.syncThread start];
    }
    
    return YES;
}

- (void)presentThingsAlert
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applescriptAppicationNotInFolder" object:@"Things"];
}

- (void)threadSync
{
    @autoreleasepool
    {
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
        
        int count = (int)[IDs numberOfItems];

        tasksChanged = NO;
        int i = 1;
        for(; i <= count; i++)
        {
            //set up id and name
            NSString *ID = [[IDs descriptorAtIndex:i] stringValue];
            if(!ID)
                continue;
            
            NSString *name = [[names descriptorAtIndex:i] stringValue];
            if(!ID)
                name = @"";
            
            //set up status
            NSString *statusString = [[statuses descriptorAtIndex:i] stringValue]; //0 = incomplete, 1 = complete, 2++ whatever we need to account for
            NSNumber *status = [NSNumber numberWithInt:([statusString isEqualToString:@"tdcm"]) ? 1 : 0];
            
            //set up source and piece it all together
            NSNumber *source = [NSNumber numberWithInt:ActivitySourceThings];
            NSDictionary *syncDictionary = [NSDictionary dictionaryWithObjectsAndKeys:ID,@"ID",status,@"status",name,@"name", source, @"source", nil];
            
            [self performSelectorOnMainThread:@selector(syncWithDictionary:) withObject:syncDictionary waitUntilDone:YES];
        }
        
        [self completeActivitiesForSource:ActivitySourceThings withDictionary:importedIDs];
        [self cleanUpSync];

        self.importedIDs = nil;
    }
}

- (void)saveNewActivity:(Activity *)activity;
{
    @autoreleasepool
    {
        NSString *scriptName = @"ThingsAddTodo";
        NSAppleEventDescriptor *ed = [[ScriptManager sharedManager] executeScript:scriptName withParameter:activity.name];
        
        //Things gives us an ID back, so let's save it to the activity
        NSAppleEventDescriptor *ID = [ed descriptorForKeyword:'seld'];
        activity.source = [NSNumber numberWithInt:ActivitySourceThings];
        activity.sourceID = [ID stringValue];
    }
}

- (void)syncActivity:(Activity *)activity
{
    //if it doesn't have an external id, then don't sync. duh :-P
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