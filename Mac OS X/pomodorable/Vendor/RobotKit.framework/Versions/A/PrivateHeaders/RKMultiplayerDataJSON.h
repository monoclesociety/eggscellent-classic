//
//  RKMultiplayerDataJSON.h
//  RobotKit
//
//  Created by Jon Carroll on 8/8/11.
//  Copyright 2011 Orbotix Inc. All rights reserved.
//
//  Description: Represents layer 2 in the RKMultiplayer stack.
//  Will encode and decode jason passing it between layer 1 and 3.

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "RKRemotePlayer.h"

@class RKMultiplayer;
@class RKMultiplayerNetworkWIFI;

@interface RKMultiplayerDataJSON : NSObject {
    RKMultiplayer *delegate;
    RKSBJsonParser *parser;
    RKSBJsonWriter *writer;
}

-(void)sendToAll:(NSDictionary*)data;
-(void)sendToPlayer:(RKRemotePlayer*)player data:(NSDictionary*)data;

-(void)recievedData:(NSString*)data fromConnection:(RKMultiplayerNetworkWIFI*)connection;

@property (nonatomic, assign) RKMultiplayer *delegate;

@end
