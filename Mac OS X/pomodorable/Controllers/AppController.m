//
//  AppController.m
//  Eggscellent
//
//  Created by Wojciech Roszkowiak on 6/11/13.
//  Copyright (c) 2013 Monocle Society LLC. All rights reserved.
//

#import "AppController.h"


@implementation AppController

- (id) init
{
	self = [super init];
	if (self != nil) {
		self.storeController = [[FsprgEmbeddedStoreController alloc] init];
        self.storeController.delegate = self;
	}
	return self;
}

- (void)awakeFromNib
{
    self.storeController.webView = _storeView;
}


- (void)registerApp{
    [self load:nil];
}
- (IBAction)load:(id)sender
{
	FsprgStoreParameters *parameters = [FsprgStoreParameters parameters];
	[parameters setOrderProcessType:kFsprgOrderProcessDetail];
	[parameters setStoreId:@"monoclesociety" withProductId:@"eggscellent"];
	[parameters setMode:kFsprgModeTest];
    
    [parameters setContactFname:@"test"];	
	[self.storeController loadWithParameters:parameters];
}

// FsprgEmbeddedStoreDelegate

- (void)didLoadStore:(NSURL *)url
{
}

- (void)didLoadPage:(NSURL *)url ofType:(FsprgPageType)pageType
{
}

- (void)didReceiveOrder:(FsprgOrder *)order
{
    NSEnumerator *e = [[order orderItems] objectEnumerator];
    FsprgOrderItem *item = nil;
    while (item = [e nextObject]) {
        if ([[item productName] hasPrefix:@"MyItemNamePrefix"]) {
            NSString *userName = [[item license] licenseName];
            NSString *serialNumber = [[item license] firstLicenseCode];
            if ([[[item productName] lowercaseString] rangeOfString:@"upgrade"].location != NSNotFound) {
                NSLog(@"Upgrade purchase:\nName: %@\nSerial #: %@", userName, serialNumber);
            } else {
                NSLog(@"Full purchase:\nName: %@\nSerial #: %@", userName, serialNumber);
            }
        }
    }
}

- (NSView *)viewWithFrame:(NSRect)frame forOrder:(FsprgOrder *)order
{
    return nil;
//	OrderViewController *orderViewController = [[OrderViewController alloc] initWithNibName:@"OrderView" bundle:nil];
//	[orderViewController setRepresentedObject:order];
//    
//	[[orderViewController view] setFrame:frame];
//	return [orderViewController view];
}

- (void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
	NSRunAlertPanel(@"Alert", [error localizedDescription], @"OK", nil, nil);
}

- (void)webView:(WebView *)sender didFailLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
	NSRunAlertPanel(@"Alert", [error localizedDescription], @"OK", nil, nil);
}

@end
