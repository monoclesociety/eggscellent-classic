//
//  RKRobotControl+MacroAdditions.h
//  RobotKit
//
//  Created by Brian Smith on 10/12/11.
//  Copyright (c) 2011 Orbotix Inc. All rights reserved.
//

#import "RKRobotControl.h"

@interface RKRobotControl (MacroAdditions)

- (NSData *)makeBoostColorChangeMacro;
- (NSData *)makeBoostMacro;

@end
