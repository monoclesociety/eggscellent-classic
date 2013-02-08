//
//  RemoteController.h
//  pomodorable
//
//  Created by Kyle Kinkade on 12/11/11.
//  Copyright (c) 2011 Monocle Society LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

#define PAIRING_REQUESTED @"PAIRING_REQUESTED";

@interface RemoteServerController : NSObject <NSNetServiceDelegate>
{
    NSNetService        *netService;
    GCDAsyncSocket      *asyncSocket;
    
    NSMutableArray      *connectedSockets;
    
    BOOL                *running;
    BOOL                *paired;
}
@property (nonatomic, readonly) BOOL *paired;
@property (nonatomic, readonly) BOOL *running;

- (BOOL)start;
- (void)stop;
- (void)disconnect;

@end
