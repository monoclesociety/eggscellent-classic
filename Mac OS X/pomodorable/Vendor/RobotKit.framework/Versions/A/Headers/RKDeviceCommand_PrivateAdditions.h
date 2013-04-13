//
//  RKDeviceCommand_PrivateAdditions.h
//  RobotKit
//
//  Created by Brian Smith on 5/27/11.
//  Copyright 2011 Orbotix Inc. All rights reserved.
//

/*! @ignore */

#import <Foundation/Foundation.h>
#import <RobotKit/RKDeviceCommand.h>

@interface RKDeviceCommand (PrivateAdditions)

@property (nonatomic, readonly) uint8_t		identifier;
@property (nonatomic, readonly) uint8_t		deviceIdentifier;
@property (nonatomic, readonly) NSData		*packedData;
@property (nonatomic, readonly) NSString	*designator;

- (NSData *)packetize;
- (uint8_t)calculatePacketDataLength;

- (void)setTransmitTimeStamp:(NSTimeInterval)timeStamp;

@end
