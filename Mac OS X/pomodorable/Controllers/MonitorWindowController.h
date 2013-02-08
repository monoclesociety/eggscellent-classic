//
//  MonitorWindowController.h
//  pomodorable
//
//  Created by Kyle Kinkade on 11/23/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "PomodoroCounterView.h"
#import "ModelStore.h"
#import "ColorView.h"
#import "RoundedBox.h"
#import "PomodoroBadgeView.h"
#import "BackgroundView.h"

@interface MonitorWindowController : NSWindowController
{
    //general items
    CALayer                         *tomatoLayer;
    IBOutlet NSView                 *growmatoView;
    IBOutlet NSView                 *containerView;
    IBOutlet PomodoroBadgeView      *ribbonView;
    IBOutlet NSTextField            *pomodoroCount;
    IBOutlet NSTextField            *plannedPomodoroCount;
    CABasicAnimation                *breatheAnimation;
    
    //mouseover view items
    IBOutlet BackgroundView         *mouseoverView;
    IBOutlet NSTextField            *timerLabel;
    IBOutlet NSTextField            *internalInterruptionLabel;
    IBOutlet NSTextField            *externalInterruptionLabel;
    IBOutlet NSButton               *stopButton;
    
    //non-mouseover view items
    IBOutlet BackgroundView         *normalView;
    IBOutlet NSTextField            *activityNameLabel;
    IBOutlet RoundedBox             *selectedBox;
    
    NSAttributedString              *stopString;
    NSAttributedString              *resumeString;
    
    //non view members
    NSTimer                         *animationTimer; //TODO: look into other options
    NSTimer                         *tomatomationTimer;
    Activity                        *currentActivity;
    int                              growmatoFrame;
}

- (IBAction)addExternalInterruption:(id)sender;
- (IBAction)addInternalInterruption:(id)sender;
- (IBAction)stopPomodoro:(id)sender;

- (CABasicAnimation *)breatheAnimation;

@end
