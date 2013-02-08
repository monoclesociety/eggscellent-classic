//
//  WelcomeWindowController.h
//  pomodorable
//
//  Created by Kyle Kinkade on 12/3/11.
//  Copyright (c) 2011 Monocle Society LLC  All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WelcomeWindowController : NSWindowController
{
    IBOutlet NSView *generalOptionsView;
    IBOutlet NSView *integrationOptionsView;
    
    IBOutlet NSView *moreInformationView;
    IBOutlet NSTextField *pomodoroBookLink;
    IBOutlet NSTextField *pomodoroCheatSheetLink;
    IBOutlet NSTextField *pomodorableFeedbackAndSupportLink;
    IBOutlet NSTextField *pomodorableTwitterLink;
    IBOutlet NSTextField *pomodorableFacebookLink;
    
    IBOutlet NSPopUpButton *taskIntegrationButton;
    
    BOOL autoLogin;
}

//General IBActions
- (IBAction)toggleAutoLogin:(id)sender;
- (IBAction)changeTaskManagerTyper:(id)sender;

//Navigation IBActions
- (IBAction)goBackToGeneralView:(id)sender;
- (IBAction)presentIntegrationView:(id)sender;
- (IBAction)presentMoreInformationView:(id)sender;
- (IBAction)finishWelcomeExperience:(id)sender;

@end
