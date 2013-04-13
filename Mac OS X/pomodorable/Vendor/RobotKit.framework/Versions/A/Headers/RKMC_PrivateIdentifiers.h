//
//  RKMC_PrivateIdentifiers.h
//  RobotKit
//
//  Created by Jon Carroll on 1/17/12.
//  Copyright (c) 2012 Orbotix Inc. All rights reserved.
//

//Macro Command Identifier Constants
#define MAC_END                 0
#define MAC_SET_SD1             1 // assign system delay #1 (16-bits)
#define MAC_SET_SD2             2 // assign system delay #2 (16-bits)
#define MAC_STABILIZATION       3 // true/false (byte)
#define MAC_CALIBRATE           4 // heading (two bytes)
#define MAC_ROLL                5 // speed (byte), heading (two bytes)
#define MAC_ROLL_SD1            6 // roll, apply system delay #1
#define MAC_RGB                 7 // red (byte), green (byte), blue (byte)
#define MAC_RGB_SD2             8
#define MAC_FRONTLED            9 // intensity (byte)
#define MAC_MOTORRAW            10
#define MAC_DELAY               11 // # milliseconds (two bytes) (no delay byte!)
#define MAC_GOTO                12 // macro number (byte) (no delay byte!)
#define MAC_GOSUB               13 // macro number (byte) (no delay byte!)
#define MAC_SLEEPNOW            0x0E // with wakeup seconds (0 for infinite) (2 byte delay)
#define MAC_SET_SPD1            15 // assign system speed value #1
#define MAC_SET_SPD2            16 // assign system speed value #2
#define MAC_ROLL_SD1_SPD1       17 // roll with system delay 1, system speed 1
#define MAC_ROLL_SD1_SPD2       18 // roll with system delay 1, system speed 2
#define MAC_SET_ROT_RATE        19 // Assign rotation rate
#define MAC_SLEW                20 //fade color
#define MAC_ROT_OVER_TIME       26
#define MAC_EMIT                0x15
#define MAC_STREAM_END          0x1B
#define MAC_WAITUNTILSTOP       0x19
//Commands >28 require executive 3
#define MAC_ROLL2               29 // Same as roll cmd 5 but with a 2-byte delay
#define MAC_LOOPSTART           30 // Beginning of loop block, 1 byte count
#define MAC_LOOPEND             31 // End of loop block
#define MAC_COMMENT             32 // Followed by 4-byte len and then that many comment chars to skip over
#define MAC_ROT_OVER_TIME_SD1   33 // Rotate over time using SD1
#define MAC_ROT_OVER_TIME_SD2   34 // Rotate over time using SD2

//Macro Command Length Constants
#define MAC_ROLL_LEN                5
#define MAC_RGB_LEN                 5
#define MAC_CALIBRATE_LEN           4
#define MAC_DELAY_LEN               3
#define MAC_SLEW_LEN                6
#define MAC_FRONTLED_LEN            3
#define MAC_SET_ROT_RATE_LEN        2
#define MAC_ROT_OVER_TIME_LEN       5
#define MAC_MOTORRAW_LEN            6
#define MAC_STABILIZATION_LEN       3
#define MAC_EMIT_LEN                2
#define MAC_SD1_LEN                 3
#define MAC_SD2_LEN                 3
#define MAC_SPD1_LEN                2
#define MAC_SPD2_LEN                2
#define MAC_ROLL_SD1_LEN            4
#define MAC_ROLL_SD1_SPD1_LEN       3
#define MAC_ROLL_SD1_SPD2_LEN       3
#define MAC_RGB_SD2_LEN             4
#define MAC_EMIT_LEN                2
#define MAC_STREAMEND_LEN           1
#define MAC_WAITUNTILSTOP_LEN       3
#define MAC_GOTO_LEN                2
#define MAC_ROLL2_LEN               6
#define MAC_LOOPSTART_LEN           2
#define MAC_LOOPEND_LEN             1
#define MAC_ROT_OVER_TIME_SD_LEN    3
