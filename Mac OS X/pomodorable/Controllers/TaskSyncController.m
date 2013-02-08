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
    NSFetchRequest *fetchRequest = [[ModelStore sharedStore] fetchRequestForFilteredActivities];
    NSError *error;
	activities = [[ModelStore sharedStore].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return YES;
}

- (void)cleanUpSync
{
    [[ModelStore sharedStore] save];
    activities = nil;
}

- (void)dealloc
{
    [self cleanUpSync];
}

- (void)syncActivity:(Activity *)activity
{

}



#pragma mark - helper methods


- (void)completeActivitiesForSource:(ActivitySource)source withDictionary:(NSDictionary *)activityIDs;
{
    for(Activity *a in activities)
    {
        int sourceInt = [a.source intValue];
        if(sourceInt == source)
        {
            //if this item is not in the activities that we got from the list, then it no longer matches the criteria for us to care
            //we do a check here for !a.completed so we can keep a list of like 100 completed ribbons. cause that looks cool
            if(![activityIDs valueForKey:a.sourceID])
            {
                a.removed = [NSNumber numberWithBool:YES];
            }
        }
    }
    [[ModelStore sharedStore] save];
}

- (BOOL)syncWithDictionary:(NSDictionary *)dictionary
{
    //TODO: need to do a check for source in this predicate, just to make sure
    BOOL result;
    BOOL filterUnsizedTasks = [[NSUserDefaults standardUserDefaults] boolForKey:@"filterUnsizedTasks"];
    
    NSNumber *status            = [dictionary objectForKey:@"status"];
    NSString *ID                = [dictionary objectForKey:@"ID"];
    NSString *name              = [dictionary objectForKey:@"name"];
    NSNumber *plannedValue      = [dictionary objectForKey:@"plannedCount"];
    NSNumber *source            = [dictionary objectForKey:@"source"];
        
    //do a check to see if the item already exists
    NSArray *idArray = [activities filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"sourceID like[cd] %@", ID, nil]];
    if(![idArray count])
    {
        int plannedCount = [plannedValue intValue];
        
        //TODO: there should also be a check here to see if we're over the max pomodoro count for an Activity
        if(filterUnsizedTasks && plannedCount == 0)
            return NO;
        
        //if plannedCount is 0, then default to 1.
        plannedCount = (plannedCount == 0) ? 1 : plannedCount;

        Activity *newActivity = [Activity activity];
        newActivity.source = source;
        newActivity.name = name;
        newActivity.plannedCount = [NSNumber numberWithInt:plannedCount];
        newActivity.sourceID = ID;
        newActivity.completed = status; //this could be a 0, 1 or 2. right now if it is 1 or 2, it's completed :-P
        
        //add ID to the ID dictionary, to keep it safe
        result = YES;
    }
    else 
    {
        Activity *existingActivity = [idArray objectAtIndex:0];
        int plannedCount = [plannedValue intValue];
        if(filterUnsizedTasks && plannedCount == 0)
        {
            existingActivity.removed = [NSNumber numberWithBool:YES];
            return NO;
        }
        
        //if plannedCount is 0, then we'll stick with our last size thankyouverymuch
        plannedCount = (plannedCount == 0) ? [existingActivity.plannedCount intValue] : plannedCount;
        
        existingActivity.name = name;
        existingActivity.plannedCount = [NSNumber numberWithInt:plannedCount];
        [existingActivity secretSetCompleted:status];
        
        //add ID to ID dictionary, to keep it safe
        result = YES;
    }
    
    if(result)
        [importedIDs setValue:ID forKey:ID];
    
    return result;
}

- (int)countFromString:(NSString *)countString;
{
    countString = [[countString stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
    if([countString length] < 2)
        return 0;
    NSString *s = nil;
    if([countString characterAtIndex:1] == 'p')
    {
        unichar wtf = [countString characterAtIndex:0];
        s = [NSString stringWithCharacters:&wtf length:1];
    }
    
    int result = 0;
    if(s)
        result = [s intValue];
    
    return result;
}

@end