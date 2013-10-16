//
//  TaskSyncController.m
//  pomodorable
//
//  Created by Kyle Kinkade on 11/23/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//

#import "TaskSyncController.h"

@implementation TaskSyncController
@synthesize importedIDs;

#pragma mark - Class based methods

static TaskSyncController *singleton;
+ (TaskSyncController *)currentController;
{
    return singleton;
}

+ (void)setCurrentController:(TaskSyncController *)controller;
{
    singleton = controller;
}

#pragma mark - General methods
        
- (id)init
{
    self = [super init];
    if (self)
    {
        self.importedIDs = nil;
    }
    return self;
}

- (BOOL)sync
{
    return YES;
}

- (void)cleanUpSync
{
    [[ModelStore sharedStore] save];
    
    if(tasksChanged)
        [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_COMPLETED_WITH_CHANGES object:self];
}

- (void)dealloc
{
    [self cleanUpSync];
}

- (void)syncActivity:(Activity *)activity
{

}

- (void)saveNewActivity:(Activity *)activity;
{
    
}

#pragma mark - helper methods

- (void)completeActivitiesForSource:(ActivitySource)source withDictionary:(NSDictionary *)activityIDs;
{
    NSManagedObjectContext *pmoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    pmoc.parentContext = [ModelStore sharedStore].managedObjectContext;
    [pmoc performBlockAndWait:^{
        
        NSError *error;
        NSFetchRequest *fetchRequest = [[ModelStore sharedStore] fetchRequestForFilteredActivities];
        NSArray *results = [pmoc executeFetchRequest:fetchRequest error:&error];
        
        for(Activity *a in results)
        {
            int sourceInt = [a.source intValue];
            if(sourceInt == source)
            {
                if(![activityIDs valueForKey:a.sourceID] && (!a.completed))
                {
                    [a secretSetRemoved:[NSNumber numberWithBool:YES]];
                }
            }
        }
        
        error = nil;
        [pmoc save:&error];
        
        [[ModelStore sharedStore] save];
    }];
}

- (BOOL)syncWithDictionary:(NSDictionary *)dictionary
{
    __block BOOL result;
    
    NSManagedObjectContext *moc = [ModelStore sharedStore].managedObjectContext;
    
    NSNumber *status            = [dictionary objectForKey:@"status"];
    NSString *ID                = [dictionary objectForKey:@"ID"];
    NSString *name              = [dictionary objectForKey:@"name"];
    NSNumber *source            = [dictionary objectForKey:@"source"];
    
    //do a check to see if the item already exists
    if(![[ModelStore sharedStore] activityExistsForSourceID:ID])
    {
        [moc performBlockAndWait:^{
            
            Activity *newActivity = [Activity activity];
            newActivity.source = source;
            newActivity.name = name;
            newActivity.sourceID = ID;
            
            [newActivity secretSetCompleted:[status boolValue] ? [NSDate date] : nil];
            
            //add ID to the ID dictionary, to keep it safe
            result = YES;
            
        }];
    }
    else
    {
        [moc performBlockAndWait:^{
            
            NSError *error;
            
            // Create the fetch request for the entity.
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            
            // Edit the entity name as appropriate.
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:moc];
            
            //set up the fetchRequest
            [fetchRequest setEntity:entity];
            [fetchRequest setIncludesSubentities:NO];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"sourceID == %@", ID, nil]];

            NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
            Activity *existingActivity = [results objectAtIndex:0];
            
            NSString *munge = [NSString stringWithFormat:@"%@%@%@", existingActivity.name,
                               [existingActivity.removed stringValue],
                               [existingActivity.completed description],
                               nil];
                
            existingActivity.name = name;
            [existingActivity secretSetRemoved:[NSNumber numberWithBool:NO]];
            
            BOOL completedBool = (existingActivity.completed);
            BOOL statusBool = [status boolValue];
            
            if(completedBool != statusBool)
                [existingActivity secretSetCompleted:[status boolValue] ? [NSDate date] : nil];

            NSString *alter  = [NSString stringWithFormat:@"%@%@%@", existingActivity.name,
                               [existingActivity.removed stringValue],
                               [existingActivity.completed description],
                               nil];
            BOOL different = ![munge isEqualToString:alter];
            result = different;
            
        }];
    }
    
    [importedIDs setValue:ID forKey:ID];
    
    if(result)
        tasksChanged = YES;
    
    return result;
}

@end