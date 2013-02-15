//
//  ModelStore.m
//  SeriouslyOSX
//
//  Created by Kyle Kinkade on 11/5/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//

#import "ModelStore.h"

@implementation ModelStore
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize managedObjectContext = __managedObjectContext;

+ (ModelStore *)sharedStore;
{
    static ModelStore *singleton;
    if(!singleton)
    {
        singleton = [[ModelStore alloc] init];
    }
    return singleton;
}


#pragma mark - methods

-(BOOL)save;
{
    if (!__managedObjectContext) 
    {
        return YES;
    }
    
    if (![[self managedObjectContext] commitEditing]) 
    {
        return NO;
    }
    
    if (![[self managedObjectContext] hasChanges]) 
    {
        return YES;
    }
    
    __block NSError *error = nil;

    [__managedObjectContext performBlock:^{
        [__managedObjectContext save:&error];
        }];
    return (!error);
}

- (NSEntityDescription *)entityForModelType:(NSString *)modelType
{
	return [NSEntityDescription entityForName:modelType
					   inManagedObjectContext:[self managedObjectContext]];
}

- (id)newModelWithClassName:(NSString *)className;
{
    return [NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:self.managedObjectContext];
}

- (NSArray *)allWithClassName:(NSString *)className;
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [self entityForModelType:className];
    fetchRequest.sortDescriptors = nil;
    
	NSError *error;
	NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return array;
}

- (NSInteger)countForEntityType:(NSString *)entityType withPredicate:(NSPredicate *)predicate;
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [self entityForModelType:entityType];
    fetchRequest.sortDescriptors = nil;
    fetchRequest.predicate = predicate;
    
    return [self.managedObjectContext countForFetchRequest:fetchRequest error:NULL];
}

#pragma mark - Type Specific methods

- (NSFetchRequest *)fetchRequestForFilteredActivities;
{
    //create the Date for 12am today
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setLocale:[NSLocale currentLocale]];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *nowComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];
    today = [calendar dateFromComponents:nowComponents];
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *completedDescriptor = [[NSSortDescriptor alloc] initWithKey:@"completed" ascending:YES];
    NSSortDescriptor *createdDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:completedDescriptor, createdDescriptor, nil];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"((removed == 0) AND (completed == 0)) OR (completed == 1 AND modified > %@ and removed == 0)", today, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:predicate];
    
    
    return fetchRequest;
}

- (BOOL)activityExistsForSourceID:(NSString *)sourceID
{
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    [fetchRequest setIncludesSubentities:NO];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"sourceID == %@", sourceID, nil]];
    
    NSError *error = nil;
    NSUInteger count = [self.managedObjectContext countForFetchRequest: fetchRequest error: &error];
    
    return (count != 0);
}

#pragma mark - core data stack

/**
 Returns the directory the application uses to store the Core Data store file. This code uses a directory named "SeriouslyOSX" in the user's Library directory.
 */
- (NSURL *)applicationFilesDirectory 
{
    NSString *lul  = NSHomeDirectory();
    NSURL *returnURL = [NSURL fileURLWithPath:lul];
    return returnURL;
}

/**
 Creates if necessary and returns the managed object model for the application.
 */
- (NSManagedObjectModel *)managedObjectModel 
{
    if (__managedObjectModel) 
    {
        return __managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"eggscellent" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    if(!__managedObjectModel)
        __managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator 
{
    if (__persistentStoreCoordinator) 
    {
        return __persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) 
    {
        //NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsDirectoryKey] error:&error];
    
    if (!properties) 
    {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) 
        {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) 
        {
            return nil;
        }
    }
    else 
    {
        if ([[properties objectForKey:NSURLIsDirectoryKey] boolValue] != YES) 
        {
            return nil;
        }
    }
    
    NSString *storename = nil;
    storename = @"eggscellent.sqlite";
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:storename];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]) 
    {
        return nil;
    }
    __persistentStoreCoordinator = coordinator;
    
    return __persistentStoreCoordinator;
}

/**
 Returns the managed object context for the application (which is already
 bound to the persistent store coordinator for the application.) 
 */
- (NSManagedObjectContext *)managedObjectContext 
{
    if (__managedObjectContext) 
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) 
    {
        return nil;
    }
    __managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    return __managedObjectContext;
}

@end