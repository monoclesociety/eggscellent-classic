//
//  RKMultiplayerData.h
//  RobotKit
//
//  Created by Jon Carroll on 8/8/11.
//  Copyright 2011 Orbotix Inc. All rights reserved.
//  
//  Description: RKMultiplayerData protocol.
//  Methods to implement with other data encodings.

#import <Foundation/Foundation.h>

@class RKMultiplayerNetwork;
@class RKMultiplayer;

@interface RKMultiplayerData :NSObject {
    
}

@end

@protocol RKMultiplayerDataProtocol

//Initial Setup
-(void)setManager:(RKMultiplayer*)manager;
-(void)setNetwork:(RKMultiplayerNetwork*)network;
//Data sending and recieving
-(void)encodeAndSendData:(NSDictionary*)data;
-(void)decodeRecievedData:(NSData*)data;
@end