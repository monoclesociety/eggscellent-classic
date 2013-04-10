//
//  ModelStore.m
//  SeriouslyOSX
//
//  Created by Kyle Kinkade on 11/5/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//
#import "ModelStore.h"

//#ifdef CLASSIC_APP
//#import <CocoaFobARC/CFobLicVerifier.h>
//
////@interface ModelStore (private)
////@property (nonatomic, strong) CFobLicVerifier *verifier;
////@property (nonatomic, strong) NSString *pubKey;
////@end
////
////@implementation ModelStore (private)
////@synthesize pubKey;
////@end
//
//#endif

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

#pragma mark - time bomb bitches!

- (id)init
{
    if(self = [super init])
    {
    //      THUS THE TIMEBOMB BEGINS....
    [self performSelector:@selector(taskStoreInitialization:)
               withObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:1234], [NSDate date], nil]
               afterDelay:(arc4random() % 4)];
    }
    return self;
}

- (void)taskStoreInitialization:(NSArray *)arr
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (arc4random() % 4) * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
//        NSArray *p = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//        NSMutableString *f = [NSMutableString stringWithString:(NSString *)[p objectAtIndex:0]];
//        [f appendString:@"/Preferences/com.monoclesociety.eggscellent.osx.plist"];
//        NSDictionary *d = [[NSFileManager defaultManager] attributesOfFileSystemForPath:f  error:nil];
//        NSDate *md = [d objectForKey:NSFileModificationDate];
//        NSTimeInterval mdti = [md timeIntervalSince1970];
//        
//        NSTimeInterval t = [[arr objectAtIndex:1] timeIntervalSince1970];
        
        //DO CHECK HERE.
        //MAYBE GET LICENSE FROM USERDEFAULTS
        //ENSURE THAT THE KEY ISN'T NIL OR IS OF TYPE STRING WHEN YOU GET IT BACK. AND THAT IT'S NOT FUNKY OR ANYTHING.
//        if(t > initializationRes && )// || t < 1362096000) //detect that current date isn't before first run date (mar 1st is the num)
//        {
//            //THROW UP REGISTRATION WINDOW
//        }
        
//        NSMutableString *pubKeyBase64 = [NSMutableString string];
//        [pubKeyBase64 appendString:@"MIHxMIGoBgcqhkj"];
//        [pubKeyBase64 appendString:@"OOAQBMIGcAkEA8wm04e0QcQRoAVJW"];
//        [pubKeyBase64 appendString:@"WnUw/4rQEKbLKjujJu6o\n"];
//        [pubKeyBase64 appendString:@"yE"];
//        [pubKeyBase64 appendString:@"v7Y2oT3itY5pbObgYCHEu9FBizqq7apsWYSF3YX"];
//        [pubKeyBase64 appendString:@"iRjKlg10wIVALfs9eVL10Ph\n"];
//        [pubKeyBase64 appendString:@"oV6zczFpi3C7FzWNAkBaPhALEKlgIltHsumHdTSBqaVoR1/bmlgw"];
//        [pubKeyBase64 appendString:@"/BCC13IAsW40\n"];
//        [pubKeyBase64 appendString:@"nkFNsK1OVwjo2ocn"];
//        [pubKeyBase64 appendString:@"3M"];
//        [pubKeyBase64 appendString:@"wW"];
//        [pubKeyBase64 appendString:@"4Rdq6uLm3DlENRZ5bYrTA"];
//        [pubKeyBase64 appendString:@"0QAAkEA4reDYZKAl1vx+8EI\n"];
//        [pubKeyBase64 appendString:@"MP/+"];
//        [pubKeyBase64 appendString:@"2Z7ekydHfX0sTMDgkxhtRm6qtcywg01X847Y9ySgNepqleD+Ka2Wbucj1pOr\n"];
//        [pubKeyBase64 appendString:@"y8MoDQ==\n"];
//        NSString *pubKeyBase64 = @"testickles";
//        self.pubKey = [CFobLicVerifier completePublicKeyPEM:pubKeyBase64];
//        
//        self.verifier = [[CFobLicVerifier alloc] init];
//        NSError *err = nil;
//        if (![self.verifier setPublicKey:self.pubKey error:&err])
//        {
//            //OH MY GAWD WHAT DO WE DO NOW????? DO WE QUIT APP??? WHY IS BEAR DRIVING
//        }
//        
//        BOOL result = [self.verifier verifyRegCode:@"GAWQE-F9AQP-XJCCL-PAFAX-NU5XX-EUG6W-KLT3H-VTEB9-A9KHJ-8DZ5R-DL74G-TU4BN-7ATPY-3N4XB-V4V27-Q" forName:@"Joe Bloggs" error:&err];
    });
}

#pragma mark - methods

-(BOOL)save;
{
//    NSLog(@"Saving...");
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"((removed == 0) AND (completed == nil)) OR (completed > %@ and removed == 0)", today, nil];
    
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
    
    __block NSUInteger count = -1;
    [self.managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        count = [self.managedObjectContext countForFetchRequest: fetchRequest error: &error];
    }];
    
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