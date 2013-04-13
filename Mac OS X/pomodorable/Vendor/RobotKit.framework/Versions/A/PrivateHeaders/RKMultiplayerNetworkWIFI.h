//
//  RKMultiplayerNetworkWIFI.h
//  RobotKit
//
//  Created by Jon Carroll on 8/8/11.
//  Copyright 2011 Orbotix Inc. All rights reserved.
//
//  Description: Represents layer 1 in the RKMultiplayer stack.
//  Used for a cross platform wifi connection over BSD sockets.

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
    #include <CFNetwork/CFNetwork.h>
#else
    #include <CoreServices/CoreServices.h>
#endif

#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

@class RKMultiplayerDataJSON;

@interface RKMultiplayerNetworkWIFI : NSObject <NSStreamDelegate> {
    NSInputStream               *istream;
    NSOutputStream              *ostream;
    NSMutableData               *ibuffer;
    NSMutableData               *obuffer;
    RKMultiplayerDataJSON       *data;
    int                         curMsgLen;
    BOOL                        isValid;
}

@property BOOL isValid;

-(RKMultiplayerNetworkWIFI*)initWithInputStream:(NSInputStream*)istr outputStream:(NSOutputStream*)ostr dataLayer:(RKMultiplayerDataJSON*)_data;
-(void)sendData:(NSString*)_data;
-(BOOL)canClose;
-(void)invalidate;

@end
