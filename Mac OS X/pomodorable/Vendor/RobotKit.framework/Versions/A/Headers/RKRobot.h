//
//  RKRobot.h
//  RobotKit
//
//  Copyright 2010 Orbotix Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! @file */

/*!
 *  @brief Represents the robot connection data and physical properties.
 *
 *  A RKRobot object provides the data needed to connect to a robotic data along
 *  physical properties associated with the device.
 */
@interface RKRobot : NSObject {
    @private
    NSString        *name;
    NSString        *bluetoothAddress;
    NSTimeInterval  timeOffset;
    
    float           userColorRedIntensity;
    float           userColorGreenIntensity;
    float           userColorBlueIntensity;
}

/*! A product name for the robot */
@property (nonatomic, retain) NSString *name;
/*! The bluetooth MAC address for the robot */
@property (nonatomic, readonly) NSString *bluetoothAddress;

/*! Robot has firmware support for vector command. The default value is NO. */
@property (nonatomic, readonly) BOOL supportsVectorCommand;

/*! The time offset needed to convert the robot's time reference into the iOS device's time reference. */
@property (nonatomic, readonly) NSTimeInterval timeOffset;
/*! User color of RGB that is remembered even when Sphero is turned on and off */
@property (nonatomic, assign) float userColorRedIntensity;
@property (nonatomic, assign) float userColorGreenIntensity;
@property (nonatomic, assign) float userColorBlueIntensity;

@end
