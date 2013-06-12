//
//  RegistrationWindowController.h
//  Eggscellent
//
//  Created by Kyle kinkade on 5/12/13.
//  Copyright (c) 2013 Monocle Society LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "AppController.h"

@interface RegistrationWindowController : NSWindowController

@property (strong) IBOutlet NSTextField *fullName;
@property (strong) IBOutlet NSTextField *regKey;
@property (strong) IBOutlet NSTextField *thanksForRegistering;
@property (strong) IBOutlet NSTextField *titleLabel;
@property (strong) IBOutlet NSButton *okButton;
@property (strong) IBOutlet NSButton *cancelButton;
@property (strong) IBOutlet WebView *webView;
@property (strong) IBOutlet NSObject *appController;



- (IBAction)registerApplication:(id)sender;
- (IBAction)cancel:(id)sender;
@end

