//
//  AppDelegate.h
//  pomodorable
//
//  Created by Kyle Kinkade on 11/5/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>

#import "ChatController.h"
#import "MonitorWindowController.h"
#import "MASPreferencesWindowController.h"
#import "HistoryWindowController.h"
#import "PanelController.h"
#import "WindowController.h"

#import "StatusItemView.h"
#import "IdleTime.h"
#import "SGHotKey.h"

#import "TaskSyncController.h"
#import "OmniFocusSyncController.h"
#import "ThingsSyncController.h"
#import "RemindersSyncController.h"
#import "CalendarController.h"

@class WelcomeWindowController;
@interface AppDelegate : NSObject <NSApplicationDelegate, PanelControllerDelegate>
{
    NSStatusItem                    *statusItem;
    StatusItemView                  *statusView;
    PanelController                 *panelController;
    WindowController                *windowController;
    MASPreferencesWindowController  *preferencesWindow;
    ChatController                  *chatController;
    TaskSyncController              *taskSyncController;
    MonitorWindowController         *monitorWindowController;
    WelcomeWindowController         *welcomeWindowController;
    HistoryWindowController         *historyWindowController;
    CalendarController              *calendarController;
    
    SGHotKey    *hotKeyStopPomodoro;
    SGHotKey    *hotKeyExternalInterrupt;
    SGHotKey    *hotKeyInternalInterrupt;
    SGHotKey    *hotKeyToggleStatusItemWindow;
    SGHotKey    *hotKeyToggleHoverWindow;
    SGHotKey    *hotKeyToggleNoteWindow;
    
    int         breakCounter;
    AVAudioPlayer     *windUpSound;
    AVAudioPlayer     *tickSound;
    AVAudioPlayer     *pomodoroCompleteSound;
    AVAudioPlayer     *breakCompleteSound;
    
    int         lastRecordedIdleTime;
    IdleTime    *idleTime;
    NSTimer     *idleTimer;
    NSAlert     *idleAlert;
    NSAlert     *errorAlert;
}
@property (nonatomic, strong) PanelController *panelController;
@property (nonatomic, strong) TaskSyncController *taskSyncController;
@property (nonatomic, strong) SGHotKey *hotKeyStopPomodoro;
@property (nonatomic, strong) SGHotKey *hotKeyExternalInterrupt;
@property (nonatomic, strong) SGHotKey *hotKeyInternalInterrupt;
@property (nonatomic, strong) SGHotKey *hotKeyToggleStatusItemWindow;
@property (nonatomic, strong) SGHotKey *hotKeyToggleHoverWindow;
@property (nonatomic, strong) SGHotKey *hotKeyToggleNoteWindow;

@property (nonatomic, strong) AVAudioPlayer *windUpSound;
@property (nonatomic, strong) AVAudioPlayer *tickSound;
@property (nonatomic, strong) AVAudioPlayer *pomodoroCompleteSound;
@property (nonatomic, strong) AVAudioPlayer *breakCompleteSound;

- (StatusItemView *)statusItemView;
- (void)openPreferences;
- (void)setDefaults;

- (void)loadHelperWindow:(BOOL)shouldLoad withNormalSize:(BOOL)normalSize;
- (void)updateLoginItem:(BOOL)loginItem;

- (void)setupTaskSyncing;

//hotkey methods
- (void)toggleNoteKeyed:(id)sender;
- (void)externalInterruptionKeyed:(id)sender;
- (void)internalInterruptionKeyed:(id)sender;

- (void)setupTaskSyncing;
- (IBAction)togglePanel:(id)sender;
@end