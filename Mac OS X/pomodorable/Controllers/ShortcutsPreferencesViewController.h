//
//  ShortcutsPreferencesViewController.h
//  pomodorable
//
//  Created by Kyle Kinkade on 11/13/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MASPreferencesViewController.h"
#import "ShortcutRecorder.h"
#import "SGHotKey.h"
#import "ShortcutRecorder.h"

@interface ShortcutsPreferencesViewController : NSViewController <MASPreferencesViewController>
{
    IBOutlet SRRecorderControl *recorderStartPomodoro;
    IBOutlet SRRecorderControl *recorderStopPomodoro;
    IBOutlet SRRecorderControl *recorderTogglePomodoro;
    IBOutlet SRRecorderControl *recorderExternalInterrupt;
    IBOutlet SRRecorderControl *recorderInternalInterrupt;
    IBOutlet SRRecorderControl *recorderToggleStatusItemWindow;
    IBOutlet SRRecorderControl *recorderToggleHoverWindow;
    IBOutlet SRRecorderControl *recorderToggleNoteWindow;

    SGHotKey *hotKeyStartPomodoro;
    SGHotKey *hotKeyStopPomodoro;
    SGHotKey *hotKeyTogglePomodoro;
    SGHotKey *hotKeyExternalInterrupt;
    SGHotKey *hotKeyInternalInterrupt;
    SGHotKey *hotKeyToggleStatusItemWindow;
    SGHotKey *hotKeyToggleHoverWindow;
    SGHotKey *hotKeyToggleNoteWindow;
}
@property (nonatomic, strong) SGHotKey *hotKeyStartPomodoro;
@property (nonatomic, strong) SGHotKey *hotKeyStopPomodoro;
@property (nonatomic, strong) SGHotKey *hotKeyTogglePomodoro;
@property (nonatomic, strong) SGHotKey *hotKeyExternalInterrupt;
@property (nonatomic, strong) SGHotKey *hotKeyInternalInterrupt;
@property (nonatomic, strong) SGHotKey *hotKeyToggleStatusItemWindow;
@property (nonatomic, strong) SGHotKey *hotKeyToggleHoverWindow;
@property (nonatomic, strong) SGHotKey *hotKeyToggleNoteWindow;

@property (nonatomic, weak) NSWindow *window;

@end
