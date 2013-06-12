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

#pragma mark - IBActions

- (IBAction)registerApplication:(id)sender;
{
    NSLog(@"CHUJ w dupe");
    [_storeView setHidden:NO];
    [(AppController *)_appController registerApp];
    //[self successfullyRegisteredApplication];
    
    NSString *fullNameString = fullName.stringValue;
    NSString *regKeyString = regKey.stringValue;
    [[NSUserDefaults standardUserDefaults] setObject:fullNameString forKey:@"registrationName"];
    [[NSUserDefaults standardUserDefaults] setObject:regKeyString forKey:@"registrationKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
/*
    double delayInSeconds = 0.25;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSNumber *l = [NSNumber numberWithInt:(12 + 2)];
        [[ModelStore sharedStore] taskStoreInitialization:[NSArray arrayWithObjects:l, [NSDate date], nil]];
    });*/
    
}

- (IBAction)cancel:(id)sender;
{
    [self.window close];
}
- (void)successfullyRegisteredApplication{
    [self showRegisteredInfo];
    [[NSNotificationCenter defaultCenter] postNotification:EGG_REGISTERED];
}
- (void)showRegisteredInfo{
    [self.okButton setHidden:YES];
    [self.cancelButton setHidden:YES];
    [self.titleLabel setHidden:YES];
    [self.fullName setHidden:YES];
    [self.regKey setHidden:YES];
    [self.thanksForRegistering setHidden:NO];
}
@end
