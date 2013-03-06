//
//  MonitorWindowController.m
//  pomodorable
//
//  Created by Kyle Kinkade on 11/23/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//

#import "MonitorWindowController.h"
#import "AppDelegate.h"
#import "AVAudioPlayer+Filesystem.h"


// EGG animation
// height: 150
// width: 180

@implementation MonitorWindowController

#pragma mark - 

- (id)init
{
    if(self = [super initWithWindowNibName:@"MonitorNormalWindowController"])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PomodoroRequested:) name:EGG_REQUESTED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PomodoroTimeStarted:) name:EGG_START object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PomodoroClockTicked:) name:EGG_TICK object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PomodoroTimeCompleted:) name:EGG_COMPLETE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PomodoroStopped:) name:EGG_STOP object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(externalInterruptionKeyed:) name:@"externalInterruptionKeyed" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(internalInterruptionKeyed:) name:@"internalInterruptionKeyed" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pomodoroPaused:) name:EGG_PAUSE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pomodoroResume:) name:EGG_RESUME object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(floatLevelChanged:) name:@"monitorWindowOnTop" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)windowDidLoad
{
    //set our window up
    NSNumber *floatWindow = [[NSUserDefaults standardUserDefaults] objectForKey:@"monitorWindowOnTop"];
    
    if((!floatWindow) || [floatWindow boolValue])
    {
        [self.window setLevel:NSFloatingWindowLevel];
    }
    else
    {
        [self.window setLevel:NSNormalWindowLevel];
    }
    
    [self.window setAcceptsMouseMovedEvents:YES];
    [self.window setMovableByWindowBackground:YES];
    [self.window setOpaque:NO];
    [self.window setBackgroundColor:[NSColor clearColor]];
    [self.window setIgnoresMouseEvents:YES];
    
    //NSTrackingMouseMoved
    //add tracking area to containerView, so we can do the swap thingy 
    NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:[self.window frame] options:NSTrackingMouseEnteredAndExited | NSTrackingInVisibleRect | NSTrackingActiveAlways owner:self userInfo:nil];
    [containerView addTrackingArea:area];
    
    //create shadow for view
    NSView *mainView = (NSView *)self.window.contentView;
    [mainView setWantsLayer:YES];
    CGColorRef shadowColor = CGColorCreateGenericRGB(0, 0, 0, 1);
    mainView.layer.shadowRadius = 5;
    mainView.layer.shadowOpacity = .5;
    mainView.layer.shadowColor = shadowColor;
    CGColorRelease(shadowColor);

    //set up normal layer
    [containerView addSubview:normalView];
    
    //set up backgroundImages for views
    normalView.backgroundImage = [NSImage imageNamed:@"focus-card"];
    mouseoverView.backgroundImage = [NSImage imageNamed:@"focus-card-hover"];
    [self.window close];
    
    //stop button text
    //center the text    
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];    
    pStyle.alignment = NSCenterTextAlignment;
    NSColor *txtColor = [NSColor whiteColor];
    NSFont *txtFont = [NSFont systemFontOfSize:12];
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowOffset:NSMakeSize(0.0,-1.0)];
    [shadow setShadowBlurRadius:1.0];
    [shadow setShadowColor:[NSColor colorWithDeviceWhite:0.0 alpha:0.7]];
    
    NSDictionary *txtDict = [NSDictionary dictionaryWithObjectsAndKeys:pStyle, NSParagraphStyleAttributeName, txtFont, NSFontAttributeName, txtColor,  NSForegroundColorAttributeName, shadow, NSShadowAttributeName, nil];
    stopString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Stop", @"Stop") attributes:txtDict];
    resumeString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Resume",@"Resume") attributes:txtDict];
    [stopButton setAttributedTitle:stopString];
}

#pragma mark - IBActions

- (IBAction)addExternalInterruption:(id)sender;
{
    id s = sender;
    if (([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask))
        s = nil;
            
    AppDelegate *appDelegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
    [appDelegate externalInterruptionKeyed:s];
}

- (IBAction)addInternalInterruption:(id)sender;
{
    id s = sender;
    if (([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask))
        s = nil;
    
    AppDelegate *appDelegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
    [appDelegate internalInterruptionKeyed:s];
}

- (IBAction)stopPomodoro:(id)sender;
{
    EggTimer *Timer = [EggTimer currentTimer];
    
    switch(Timer.status)
    {
        case TimerStatusPaused:
            [Timer resume];
            break;
        case TimerStatusRunning:
            [Timer stop];
            break;
        case TimerStatusStopped:
            break;
    }
}

#pragma mark - NSTrackingArea Methods

- (void)replaceView:(NSView *)oldView withView:(NSView *)newView
{
    //remove old view
    [oldView removeFromSuperview];
    
    //add in new view
    [containerView addSubview:newView];
    
    CATransition *t = [CATransition animation];
    t.duration = .25;
    t.type = kCATransitionFade;
    [containerView.layer addAnimation:t forKey:@"fade in"];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    [self.window setIgnoresMouseEvents:NO];
    EggTimer *currentTimer = [EggTimer currentTimer];
    TimerStatus timerStatus = [currentTimer status];
    if((timerStatus == TimerStatusRunning || timerStatus == TimerStatusPaused) && currentTimer.type == TimerTypeEgg)
    {
        [self replaceView:normalView withView:mouseoverView];
    }
}

- (void)mouseExited:(NSEvent *)theEvent
{
    [self.window setIgnoresMouseEvents:YES];
    [self replaceView:mouseoverView withView:normalView];
}

- (void)mouseMoved:(NSEvent *)theEvent
{
//    NSPoint where = [self.window.contentView convertPoint:[theEvent locationInWindow] fromView:nil];
//    NSColor *lol = [(ColorView *)self.window.contentView colorForPoint:where];
//    NSLog(@"=============");
//    NSLog(@"red:    %2.0f",[lol redComponent]);
//    NSLog(@"alpha:  %2.0f",[lol alphaComponent]);
//    NSLog(@"=============");
}

#pragma mark - custom methods

- (void)updatePomodoroCount
{
    pomodoroCount.stringValue = [NSString stringWithFormat:@"%d", (int)[[Activity currentActivity].completedEggs count], nil];
    plannedPomodoroCount.stringValue = [[Activity currentActivity].plannedCount stringValue];
}

#pragma mark - NSAnimationView Delegate Methods

- (void)animationEnded
{
    if(animationView.animationTag == 1337) //get it?! it means elite in hacker from like 15 years ago! omg i'm old.
    {
        animationView.frameRate = 30;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:30];
        [arr addObjectsFromArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"egg_sequences/2_egg_wind"]];
        animationView.frames = arr;
        
        AppDelegate *appDelegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
        [appDelegate.windUpSound performSelectorInBackground:@selector(play) withObject:nil];
        [animationView start];
    }
    
//    if(animationView.animationTag == 8008135)
//    {
//        //TODO: make the timer count turn into a activity view on ribbon until break is over.
//        NSProgressIndicator* indicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(NSMaxX(containerView.frame) - 40, 10, 15, 15)];
//        [indicator setStyle:NSProgressIndicatorSpinningStyle];
//        [indicator setControlTint:NSClearControlTint];
//        [indicator startAnimation:nil];
//        [containerView addSubview:indicator];
//    }

    animationView.animationTag = 0;
    animationView.delegate = nil;
}

#pragma mark - Notification Methods

- (void)PomodoroRequested:(NSNotification *)note
{
    [self.window makeKeyAndOrderFront:nil];
    
    [activityNameLabel setNeedsLayout:YES];
    [activityNameLabel setNeedsDisplay:YES];

    Activity *a = [Activity currentActivity];
    
    //remove all animations
    NSView *mainView = (NSView *)self.window.contentView;
    [mainView.layer removeAllAnimations]; 
    
    //populate activity name
    activityNameLabel.stringValue = a.name;
    
    //populate ribbon view
    ribbonView.plannedPomodoroCount = [a.plannedCount intValue];
    ribbonView.completePomodoroCount = (int)[a.completedEggs count];
    [ribbonView setNeedsDisplay:YES];
    
    //populate pomodoro counts
    [self updatePomodoroCount];
    
    //populate interruptions
    internalInterruptionLabel.stringValue = [[[Activity currentActivity] internalInterruptionCount] stringValue];
    externalInterruptionLabel.stringValue = [[[Activity currentActivity] externalInterruptionCount] stringValue];

    [containerView.layer removeAllAnimations];
    
    [animationView stop];
    animationView.delegate = self;
    animationView.frameRate = 30;
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:168];
    [arr addObjectsFromArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"egg_sequences/1_egg_in"]];
    animationView.frames = arr;
    animationView.animationTag = 1337;
    [animationView start];
}

- (void)PomodoroTimeStarted:(NSNotification *)note
{
    EggTimer *pomo = (EggTimer *)[note object];
    if(pomo.type == TimerTypeEgg)
    {
        [self.window makeKeyAndOrderFront:nil];

        NSMutableArray *arr = [NSMutableArray array];
        [arr addObjectsFromArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"egg_sequences/3_egg_tick_Q1"]];
        [arr addObjectsFromArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"egg_sequences/5_egg_tick_Q2"]];
        [arr addObjectsFromArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"egg_sequences/7_egg_tick_Q3"]];
        [arr addObjectsFromArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"egg_sequences/9_egg_tick_Q4"]];
        
        [animationView stop];
        animationView.frames = arr;
        
        double countedFrames = (double)[arr count];
        double secondsEstimated = (float)pomo.timeEstimated;
        double frameRate = countedFrames / secondsEstimated;
        animationView.frameRate = frameRate;
        
        [animationView start];
    }
}

- (void)PomodoroClockTicked:(NSNotification *)note
{
    EggTimer *pomo = (EggTimer *)[note object];
    
    int diff = pomo.timeEstimated - pomo.timeElapsed;
    
    int minutesLeft = diff / 60;
    int secondsleft = diff % 60;
    
    NSString *stringFormat = @"%02d:%02d";
    timerLabel.stringValue = [NSString stringWithFormat:stringFormat, minutesLeft, secondsleft, nil];
}

- (void)PomodoroTimeCompleted:(NSNotification *)note
{
    EggTimer *pomo = (EggTimer *)[note object];
    if(pomo.type == TimerTypeEgg)
    {   
        
        //update ribbon UI
        Activity *a = [Activity currentActivity];
        ribbonView.plannedPomodoroCount = [a.plannedCount intValue];
        ribbonView.completePomodoroCount = (int)[a.completedEggs count];
        ribbonView.completed = [a.completed boolValue];

        [ribbonView setNeedsDisplay:YES];
        [self updatePomodoroCount];
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:60];
        [arr addObjectsFromArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"egg_sequences/10_egg_hatch"]];
        [arr addObjectsFromArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"egg_sequences/11_egg_out"]];

        [animationView stop];
//        animationView.animationTag = 8008135;
//        animationView.delegate = self;
        animationView.frames = arr;
        animationView.frameRate = 30.0f;
        [animationView start];
        [self mouseExited:nil];
    }
    
    if(pomo.type == TimerTypeLongBreak || pomo.type == TimerTypeShortBreak)
    {
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"autoStartNextTimer"])
            [self.window close];
    }
}

- (void)PomodoroStopped:(NSNotification *)note
{
    EggTimer *pomo = (EggTimer *)[note object];
    if(pomo.type == TimerTypeEgg)
    {
        [animationView stop];
        [self.window close];
    }
}

- (void)pomodoroPaused:(NSNotification *)note
{
    [animationView pause];
    
    [stopButton setAttributedTitle:resumeString];
    stopButton.image = [NSImage imageNamed:@"button-resume"];
    stopButton.alternateImage = [NSImage imageNamed:@"button-resume-down"];
}

- (void)pomodoroResume:(NSNotificationCenter *)note
{
    [animationView resume];
    
    [stopButton setAttributedTitle:stopString];
    stopButton.image = [NSImage imageNamed:@"button-stop"];
    stopButton.alternateImage = [NSImage imageNamed:@"button-stop-down"];
}

- (void)externalInterruptionKeyed:(NSNotification *)note
{
    externalInterruptionLabel.stringValue = [[[Activity currentActivity] externalInterruptionCount] stringValue];
}

- (void)internalInterruptionKeyed:(NSNotification *)note
{
    internalInterruptionLabel.stringValue = [[[Activity currentActivity] internalInterruptionCount] stringValue];
}

- (void)floatLevelChanged:(NSNotification *)note
{
    //set our window up
    NSNumber *floatWindow = [[NSUserDefaults standardUserDefaults] objectForKey:@"monitorWindowOnTop"];
    
    if((!floatWindow) || [floatWindow boolValue])
    {
        [self.window setLevel:NSFloatingWindowLevel];
    }
    else
    {
        [self.window setLevel:NSNormalWindowLevel];
    }
}

@end
