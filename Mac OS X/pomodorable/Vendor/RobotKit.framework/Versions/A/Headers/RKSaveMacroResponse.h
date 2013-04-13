//
//  RKSaveMacroResponse.h
//  RobotKit
//
//  Created by Jon Carroll on 10/30/11.
//  Copyright (c) 2011 Orbotix Inc. All rights reserved.
//

/*! @file */

#import <RobotKit/RKDeviceResponse.h>
#if defined (SRCLIBRARY)
#import <RobotKit/Macro/RKSaveTemporaryMacroCommand.h>
#else
#import <RobotKit/RKSaveTemporaryMacroCommand.h>
#endif

/*!
 * @brief Class that encapsulates the response from a save macro command.
 *
 * This is a simple response that can be used to see if an error was returned from a
 * save macro command. For convience, the save macro command's properties are copied 
 * into the response.
 *
 * @sa RKSaveMacroCommand
 */
@interface RKSaveMacroResponse : RKDeviceResponse {
    @private
    RKMacroFlags macroFlags;
    uint8_t      macroID;
}

/*! The flags that where sent in the original command. */
@property (nonatomic, readonly) RKMacroFlags macroFlags;
/*! The macro identifier sent with the original command. */
@property (nonatomic, readonly) uint8_t      macroID;

@end
