//
//  MonitorWindowController.m
//  pomodorable
//
//  Created by Kyle Kinkade on 11/23/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//

#import "MonitorWindowController.h"
#import "AppDelegate.h"

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
        growmatoFrame = 0;
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

    //set up awesome tomato layer!
    NSView *mainView = (NSView *)self.window.contentView;
    [mainView setWantsLayer:YES];
    tomatoLayer = [CALayer layer];
    tomatoLayer.frame = mainView.frame;
    [mainView.layer addSublayer:tomatoLayer];
    
    //create shadow for view
    CGColorRef shadowColor = CGColorCreateGenericRGB(0, 0, 0, 1);
    mainView.layer.shadowRadius = 5;
    mainView.layer.shadowOpacity = .5;
    mainView.layer.shadowColor = shadowColor;
    CGColorRelease(shadowColor);

    //set up normal layer
    [selectedBox setSelected:YES];
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
    AppDelegate *appDelegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
    [appDelegate externalInterruptionKeyed:nil];
}

- (IBAction)addInternalInterruption:(id)sender;
{
    AppDelegate *appDelegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
    [appDelegate internalInterruptionKeyed:nil];
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
    if((timerStatus == TimerStatusRunning || timerStatus == TimerStatusPaused) && currentTimer.type == TimerTypePomodoro)
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
    pomodoroCount.stringValue = [NSString stringWithFormat:@"%d", (int)[[Activity currentActivity].completedPomodoros count], nil];
    plannedPomodoroCount.stringValue = [[Activity currentActivity].plannedCount stringValue];
}

- (CABasicAnimation *)breatheAnimation;
{
    if(!breatheAnimation)
    {
        //animate opacity for now
        breatheAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        breatheAnimation.toValue = [NSNumber numberWithFloat:0.5];
        breatheAnimation.duration = 1.5;
        breatheAnimation.repeatCount = 1e10f;
        breatheAnimation.autoreverses = YES;
        breatheAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    }
    return breatheAnimation;
}

#pragma mark - Animation Methods

- (void)startGrowmato
{
    if(growmatoFrame == 30)
    {
        [animationTimer invalidate];
        animationTimer = nil;
        growmatoFrame = 0;
        return;
    }
    
    NSString *s  = [NSString stringWithFormat:@"growmato start_%04d.png", growmatoFrame, nil];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForImageResource:s];
    NSImage *i = [[NSImage alloc] initWithContentsOfFile:imagePath];
    tomatoLayer.contents = (id)i;
    growmatoFrame++; 
}

- (void)retractGrowmato
{
    if(growmatoFrame == 43)
    {
        [tomatomationTimer invalidate];
        tomatomationTimer = nil;
        growmatoFrame = 0;
        return;
    }
    
    NSString *s  = [NSString stringWithFormat:@"growmato retract_%04d.png", growmatoFrame, nil];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForImageResource:s];
    NSImage *i = [[NSImage alloc] initWithContentsOfFile:imagePath];
    tomatoLayer.contents = (id)i;
    
    growmatoFrame++;
}

- (void)growGrowmato
{
    if(growmatoFrame == 150)
    {
        return;
    }
    NSString *s  = [NSString stringWithFormat:@"growmato_%04d.png", growmatoFrame, nil];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForImageResource:s];
    NSImage *i = [[NSImage alloc] initWithContentsOfFile:imagePath];
    tomatoLayer.contents = (id)i;
    
//    tomatoLayer.contents = (id)[NSImage imageNamed:s];
    growmatoFrame++;
}

#pragma mark - Notification Methods

- (void)PomodoroRequested:(NSNotification *)note
{
    [self.window makeKeyAndOrderFront:nil];

    Activity *a = [Activity currentActivity];
    
    //remove all animations
    [activityNameLabel.layer removeAllAnimations]; 
    
    //populate activity name
    activityNameLabel.stringValue = a.name;
    
    //populate ribbon view
    ribbonView.plannedPomodoroCount = [a.plannedCount intValue];
    ribbonView.completePomodoroCount = (int)[a.completedPomodoros count];
    [ribbonView setNeedsDisplay:YES];
    
    //populate pomodoro counts
    [self updatePomodoroCount];
    
    //populate interruptions
    internalInterruptionLabel.stringValue = [[[Activity currentActivity] internalInterruptionCount] stringValue];
    externalInterruptionLabel.stringValue = [[[Activity currentActivity] externalInterruptionCount] stringValue];

    [containerView.layer removeAllAnimations];
    growmatoFrame = 0;
    animationTimer = [NSTimer timerWithTimeInterval:.0334
                                    target:self 
                                  selector:@selector(startGrowmato)
                                  userInfo:nil 
                                   repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:animationTimer forMode:NSRunLoopCommonModes];
}

- (void)PomodoroTimeStarted:(NSNotification *)note
{
    EggTimer *pomo = (EggTimer *)[note object];
    if(pomo.type == TimerTypePomodoro)
    {
        [self.window makeKeyAndOrderFront:nil];

        //should be accurate, we'll see
        EggTimer *pomo = (EggTimer *)[note object];        
        float intervalRate = pomo.timeEstimated / 150.0f;
        
        animationTimer = [NSTimer timerWithTimeInterval:intervalRate target:self selector:@selector(growGrowmato) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:animationTimer forMode:NSRunLoopCommonModes];
        [animationTimer fire];
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
    if(pomo.type == TimerTypePomodoro)
    {   
        //invalidate animation timers
        [animationTimer invalidate];
        animationTimer = nil;
        [tomatomationTimer invalidate];
        tomatomationTimer = nil;
        growmatoFrame = 0;
        
        //update ribbon UI
        Activity *a = [Activity currentActivity];
        ribbonView.plannedPomodoroCount = [a.plannedCount intValue];
        ribbonView.completePomodoroCount = (int)[a.completedPomodoros count];
        ribbonView.completed = [a.completed boolValue];

        [ribbonView setNeedsDisplay:YES];
        [self updatePomodoroCount];
        
        //kick off retract tomato animation
        tomatomationTimer = [NSTimer timerWithTimeInterval:.0334 
                                                    target:self 
                                                  selector:@selector(retractGrowmato) 
                                                  userInfo:nil 
                                                   repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:tomatomationTimer forMode:NSRunLoopCommonModes];
        [tomatomationTimer fire];
        [self mouseExited:nil];

        
        //TODO: make this count up after a pomodoro has been completed
        [activityNameLabel.layer addAnimation:[self breatheAnimation] forKey:@"opacity"];
    }
    
    if(pomo.type == TimerTypeLongBreak || pomo.type == TimerTypeShortBreak)
    {
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"autoStartNextPomodoro"])
            [self.window close];
    }
}

- (void)PomodoroStopped:(NSNotification *)note
{
    EggTimer *pomo = (EggTimer *)[note object];
    if(pomo.type == TimerTypePomodoro)
    {
        [animationTimer invalidate];
        animationTimer = nil;
        
        [tomatomationTimer invalidate];
        tomatomationTimer = nil;
        growmatoFrame = 0;
        
        [self.window close];
    }
}

- (void)pomodoroPaused:(NSNotification *)note
{
    [stopButton setAttributedTitle:resumeString];
    stopButton.image = [NSImage imageNamed:@"button-resume"];
    stopButton.alternateImage = [NSImage imageNamed:@"button-resume-down"];
}

- (void)pomodoroResume:(NSNotificationCenter *)note
{
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
