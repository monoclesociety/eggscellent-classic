//
//  RemoteClientController.h
//  pomodorable
//
//  Created by Kyle Kinkade on 1/30/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@interface RemoteClientController : NSObject <NSNetServiceBrowserDelegate, NSNetServiceDelegate>
{
    NSNetServiceBrowser *netServiceBrowser;
    NSNetService *serverService;
	NSMutableArray *serverAddresses;
	GCDAsyncSocket *asyncSocket;
    BOOL connected;
    
    NSMutableArray *listedDevices;
    NSMutableArray *connectedDevices;
    NSMutableArray *friendedDevices;
}
@property (nonatomic, readonly) NSMutableArray *listedDevices;

+ (RemoteClientController *)sharedClient;

@end
