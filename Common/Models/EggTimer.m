//
//  Timer.m
//  pomodorable
//
//  Created by Kyle Kinkade on 11/11/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//

#import "EggTimer.h"

@implementation EggTimer
@synthesize timeEstimated;
@synthesize timeElapsed;
@synthesize type;
@synthesize status;
@synthesize pauseStart;
@synthesize previousFireDate;

#pragma mark - init/dealloc methods

- (id)initWithType:(TimerType)timerType;
{
    if(self = [super init])
    {
        NSString *timerTypeKey = nil;
        if(timerType == TimerTypePomodoro)
            timerTypeKey = @"pomodoroMinutes";
        if(timerType == TimerTypeShortBreak)
            timerTypeKey = @"smallBreakMinutes";
        if(timerType == TimerTypeLongBreak)
            timerTypeKey = @"longBreakMinutes";
            
        NSNumber *n = [[NSUserDefaults standardUserDefaults] valueForKey:timerTypeKey];
        
        int defaultTimeEstimated = 0;
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"konami code"])
            defaultTimeEstimated = 10;
        else
            defaultTimeEstimated = [n intValue] * 60;
        
        timeEstimated = defaultTimeEstimated;
        
        status = TimerStatusStopped;
        type = timerType;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [timer invalidate];
    timer = nil;
    
    
}

#pragma mark - Static Methods

static EggTimer *currentTimer;
+(EggTimer *)currentTimer;
{
    return currentTimer;
}

+(void)setCurrentTimer:(EggTimer *)pomo;
{
    if(currentTimer)
    {
        [currentTimer stopWithoutNotification];
    }
    
    currentTimer = pomo;
}

#pragma mark - pomodoro methods

- (void)tickTock
{
    timeElapsed++;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EGG_TICK object:self];
    
    
    
    if(self.timeElapsed == self.timeEstimated || self.timeEstimated == 0)
    {
        NSTimer *myTimer = timer; 
        timer = nil; 
        
        if(self.status == TimerStatusPaused)
            [[NSNotificationCenter defaultCenter] postNotificationName:EGG_STOP object:self];
        else
            [[NSNotificationCenter defaultCenter] postNotificationName:EGG_COMPLETE object:self];
        
        
        [myTimer invalidate]; 
        return;
    }
}

- (void)start;
{
    status = TimerStatusRunning;
    [[NSNotificationCenter defaultCenter] postNotificationName:EGG_START object:self];
    timeElapsed = 0;
    timer = [NSTimer timerWithTimeInterval:1 
                                    target:self 
                                  selector:@selector(tickTock) 
                                  userInfo:nil 
                                   repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)startAfterDelay:(int)seconds;
{
    [[NSNotificationCenter defaultCenter] postNotificationName:EGG_REQUESTED object:self];
    [self performSelector:@selector(start) withObject:nil afterDelay:seconds];
}

- (void)stopWithoutNotification;
{
    NSTimer *myTimer = timer; 
    timer = nil;    
    [myTimer invalidate];
    status = TimerStatusStopped;
}

- (void)stop;
{
    status = TimerStatusStopped;
    
    NSTimer *myTimer = timer; 
    timer = nil; 
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EGG_STOP object:self];
    
    [myTimer invalidate];
}

- (void)pause
{
    NSNumber *pauseAmount = [[NSUserDefaults standardUserDefaults] valueForKey:@"pomodoroPauseSeconds"];
    int makingUpShit = [pauseAmount intValue];
    if(self.type > TimerTypePomodoro || self.status == TimerStatusPaused || makingUpShit == 0)
        return;
    
    savedTimeElapsed    = timeElapsed;
    savedTimeEstimated  = timeEstimated;
    
    timeElapsed = 0;
    timeEstimated = makingUpShit + 1;
    
    self.pauseStart = [NSDate dateWithTimeIntervalSinceNow:0];
    self.previousFireDate = [timer fireDate];
    
    status = TimerStatusPaused;
    [[NSNotificationCenter defaultCenter] postNotificationName:EGG_PAUSE object:self];
}

- (void)resume
{
    status = TimerStatusRunning;
    float pauseTime = -1*[pauseStart timeIntervalSinceNow];
    [timer setFireDate:[previousFireDate initWithTimeInterval:pauseTime sinceDate:previousFireDate]];
    
    timeElapsed = savedTimeElapsed;
    timeEstimated = savedTimeEstimated;
    
    self.pauseStart = nil;
    self.previousFireDate = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:EGG_RESUME object:self];
}

@end
