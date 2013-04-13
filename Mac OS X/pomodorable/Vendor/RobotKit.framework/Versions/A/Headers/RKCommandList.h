/*
 *  RKCommandList.h
 *  RobotKit
 *
 *  Created by Brian Smith on 5/27/11.
 *  Copyright 2011 Orbotix Inc. All rights reserved.
 *
 */

//PRIVATE: DON'T EXPORT HEADER INTO PUBLIC SDK

// commands that go with the core device id(0)
enum _RKCoreCommands {
	RKCoreCommandPing                           = 0x01,
	RKCoreCommandVersioning                     = 0x02,
    RKCoreCommandSetBluetoothName               = 0x10,
    RKCoreCommandGetBluetoothInfo               = 0x11,
    RKCoreCommandSetAutoReconnect               = 0x12,
    RKCoreCommandGetAutoReconnect               = 0x13,
    RKCoreCommandGetPowerState                  = 0x20,
    RKCoreCommandSetPowerNotification           = 0x21,
    RKCoreCommandGoToSleep                      = 0x22,
    RKCoreCommandSetInactivityTimeout           = 0x25,
    RKCoreCommandJumpToBootloader               = 0x30,
    RKCoreCommandLevel1Diagnostic               = 0x40,
    RKCoreCommandAssignTimeValue                = 0x50,
    RKCoreCommandPollPacketTimes                = 0x51
};

// commands that go with the bootloader device id(1)
enum _RKBootloaderCommands {
    RKBootloaderCommandJumpToMain               = 0x04
};

// commands that go with the sphero device id(2)
enum _RKSpheroCommands {
    RKSpheroCommandCalibrate                    = 0x01,
    RKSpheroCommandStabilization                = 0x02,
    RKSpheroCommandRotationRate                 = 0x03,
    RKSpheroCommandSelfLevel                    = 0x09,
    RKSpheroCommandSetDataStreaming             = 0x11,
    RKSpheroCommandConfigureCollisionDetection  = 0x12,
    RKSpheroCommandConfigureLocator             = 0x13,
    RKSpheroCommandRGBLEDOutput                 = 0x20,
    RKSpheroCommandBackLEDOutput                = 0x21,
    RKSpheroCommandGetUserRGBLEDColor           = 0x22,
    RKSpheroCommandRoll                         = 0x30,
    RKSpheroCommandBoost                        = 0x31,
    RKSpheroCommandRawMotorValues               = 0x33,
    RKSpheroCommandSetMotionTimeout             = 0x34,
    RKSpheroCommandSetOptionFlags               = 0x35,
    RKSpheroCommandGetOptionFlags               = 0x36,
    RKSpheroCommandSetDeviceMode                = 0x42,
    RKSpheroCommandGetDeviceMode                = 0x44,
    RKSpheroCommandRunMacro                     = 0x50,
    RKSpheroCommandSaveTempMacro                = 0x51,
    RKSpheroCommandSaveMacro                    = 0x52,
    RKSpheroCommandSaveTempMacroChunk           = 0x58,
    RKSpheroCommandInitMacroExecutive           = 0x54,
    RKSpheroCommandAbortMacro                   = 0x55,
    RKSpheroCommandGetConfigBlock               = 0x40,
    RKSpheroCommandOrbBasicEraseStorage         = 0x60,
    RKSpheroCommandOrbBasicAppendFragment       = 0x61,
    RKSpheroCommandOrbBasicExecute              = 0x62,
    RKSpheroCommandOrbBasicAbort                = 0x63
};