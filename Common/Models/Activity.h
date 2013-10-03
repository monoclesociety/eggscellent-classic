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
#define ACTIVITY_MODIFIED_COMPLETION @"ACTIVITY_MODIFIED_COMPLETION"
typedef enum
{
    ActivitySourceNone = 0,
    ActivitySourceReminders = 1,
    ActivitySourceThings = 2,
    ActivitySourceOmniFocus = 3
    
}ActivitySource;

@class Egg;
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
@property (nonatomic, strong) NSDate   * completed;
@property (nonatomic, strong) NSNumber * removed;
@property (nonatomic, strong) NSNumber * plannedCount;
@property (nonatomic, strong) NSSet    * eggs;
@property (nonatomic, strong) NSArray  * completedEggs;
@property (nonatomic, strong) NSArray  * invalidatedEggs;

+ (Activity *)currentActivity;
+ (void)setCurrentActivity:(Activity *)act;

+ (Activity *)activity;

- (EggTimer *)crackAnEgg;

- (NSNumber *)internalInterruptionCount;
- (NSNumber *)externalInterruptionCount;

- (void)secretSetCompleted:(NSDate *)completed;
- (void)secretSetRemoved:(NSNumber *)removed;
- (void)refresh;
- (BOOL)save;
@end

@interface Activity (CoreDataGeneratedAccessors)

- (void)addEggsObject:(Egg *)value;
- (void)removeEggsObject:(Egg *)value;
- (void)addEggs:(NSSet *)values;
- (void)removeEggs:(NSSet *)values;

@end