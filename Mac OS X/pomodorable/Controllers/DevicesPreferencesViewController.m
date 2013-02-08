//
//  DevicesPreferencesViewController.m
//  pomodorable
//
//  Created by Kyle Kinkade on 1/31/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import "DevicesPreferencesViewController.h"
#import "RemoteClientController.h"

@implementation DevicesPreferencesViewController
@synthesize arrayController;
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
    arrayController.content = [RemoteClientController sharedClient].listedDevices;
    [[RemoteClientController sharedClient] addObserver:self forKeyPath:@"listedDevices" options:0 context:NULL];
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //[arrayController performSelector:@selector(rearrangeObjects) withObject:nil afterDelay:1];
    [arrayController rearrangeObjects];
}

#pragma mark - MASPreferencesViewController Methods

- (NSString *)identifier
{
    return @"Devices Preferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:@"sync"];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Devices", @"Toolbar item name for the General preference pane");
}

#pragma mark IBActions

- (IBAction)debugSelected:(id)sender
{
    [arrayController rearrangeObjects];
}

@end