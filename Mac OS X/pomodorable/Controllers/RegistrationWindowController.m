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
    if(B_ZONKERS)
        [self showRegisteredInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4), dispatch_get_main_queue(), ^{
        
        NSString *urlAddress = @"http://piotrszwach.com";
        NSURL *url = [NSURL URLWithString:urlAddress];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        
        [self.webView setPostsFrameChangedNotifications:TRUE];
        [self.webView setFrameLoadDelegate:self];
        [self.webView setUIDelegate:self];
        [self.webView setResourceLoadDelegate:self];
        [self.webView setApplicationNameForUserAgent:@"FSEmbeddedStore/2.0"];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(webViewLoadedSite:)
                                                     name:WebViewProgressFinishedNotification
                                                   object:self.webView];
        
        [self.webView.mainFrame loadRequest:requestObj];
        NSLog(@"%@",self.webView.mainFrame);
        NSLog(@"%@",self.webView);
        NSLog(@"%@",requestObj);
        
    });
    
}

- (void)webViewLoadedSite:(NSNotification *)not{
    [self.webView setNeedsDisplay:YES];
}

#pragma mark - IBActions

- (IBAction)registerApplication:(id)sender;
{
    NSLog(@"CHUJ w dupe");
    //[self.webView setHidden:NO];
    //[(AppController *)_appController registerApp];
    //[self successfullyRegisteredApplication];
    
    NSString *fullNameString = fullName.stringValue;
    NSString *regKeyString = regKey.stringValue;
    [[NSUserDefaults standardUserDefaults] setObject:fullNameString forKey:@"registrationName"];
    [[NSUserDefaults standardUserDefaults] setObject:regKeyString forKey:@"registrationKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[ModelStore sharedStore] taskStoreInitialization];
    /*
     double delayInSeconds = 0.25;
     dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
     dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
     [[ModelStore sharedStore] taskStoreInitialization];
     });
     NSNumber *l = [NSNumber numberWithInt:(12 + 2)];
     [[ModelStore sharedStore] taskStoreInitialization:[NSArray arrayWithObjects:l, [NSDate date], nil]];
     });
     */
    
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
    [self.okButton setHidden:YES];
    [self.cancelButton setHidden:YES];
    [self.titleLabel setHidden:YES];
    [self.fullName setHidden:YES];
    [self.regKey setHidden:YES];
    [self.thanksForRegistering setHidden:NO];
}
@end
