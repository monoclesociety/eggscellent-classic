//
//  RKDeviceMessenger_DeviceConnectionAdditions.h
//  RobotKit
//
//  Created by Brian Smith on 5/27/11.
//  Copyright 2011 Orbotix Inc. All rights reserved.
//

/*! @ignore */

#import <Foundation/Foundation.h>
#import "RKDeviceMessenger.h"


@class RKDeviceConnection;
@class RKDeviceResponse;
@class RKDeviceAsyncData;
@class RKRobot;

// PRIVATE INTERFACE DO NOT INCLUDE IN PUBLIC API.
/*!
 * Category for methods that RKDeviceConnection uses to interface with the 
 * messaging system.
 */
@interface RKDeviceMessenger (DeviceConnectionAdditions) 

/*!
 * Method used by RKDeviceConnection to settup for receiving commands.
 * @param deviceConnection The RKDeviceConnection object that will process 
 * commands.
 */
- (void)setDeviceConnection:(RKDeviceConnection *)deviceConnection;
/*!
 * Method used to post RKDeviceResponce objects by receiving code
 * pass on to observers.
 * @param response The RKDeviceResponse object with the response code and data
 * returned from the device for a command.
 */
- (void)postResponse:(RKDeviceResponse *)response;
/*!
 * Method used to post RKDeviceAsyncData objects received from the device.
 * @param data The RKDeviceAsyncData object with data received from the device.
 */
- (void)postAsyncData:(RKDeviceAsyncData *)data;

@end
