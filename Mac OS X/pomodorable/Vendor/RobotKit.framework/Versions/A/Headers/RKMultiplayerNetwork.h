//
//  RKMultiplayerNetwork.h
//  RobotKit
//
//  Created by Jon Carroll on 8/8/11.
//  Copyright 2011 Orbotix Inc. All rights reserved.
//
//  Description: RKMultiplayerNetwork protocol for implementing other network types.

#import <Foundation/Foundation.h>
//#import "RKMultiplayerData.h"

@class RKMultiplayerData;

@interface RKMultiplayerNetwork :NSObject {
    
}

@end

@protocol RKMultiplayerNetworkProtocol <NSObject>
-(void)setDataDelegate:(RKMultiplayerData*)data;
-(void)sendData:(NSData*)data;

@end
