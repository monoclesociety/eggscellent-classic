//
//  Activity.m
//  SeriouslyOSX
//
//  Created by Kyle Kinkade on 11/4/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//

#import "Activity.h"
#import "Egg.h"
#import "EggTimer.h"
#import "ModelStore.h"
#import "TaskSyncController.h"

@interface Activity (PrimitiveAccessors)
- (NSDate *)primitiveCompleted;
- (void)setPrimitiveCompleted:(NSDate *)completed;

- (NSNumber *)primitiveRemoved;
- (void)setPrimitiveRemoved:(NSNumber *)removed;

- (NSString *)primitiveName;
- (void)setPrimitiveName:(NSString *)name;
@end

@implementation Activity
@dynamic name;
@dynamic details;
@dynamic meta;
@dynamic source;
@dynamic sourceID;
@dynamic unplanned;
@dynamic completed;
@dynamic removed;
@dynamic plannedCount;
@dynamic eggs;
@dynamic completedEggs;
@dynamic invalidatedEggs;

#pragma mark - class helper methods
static Activity *singleton;
+ (Activity *)currentActivity;
{
    return singleton;
}

+ (void)setCurrentActivity:(Activity *)act;
{
    singleton = act;
}

+ (Activity *)activity;
{
    //create new task and pre-populate it.
    Activity *newActivity = [[ModelStore sharedStore] newModelWithClassName:@"Activity"];
    newActivity.name = NSLocalizedString(@"new task", @"new task");
    newActivity.plannedCount = [NSNumber numberWithInt:1];
    
    //task sync it
    [[TaskSyncController currentController] syncActivity:newActivity];
    
    return newActivity;
}

#pragma mark - model operation methods

- (NSNumber *)internalInterruptionCount;
{
    int theSum = 0;
    for (Egg *egg in self.eggs)
        theSum += [egg.internalInterruptions intValue];
    return [NSNumber numberWithInt:theSum];
}

- (NSNumber *)externalInterruptionCount;
{
    int theSum = 0;
    for (Egg *egg in self.eggs)
        theSum += [egg.externalInterruptions intValue];
    return [NSNumber numberWithInt:theSum];
}

- (EggTimer *)crackAnEgg
{
    Egg *p = [Egg newEgg];
    [self addEggsObject:p];
    [Activity setCurrentActivity:self];
    
    EggTimer *result = [[EggTimer alloc] initWithType:TimerTypeEgg];
    [EggTimer setCurrentTimer:result];
    
    return result;
}

- (BOOL)save;
{
    return [[ModelStore sharedStore] save];
}

- (void)refresh;
{
    [[ModelStore sharedStore].managedObjectContext refreshObject:self mergeChanges:YES];
}

#pragma mark - Core Data Property Overrides

- (void)setCompleted:(NSDate *)inCompleted
{
    NSDate *oldCompleted = [self primitiveCompleted];
    [self willChangeValueForKey:@"completed"];
    [self setPrimitiveCompleted:inCompleted];
    [self didChangeValueForKey:@"completed"];
    
    if((oldCompleted != nil && inCompleted == nil) || (oldCompleted == nil && inCompleted != nil))
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVITY_MODIFIED object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVITY_MODIFIED_COMPLETION object:self];
    }
}

- (void)secretSetCompleted:(NSDate *)completed;
{
    [self willChangeValueForKey:@"completed"];
    [self setPrimitiveCompleted:completed];
    [self didChangeValueForKey:@"completed"];
}

- (void)setRemoved:(NSNumber *)inRemoved
{
    [self willChangeValueForKey:@"removed"];
    [self setPrimitiveRemoved:inRemoved];
    [self didChangeValueForKey:@"removed"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVITY_MODIFIED object:self];
}

- (void)secretSetRemoved:(NSNumber *)removed
{
    [self willChangeValueForKey:@"removed"];
    [self setPrimitiveRemoved:removed];
    [self didChangeValueForKey:@"removed]"];
}

@end
