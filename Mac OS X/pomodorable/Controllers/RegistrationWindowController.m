//
//  RegistrationWindowController.m
//  Eggscellent
//
//  Created by Kyle kinkade on 5/12/13.
//  Copyright (c) 2013 Monocle Society LLC. All rights reserved.
//

#import "RegistrationWindowController.h"
#import "ModelStore.h"

@interface RegistrationWindowController ()

@end

@implementation RegistrationWindowController
@synthesize fullName;
@synthesize regKey;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self)
    {
        // Initialization code here.

    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.appController.delegate = self;

    if ([[ModelStore sharedStore] taskStoreInitialization])
        [self showRegisteredInfo];
    
}

- (void)webViewLoadedSite:(NSNotification *)not{
    [self.webView setNeedsDisplay:YES];
}

#pragma mark - IBActions
- (IBAction)buyApplication:(id)sender{
    [self.buyWindow makeKeyAndOrderFront:self];
    [self.appController loadStorePage];
}
- (IBAction)registerApplication:(id)sender;
{
    NSString *fullNameString = fullName.stringValue;
    NSString *regKeyString = regKey.stringValue;
    [[NSUserDefaults standardUserDefaults] setObject:fullNameString forKey:@"registrationName"];
    [[NSUserDefaults standardUserDefaults] setObject:regKeyString forKey:@"registrationKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([[ModelStore sharedStore] taskStoreInitialization])
        [self successfullyRegisteredApplication];
    else
        NSRunAlertPanel(@"Alert", @"Incorrect user name or serial number", @"OK", nil, nil);

    
}

- (IBAction)cancel:(id)sender;
{
    [self.window close];
}
- (void)successfullyRegisteredApplication{
    B_ZONKERS = YES;
    [self showRegisteredInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:EGG_REGISTERED object:nil];
}
- (void)showRegisteredInfo{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"registrationName"];
    NSString *serialNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"registrationKey"];
    //[self.infoTextField setStringValue:userInfo];
    [self.okButton setTitle:@"OK"];
    [self.okButton setAction:@selector(cancel:)];
    [self.cancelButton setHidden:YES];
    [self.titleLabel setHidden:YES];
    [self.fullName setStringValue:userName];
    [self.fullName setEnabled:NO];
    [self.regKey setStringValue:serialNumber];
    [self.regKey setEnabled:NO];
    [self.buyButton setHidden:YES];
    [self.thanksForRegistering setHidden:NO];
    
}

#pragma mark - AppControllerDelegate methods
- (void)productPurchasedForName:(NSString *)userName serialNumber:(NSString *)serialNumber{
    NSLog(@">>> product purchased!");
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"registrationName"];
    [[NSUserDefaults standardUserDefaults] setObject:serialNumber forKey:@"registrationKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.buyWindow close];
    [self showRegisteredInfo];
}

@end
