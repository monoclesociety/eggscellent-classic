//
//  Activity.h
//  SeriouslyOSX
//
//  Created by Kyle Kinkade on 11/4/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MSManagedObject.h"

#define ACTIVITY_MODIFIED @"ACTIVITY_MODIFIED"
typedef enum
{
    ActivitySourceNone = 0,
    ActivitySourceReminders = 1,
    ActivitySourceThings = 2,
    ActivitySourceOmniFocus = 3
    
}ActivitySource;

@class Pomodoro;
@class EggTimer;
@interface Activity : MSManagedObject
{
    
}
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * details;
@property (nonatomic, strong) NSString * meta;
@property (nonatomic, strong) NSNumber * source;
@property (nonatomic, strong) NSString * sourceID;
@property (nonatomic, strong) NSNumber * unplanned;
@property (nonatomic, strong) NSNumber * completed;
@property (nonatomic, strong) NSNumber * removed;
@property (nonatomic, strong) NSNumber * plannedCount;
@property (nonatomic, strong) NSSet *pomodoros;
@property (nonatomic, strong) NSArray *completedPomodoros;
@property (nonatomic, strong) NSArray *invalidatedPomodoros;

+ (Activity *)currentActivity;
+ (void)setCurrentActivity:(Activity *)act;

+ (Activity *)activity;
+ (NSArray *)activities;

- (EggTimer *)startAPomodoro;

- (NSNumber *)internalInterruptionCount;
- (NSNumber *)externalInterruptionCount;

- (void)secretSetCompleted:(NSNumber *)completed;
- (void)refresh;
- (BOOL)save;
@end

@interface Activity (CoreDataGeneratedAccessors)

- (void)addPomodorosObject:(Pomodoro *)value;
- (void)removePomodorosObject:(Pomodoro *)value;
- (void)addPomodoros:(NSSet *)values;
- (void)removePomodoros:(NSSet *)values;

@end