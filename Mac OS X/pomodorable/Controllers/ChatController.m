//
//  ChatController.m
//  pomodorable
//
//  Created by Kyle Kinkade on 11/23/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//

#import "ChatController.h"
#import "ScriptManager.h"

@implementation ChatController

- (id)init
{
    if(self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PomodoroStarted:) name:EGG_START object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PomodoroTimeCompleted:) name:EGG_COMPLETE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PomodoroStopped:) name:EGG_STOP object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

#pragma mark - NSNotifications

- (void)PomodoroStarted:(NSNotification *)note
{
    EggTimer *pomo = (EggTimer *)[note object];
    if(pomo.type == TimerTypeEgg)
    {
        [self setStatusToBusy];
    }
}

- (void)PomodoroTimeCompleted:(NSNotification *)note
{
    EggTimer *pomo = (EggTimer *)[note object];
    if(pomo.type == TimerTypeEgg)
    {
        [self setStatusToAvailable];
    }
}

- (void)PomodoroStopped:(NSNotification *)note
{
    EggTimer *pomo = (EggTimer *)[note object];
    if(pomo.type == TimerTypeEgg)
    {
        [self setStatusToAvailable];
    }
}

#pragma mark - custom methods

- (void)setStatusToBusy;
{
    NSString *statusMessage = [[NSUserDefaults standardUserDefaults] stringForKey:@"statusMessage"];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"skypeIntegration"])
        
            if([[NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.skype.skype"] count] != 0)
                [[ScriptManager sharedManager] executeScript:@"SkypeSetStatusBusy" withParameter:statusMessage];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"iChatIntegration"])

            if([[NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.apple.iChat"] count] != 0)
                [[ScriptManager sharedManager] executeScript:@"iChatSetStatusBusy" withParameter:statusMessage];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"adiumIntegration"])
        
            if([[NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.adiumX.adiumX"] count] != 0)
                [[ScriptManager sharedManager] executeScript:@"AdiumSetStatusBusy" withParameter:statusMessage];
}

- (void)setStatusToAvailable
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"skypeIntegration"])
            
        if([[NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.skype.skype"] count])
                [[ScriptManager sharedManager] executeScript:@"SkypeSetStatusAvailable"];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"iChatIntegration"])
         
        if([[NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.apple.iChat"] count])
                [[ScriptManager sharedManager] executeScript:@"iChatSetStatusAvailable" withParameter:@""];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"adiumIntegration"])
     
        if([[NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.adiumX.adiumX"] count])
                [[ScriptManager sharedManager] executeScript:@"AdiumSetStatusAvailable"];
}

@end
