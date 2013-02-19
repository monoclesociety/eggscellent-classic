//
//  OverviewTableCellView.h
//  pomodorable
//
//  Created by Kyle Kinkade on 11/9/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//

#import <AppKit/AppKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PomodoroCounterView.h"
#import "RoundedBox.h"
#import "ColorView.h"

@class PomodoroBadgeView;
@interface OverviewTableCellView : NSTableCellView
{
    //standard item elements
    IBOutlet NSTextField    *plannedCount;
    IBOutlet NSTextField    *actualCount;
    IBOutlet PomodoroBadgeView *ribbonView;

    //selection status elements
    IBOutlet NSImageView    *__weak backgroundClip;
    IBOutlet ColorView      *coverupView;
    
    //slide out
    IBOutlet NSView         *__weak editContainerView;
    IBOutlet NSTextField    *externalInterruptionLabel;
    IBOutlet NSTextField    *internalInterruptionLabel;
    IBOutlet PomodoroCounterView *pomodoroCounterView;
    
    //distraction
    IBOutlet NSButton       *decreasePomodoroCountButton;
    IBOutlet NSButton       *increasePomodoroCountButton;
    
    BOOL                    _selected;
}
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, weak) NSImageView *backgroundClip;
@property (nonatomic, weak) NSView      *editContainerView;

+ (CGFloat)heightForTitle:(NSString *)title selected:(BOOL)selected;
+ (CGFloat)heightOfTitle:(NSString *)title;

- (IBAction)increasePomodoroCount:(id)sender;
- (IBAction)decreasePomodoroCount:(id)sender;
- (IBAction)internalInterruptionSelected:(id)sender;
- (IBAction)externalInterruptionSelected:(id)sender;
- (IBAction)toggleCompleteActivity:(id)sender;
- (void)modifyPomodoroCount:(int)delta;

@end
