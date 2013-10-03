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
    
    //set animation delegate
    animationView.delegate = self;
    
    
    //set up hatching sounds
    //hatchsound1
    NSString *lul = [[NSBundle mainBundle] pathForResource:@"4_egg_nudge_1" ofType:@"aif"];
    NSData *fileData = [NSData dataWithContentsOfFile:lul];
    hatchSound1 = [[AVAudioPlayer alloc] initWithData:fileData error:NULL];
    hatchSound1.volume = .5;
    [hatchSound1 prepareToPlay];
    
    //hatchSound2
    lul = [[NSBundle mainBundle] pathForResource:@"6_egg_nudge_2" ofType:@"aif"];
    fileData = [NSData dataWithContentsOfFile:lul];
    hatchSound2 = [[AVAudioPlayer alloc] initWithData:fileData error:NULL];
    hatchSound2.volume = .5;
    [hatchSound2 prepareToPlay];
    
    //hatchSound3
    lul = [[NSBundle mainBundle] pathForResource:@"8_egg_nudge_3" ofType:@"aif"];
    fileData = [NSData dataWithContentsOfFile:lul];
    hatchSound3 = [[AVAudioPlayer alloc] initWithData:fileData error:NULL];
    hatchSound3.volume = .5;
    [hatchSound3 prepareToPlay];
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
}

#pragma mark - custom methods

- (void)updatePomodoroCount
{
    pomodoroCount.stringValue = [NSString stringWithFormat:@"%d", (int)[[Activity currentActivity].completedEggs count], nil];
    plannedPomodoroCount.stringValue = [[Activity currentActivity].plannedCount stringValue];
}

- (void)createQuarterForSequence:(NSString *)sequence;
{
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObjectsFromArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:sequence]];
    
    [animationView stop];
    double countedFrames = (double)[arr count];
    double quartSecondsEstimated = (_timeEstimated / 168) * countedFrames;//25 minutes is 1500 seconds
    double frameRate = countedFrames / quartSecondsEstimated;
    
    animationView.frameRate = frameRate;
    animationView.frames = arr;
}

#pragma mark - NSAnimationView Delegate Methods

- (void)animationEnded
{
    switch(animationView.animationTag)
    {
        case 1000:
        {
            animationView.frameRate = 30;
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:30];
            [arr addObjectsFromArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"egg_sequences/2_egg_wind"]];
            animationView.frames = arr;
            
            AppDelegate *appDelegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
            
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"hideMonitorAnimation"])
                [appDelegate.windUpSound performSelectorInBackground:@selector(play) withObject:nil];
            
            animationView.animationTag = -1;
            [animationView start];
        }
            break;
        case 1001:
        {
            //play first hatch
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"hideMonitorAnimation"])
                [hatchSound1 performSelectorInBackground:@selector(play) withObject:nil];
            animationView.frameRate = 30;
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObjectsFromArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"egg_sequences/4_egg_nudge_1"]];
            animationView.frames = arr;
            animationView.animationTag = 2001;
            [animationView start];
        }
            break;
        case 2001:
            //create second quarter
            [self createQuarterForSequence:@"egg_sequences/5_egg_tick_Q2"];
            animationView.animationTag = 1002;
            [animationView start];
            break;
        case 1002:
        {
            //play second hatch
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"hideMonitorAnimation"])
                [hatchSound2 performSelectorInBackground:@selector(play) withObject:nil];
            animationView.frameRate = 30;
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObjectsFromArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"egg_sequences/6_egg_nudge_2"]];
            animationView.frames = arr;
            animationView.animationTag = 2002;
            [animationView start];
        }
            break;
        case 2002:
            //create third quarter
            [self createQuarterForSequence:@"egg_sequences/7_egg_tick_Q3"];
            animationView.animationTag = 1003;
            [animationView start];
            break;
        case 1003:
        {
            //play third hatch
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"hideMonitorAnimation"])
                [hatchSound3 performSelectorInBackground:@selector(play) withObject:nil];
            animationView.frameRate = 30;
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObjectsFromArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"egg_sequences/8_egg_nudge_3"]];
            animationView.frames = arr;
            animationView.animationTag = 2003;
            [animationView start];
        }
            break;
        case 2003:
            //create fourth quarter
            [self createQuarterForSequence:@"egg_sequences/9_egg_tick_Q4"];
            animationView.animationTag = 1004;
            [animationView start];
            break;
    }
}

#pragma mark - Notification Methods

- (void)PomodoroRequested:(NSNotification *)note
{
    [self.window makeKeyAndOrderFront:nil];
    
    [activityNameLabel setNeedsLayout:YES];
    [activityNameLabel setNeedsDisplay:YES];

    Activity *a = [Activity currentActivity];
    
    //make *damn* sure the button is stopped.
    [stopButton setAttributedTitle:stopString];
    stopButton.image = [NSImage imageNamed:@"button-stop"];
    stopButton.alternateImage = [NSImage imageNamed:@"button-stop-down"];
    
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
    animationView.frameRate = 30;
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:168];
    [arr addObjectsFromArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"egg_sequences/1_egg_in"]];
    animationView.frames = arr;
    animationView.animationTag = 1000;
    [animationView start];
}

- (void)PomodoroTimeStarted:(NSNotification *)note
{
    EggTimer *egg = (EggTimer *)[note object];
    _timeEstimated = (double)egg.timeEstimated;
    if(egg.type == TimerTypeEgg)
    {
        [self.window makeKeyAndOrderFront:nil];
        
        //create first quarter
        [self createQuarterForSequence:@"egg_sequences/3_egg_tick_Q1"];
        animationView.animationTag = 1001;
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
        ribbonView.completed = (a.completed);

        [ribbonView setNeedsDisplay:YES];
        [self updatePomodoroCount];
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:60];
        [arr addObjectsFromArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"egg_sequences/10_egg_hatch"]];
        [arr addObjectsFromArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"egg_sequences/11_egg_out"]];

        [animationView stop];
        animationView.animationTag = -1;
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
    
    [stopButton setAttributedTitle:stopString];
    stopButton.image = [NSImage imageNamed:@"button-stop"];
    stopButton.alternateImage = [NSImage imageNamed:@"button-stop-down"];
}

- (void)PomodoroStopped:(NSNotification *)note
{
    EggTimer *pomo = (EggTimer *)[note object];
    if(pomo.type == TimerTypeEgg)
    {
        [animationView stop];
        [self.window close];
    }
    
    [stopButton setAttributedTitle:stopString];
    stopButton.image = [NSImage imageNamed:@"button-stop"];
    stopButton.alternateImage = [NSImage imageNamed:@"button-stop-down"];
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
