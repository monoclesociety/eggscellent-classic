//
//  RKRobotProviderMac.h
//  RobotKit
//
//  Created by Michael DePhillips on 6/20/12.
//  Copyright (c) 2012 Orbotix Inc. All rights reserved.
//

#import "RKRobotProvider.h"
#import <IOBluetoothUI/IOBluetoothUI.h>

@interface RKRobotProviderMac : RKRobotProvider {
    NSMutableArray* robotControls;
    IOBluetoothUserNotification* disconnectNotification;
}

-(BOOL)controlRobotAtIndex:(NSUInteger)index;

@end
