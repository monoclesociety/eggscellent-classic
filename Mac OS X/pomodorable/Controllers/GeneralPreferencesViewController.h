//
//  GeneralPreferencesViewController.h
//  pomodorable
//
//  Created by Kyle Kinkade on 11/12/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MASPreferencesViewController.h"

@interface GeneralPreferencesViewController : NSViewController <MASPreferencesViewController>
{
    IBOutlet NSPopUpButton  *pomodoroTimeSelection;
    IBOutlet NSPopUpButton  *shortBreakSelection;
    IBOutlet NSPopUpButton  *longBreakSelection;
    IBOutlet NSButton       *autoLoginCheckbox;
    IBOutlet NSButton       *toggleHelperWindowButton;
    IBOutlet NSButton       *toggleHelperMonitorWindowLevelButton;
    
    IBOutlet NSPopUpButton  *notesSelection;
    IBOutlet NSTextField    *notesLabel;
}
@property (nonatomic, weak) NSWindow *window;

- (IBAction)toggleAutoLogin:(id)sender;
- (IBAction)toggleHelperWindow:(id)sender;
- (IBAction)toggleMonitorWindowOnTop:(id)sender;

@end
