//
//  RKRobotMac.h
//  RobotKit
//
//  Created by Michael DePhillips on 6/22/12.
//  Copyright (c) 2012 Orbotix Inc. All rights reserved.
//

#import "RKRobot.h"
#import <IOBluetooth/IOBluetooth.h>

@interface RKRobotMac : RKRobot {
    IOBluetoothDevice* accessory;
    BluetoothRFCOMMChannelID channelID;
    IOBluetoothRFCOMMChannel* channel;
    IOBluetoothUserNotification* disconnectNotification;
}


/*! The EAAccessory object that is associated with the robot */
@property (nonatomic, readonly) IOBluetoothDevice* accessory;
@property (nonatomic, readonly) BluetoothRFCOMMChannelID channelID;
@property (nonatomic, readonly) IOBluetoothRFCOMMChannel*   channel;

/*! 
 *  Initializes with a EAAccesory object for the robot.
 *  @param anAccessory A EAAccesory object for the robot.
 *  @return The initialized RKRobot object or nil if initialization failed.
 */
- (id)initWithAccessory:(IOBluetoothDevice *)anAccessory;

/*!
 * Test that the robot object is equal to this robot which means the represent the
 * same device.
 * @param robot The other robot object.
 * @return YES if the other object represents the same robot device. 
 */
- (BOOL)isEqualToRobot:(RKRobot *)robot;

@end
