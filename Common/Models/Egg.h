//
//  Pomodoro.h
//  SeriouslyOSX
//
//  Created by Kyle Kinkade on 11/4/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MSManagedObject.h"

typedef enum
{
    EggOutcomeInvalidated = 0,
    EggOutcomeCompleted = 1
}EggOutcome;

@class Activity;
@interface Egg : MSManagedObject
{
    
}
@property (nonatomic, strong) NSNumber * currentState;
@property (nonatomic, strong) NSNumber * outcome;
@property (nonatomic, strong) NSNumber * internalInterruptions;
@property (nonatomic, strong) NSNumber * externalInterruptions;
@property (nonatomic, strong) NSNumber * timeEstimated;
@property (nonatomic, strong) NSNumber * timeElapsed;
@property (nonatomic, strong) Activity * activity;

+ (Egg *)lastEgg;
+ (Egg *)newEgg;

@end
