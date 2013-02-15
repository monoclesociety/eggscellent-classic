//
//  Timer.h
//  pomodorable
//
//  Created by Kyle Kinkade on 11/11/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//

#import <Foundation/Foundation.h>

#define EGG_REQUESTED  @"EGG_REQUESTED"
#define EGG_START      @"EGG_START"
#define EGG_TICK       @"EGG_TICK"
#define EGG_COMPLETE   @"EGG_COMPLETE"
#define EGG_STOP       @"EGG_STOP"
#define EGG_PAUSE      @"EGG_PAUSE"
#define EGG_RESUME     @"EGG_RESUME"

typedef enum 
{
    TimerTypeEgg = 0,
    TimerTypeShortBreak = 1,
    TimerTypeLongBreak = 2
} TimerType;

typedef enum
{
    TimerStatusStopped = 0,
    TimerStatusRunning = 1,
    TimerStatusPaused  = 2
} TimerStatus;

@interface EggTimer : NSObject
{
    NSTimer *timer;
    NSDate *pauseStart;
    NSDate *previousFireDate;
    
    //Time Elapsed for the current timer, paused or actual
    int timeElapsed;
    int timeEstimated;
    
    int savedTimeElapsed;
    int savedTimeEstimated;
    
    TimerType type;
    TimerStatus status;
}
@property (nonatomic, readonly) int timeEstimated;
@property (nonatomic, readonly) int timeElapsed;
@property (nonatomic, assign)   TimerType type;
@property (nonatomic, readonly) TimerStatus status;
@property (nonatomic, strong)   NSDate *pauseStart;
@property (nonatomic, strong)   NSDate *previousFireDate;

+(EggTimer *)currentTimer;
+(void)setCurrentTimer:(EggTimer *)pomo;

- (id)initWithType:(TimerType)timerType;

- (void)start;
- (void)startAfterDelay:(int)seconds;
- (void)pause;
- (void)stop;
- (void)resume;

- (void)stopWithoutNotification;

@end