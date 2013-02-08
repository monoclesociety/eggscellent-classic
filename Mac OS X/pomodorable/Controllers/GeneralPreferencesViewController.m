//
//  GeneralPreferencesViewController.m
//  pomodorable
//
//  Created by Kyle Kinkade on 11/12/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//

#import "GeneralPreferencesViewController.h"
#import "AppDelegate.h"

@implementation GeneralPreferencesViewController
@synthesize window;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"GeneralPreferencesViewController" bundle:nibBundleOrNil];
    if (self) 
    {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSInteger state = ([[NSUserDefaults standardUserDefaults] boolForKey:@"autoLogin"]) ? NSOnState : NSOffState;
    [autoLoginCheckbox setState:state];
    
    NSNumber *floatWindow = [[NSUserDefaults standardUserDefaults] objectForKey:@"monitorWindowOnTop"];

    if(!floatWindow)
    {
        toggleHelperMonitorWindowLevelButton.state = 1;
    }
}

- (void)viewWillAppear;
{

}

#pragma mark - MASPreferencesViewController Methods

- (NSString *)identifier
{
    return @"GeneralPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:@"lightswitch"];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"General", @"Toolbar item name for the General preference pane");
}

- (CGFloat)initialHeightOfView;
{
    return self.view.frame.size.height;
}

#pragma mark - IBActions

- (IBAction)toggleAutoLogin:(id)sender;
{
    NSButton *b = (NSButton*)sender;
    BOOL autoLogin = ([b state] == NSOnState);

    AppDelegate *appDelegate = (AppDelegate *)[NSApplication sharedApplication].delegate;    
    if(autoLogin)
    {
        [appDelegate updateLoginItem:YES];
    }
    else
    {
        [appDelegate updateLoginItem:NO];
    }
}

- (IBAction)toggleHelperWindow:(id)sender
{
    AppDelegate *appD = (AppDelegate *)[NSApplication sharedApplication].delegate;
    
    BOOL loadWindow = (toggleHelperWindowButton.state == 1);

    
    [appD loadHelperWindow:loadWindow withNormalSize:YES];
}

- (IBAction)toggleMonitorWindowOnTop:(id)sender;
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"monitorWindowOnTop" object:nil];
}

@end