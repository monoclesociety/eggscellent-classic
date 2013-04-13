//
//  RKDeviceResponse_PrivateAdditions.h
//  RobotKit
//
//  Created by Brian Smith on 5/27/11.
//  Copyright 2011 Orbotix Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RobotKit/RKDeviceResponse.h>

@class RKDeviceCommand;

@interface RKDeviceResponse (PrivateAdditions)

/*!
 *  This class method needs to be overriden by subclasses to return the 
 *  Sphero API command code that the response corrisponds to.
 *  @return The command code.
 */
+ (uint8_t)commandIdentifier;

/*!
 *  This class method needs to be overriden by subclasses to return the device id
 *  that the response belongs to.
 */
+ (uint8_t)deviceIdentifier;

/*!
 *  Used by the framework to post responses to observers.
 *  @param  command The original command for the response.
 *  @param  code    The code returned with the response.
 *  @param  data    The data contained in the response. Can be nil or the NSNull object.
 */
+ (void)sendResponseForCommand:(RKDeviceCommand *)command code:(NSInteger)code data:(NSData *)data;

/*!
 *  Used to initialize a subclass based on commparing the command's identifier and 
 *  for with response object's intended command identifier. Subclass should not
 *  override this method.
 *  @param command The original command sent for the response.
 *  @param receiveCode The code returned in the response.
 *  @return The initialized object, or nil if the response object being initialized
 *  does not have the same command identifier.
 */
- (id)initForCommand:(RKDeviceCommand *)command
                code:(NSInteger)receivedCode;

/*!
 *  A subclass can override this initializer to parse out the data, otherwise the 
 *  base class initializer will handle initializing the subclass. The base
 *  RKDeviceCommand initializer will find and create an object with the correct
 *  type for the command.
 *  @param command The original command sent for the response.
 *  @param receiveCode The code returned in the response.
 *  @param data The data returned in the response. This can be nil or NSNull.
 *  @return The initialize subclass for the command, or nil if there is no 
 *  RKDeviceResponse subclass savailable for the command.
 */
- (id)initForCommand:(RKDeviceCommand *)command 
								code:(NSInteger)receivedCode
								data:(NSData *)data;

@end
