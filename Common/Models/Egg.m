//
//  Pomodoro.m
//  SeriouslyOSX
//
//  Created by Kyle Kinkade on 11/4/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//

#import "Egg.h"
#import "Activity.h"
#import "ModelStore.h"

@implementation Egg
@dynamic currentState;
@dynamic outcome;
@dynamic internalInterruptions;
@dynamic externalInterruptions;
@dynamic timeEstimated;
@dynamic timeElapsed;
@dynamic activity;

#pragma mark - Helper Methods

+ (Egg *)lastEgg;
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Egg" inManagedObjectContext:[ModelStore sharedStore].managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    [request setFetchLimit:1];
    int pomodoroCount = (int)[[[ModelStore sharedStore] allWithClassName:@"Egg"] count];
    [request setFetchOffset:pomodoroCount - 1];
    
    NSArray *results = [[ModelStore sharedStore].managedObjectContext executeFetchRequest:request error:NULL];
    return [results objectAtIndex:0];
}

+ (Egg *)newEgg;
{
    Egg *result = [[ModelStore sharedStore] newModelWithClassName:@"Egg"];
    result.outcome = [NSNumber numberWithInt:EggOutcomeInvalidated];

    return result;
}

#pragma mark - core data methods and lifecycle

- (void)awakeFromInsert
{
    [super awakeFromInsert];
}

@end