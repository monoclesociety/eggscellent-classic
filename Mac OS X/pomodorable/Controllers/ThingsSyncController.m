//
//  ThingsSyncController.m
//  pomodorable
//
//  Created by Kyle kinkade on 5/20/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import "ThingsSyncController.h"

@interface ThingsSyncController (private)

- (int)getThingsPlannedCountInTagArray:(NSArray *)tagArray;

@end

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
    @autoreleasepool {
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
        NSAppleEventDescriptor *tiggles = [ed descriptorAtIndex:3];
        NSAppleEventDescriptor *statuses = [ed descriptorAtIndex:4];
        
        int count = (int)[IDs numberOfItems];

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
            NSNumber *status = [NSNumber numberWithInt:0]; //by default mark as complete
            if([statusString isEqualToString:@"tdcm"])
            {
                status = [NSNumber numberWithInt:1];
            }
            else if([statusString isEqualToString:@"tdcl"])
            {
                status = [NSNumber numberWithInt:2];//TODO: We currently aren't handling cancelled items.
            }
            if(!status)
                status = [NSNumber numberWithInt:0];
            
            //set up tags
            NSAppleEventDescriptor *itemTags = [tiggles descriptorAtIndex:i];
            int tagCount = (int)[itemTags numberOfItems];
            NSMutableArray *tagArray = [NSMutableArray arrayWithCapacity:tagCount];
            int x = 1;
            for(; x <= tagCount; x++)
            {
                [tagArray addObject:[[itemTags descriptorAtIndex:x] stringValue]];
            }
            NSNumber *plannedCount = [NSNumber numberWithInt:[self getThingsPlannedCountInTagArray:tagArray]];
            if(!plannedCount)
                plannedCount = [NSNumber numberWithInt:0];
            else
                plannedCount = [NSNumber numberWithInt:MIN([plannedCount intValue], 7)];
            
            //set up source and piece it all together
            NSNumber *source = [NSNumber numberWithInt:ActivitySourceThings];
            NSDictionary *syncDictionary = [NSDictionary dictionaryWithObjectsAndKeys:ID,@"ID",status,@"status",name,@"name",plannedCount, @"plannedCount", source, @"source", nil];
            
            [self performSelectorOnMainThread:@selector(syncWithDictionary:) withObject:syncDictionary waitUntilDone:NO];
            //[self syncWithDictionary:syncDictionary];
        }
        
        [self completeActivitiesForSource:ActivitySourceThings withDictionary:importedIDs];
        [self cleanUpSync];

        self.importedIDs = nil;
    }
}

- (void)syncActivity:(Activity *)activity
{
    //if it doesn't have an external id, then don't sync. duh :-P
    if([activity.source intValue] != ActivitySourceThings)
        return;
    
    NSString *statusString = [activity.completed boolValue] ? @"completed" : @"open";
    NSString *nameString = activity.name;
    NSString *activityID = [activity.sourceID copy];
    NSArray *array = [[NSArray alloc] initWithObjects:activityID, statusString, nameString, nil];
    [self performSelectorInBackground:@selector(syncActivityThread:) withObject:array];
    
}

- (void)syncActivityThread:(NSArray *)activity
{
    @autoreleasepool {
    
        NSString *scriptName = @"ThingsChangeTodo";
        [[ScriptManager sharedManager] executeScript:scriptName withParameters:activity];
    
    }
}

- (int)getThingsPlannedCountInTagArray:(NSArray *)tagArray
{
    int plannedCount = 0;
    for(NSString *tag in tagArray)
    {            
        int currentPlannedCount = [self countFromString:tag];
        if(currentPlannedCount > plannedCount)
            plannedCount = currentPlannedCount;
    }
    return plannedCount;
}

@end