//
//  ShortcutsPreferencesViewController.m
//  pomodorable
//
//  Created by Kyle Kinkade on 11/13/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//

#import "ShortcutsPreferencesViewController.h"
#import "SGKeyCombo.h"
#import "SGHotKeyCenter.h"

@implementation ShortcutsPreferencesViewController
@synthesize hotKeyExternalInterrupt;
@synthesize hotKeyInternalInterrupt;
@synthesize hotKeyStopPomodoro;
@synthesize hotKeyStartPomodoro;
@synthesize hotKeyTogglePomodoro;
@synthesize hotKeyToggleStatusItemWindow;
@synthesize hotKeyToggleHoverWindow;
@synthesize hotKeyToggleNoteWindow;
@synthesize window;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    //setup shortcuts
    recorderStopPomodoro.keyCombo = SRMakeKeyCombo(hotKeyStopPomodoro.keyCombo.keyCode, [recorderStopPomodoro carbonToCocoaFlags:hotKeyStopPomodoro.keyCombo.modifiers]);
    recorderToggleHoverWindow.keyCombo = SRMakeKeyCombo(hotKeyToggleHoverWindow.keyCombo.keyCode, [recorderToggleHoverWindow carbonToCocoaFlags:hotKeyToggleHoverWindow.keyCombo.modifiers]);
    recorderToggleNoteWindow.keyCombo = SRMakeKeyCombo(hotKeyToggleNoteWindow.keyCombo.keyCode, [recorderToggleNoteWindow carbonToCocoaFlags:hotKeyToggleNoteWindow.keyCombo.modifiers]);
    recorderToggleStatusItemWindow.keyCombo = SRMakeKeyCombo(hotKeyToggleStatusItemWindow.keyCombo.keyCode, [recorderToggleStatusItemWindow carbonToCocoaFlags:hotKeyToggleStatusItemWindow.keyCombo.modifiers]);
    recorderInternalInterrupt.keyCombo = SRMakeKeyCombo(hotKeyInternalInterrupt.keyCombo.keyCode, [recorderInternalInterrupt carbonToCocoaFlags:hotKeyInternalInterrupt.keyCombo.modifiers]);
    recorderExternalInterrupt.keyCombo = SRMakeKeyCombo(hotKeyExternalInterrupt.keyCombo.keyCode, [recorderExternalInterrupt carbonToCocoaFlags:hotKeyExternalInterrupt.keyCombo.modifiers]);
}

#pragma mark -
#pragma mark ShortcutRecorder Delegate Methods

- (void)keyCombo:(SGKeyCombo *)keyCombo changedForHotKey:(SGHotKey *)hotKey withKey:(NSString *)keyString
{
    hotKey.keyCombo = keyCombo;
    [[SGHotKeyCenter sharedCenter] registerHotKey:hotKey];
    [[NSUserDefaults standardUserDefaults] setObject:[keyCombo plistRepresentation] forKey:keyString];   
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)shortcutRecorder:(SRRecorderControl *)aRecorder isKeyCode:(NSInteger)keyCode andFlagsTaken:(NSUInteger)flags reason:(NSString **)aReason {	
	return NO;
}

- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo 
{
    SGKeyCombo *keyCombo = [SGKeyCombo keyComboWithKeyCode:[aRecorder keyCombo].code
                                                 modifiers:[aRecorder cocoaToCarbonFlags:[aRecorder keyCombo].flags]];
    
    if(aRecorder == recorderToggleStatusItemWindow)
        [self keyCombo:keyCombo changedForHotKey:self.hotKeyToggleStatusItemWindow withKey:HOTKEY_TOGGLE_STATUSITEM_WINDOW];
    
    if(aRecorder == recorderStopPomodoro)
        [self keyCombo:keyCombo changedForHotKey:self.hotKeyStopPomodoro withKey:HOTKEY_STOP_POMODORO];
    
    if(aRecorder == recorderToggleHoverWindow)
        [self keyCombo:keyCombo changedForHotKey:self.hotKeyToggleHoverWindow withKey:HOTKEY_TOGGLE_HOVER_WINDOW];
    
    if(aRecorder == recorderToggleNoteWindow)
        [self keyCombo:keyCombo changedForHotKey:self.hotKeyToggleNoteWindow withKey:HOTKEY_TOGGLE_NOTE_WINDOW];
    
    if(aRecorder == recorderExternalInterrupt)
        [self keyCombo:keyCombo changedForHotKey:self.hotKeyToggleStatusItemWindow withKey:HOTKEY_EXTERNAL_INTERRUPTION];
    
    if(aRecorder == recorderInternalInterrupt)
        [self keyCombo:keyCombo changedForHotKey:self.hotKeyToggleStatusItemWindow withKey:HOTKEY_INTERNAL_INTERRUPTION];
}

#pragma mark - MASPreferencesViewController Methods

- (NSString *)identifier
{
    return @"ShortcutsPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:@"gear"];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Shortcuts", @"Toolbar item name for the General preference pane");
}

- (CGFloat)initialHeightOfView;
{
    return self.view.frame.size.height;
}
@end
