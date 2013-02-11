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

@interface Activity (PrimitiveAccessors)
- (NSNumber *)primitiveCompleted;
- (void)setPrimitiveCompleted:(NSNumber *)completed;

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
    return [[ModelStore sharedStore] newModelWithClassName:@"Activity"];
}

+ (NSArray *)activities;
{
    return [[ModelStore sharedStore] allWithClassName:@"Activity"];
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

- (EggTimer *)startAPomodoro
{
    Egg *p = [Egg newPomodoro];
    [self addEggsObject:p];
    [Activity setCurrentActivity:self];
    
    EggTimer *result = [[EggTimer alloc] initWithType:TimerTypePomodoro];
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

- (void)setCompleted:(NSNumber *)inCompleted
{
    NSNumber *oldCompleted = [self primitiveCompleted];
    [self willChangeValueForKey:@"completed"];
    [self setPrimitiveCompleted:inCompleted];
    [self didChangeValueForKey:@"completed"];
    
    if([oldCompleted boolValue] != [inCompleted boolValue])
        [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVITY_MODIFIED object:self];
}

- (void)secretSetCompleted:(NSNumber *)completed;
{
    [self willChangeValueForKey:@"completed"];
    [self setPrimitiveCompleted:completed];
    [self didChangeValueForKey:@"completed"];
}

@end
