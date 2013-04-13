//
//  RKDeviceSession.h
//  RobotKit
//
//  Copyright 2010 Orbotix Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKDeviceConnection;
@class RKDeviceCommand;

typedef enum _ReceivedPacketType {
    ReceivedPacketCommandResponse,
    ReceivedPacketAsyncData
} ReceivedPacketType;

typedef enum _PreambleParserState {
    PreambleStateStartOfPacket1,
    PreambleStateStartOfPacket2, 
    PreambleStateParsingBody
} PreambleParserState;

typedef enum _ResponseParserState {
    ResponseStateCode,
    ResponseStateSequenceNumber,
    ResponseStateDataLength,
    ResponseStateData,
    ResponseStateChecksum
} ResponseParserState;

typedef enum _AsyncParserState {
    AsyncStateDataCode,
    AsyncStateDataLengthMSB,
    AsyncStateDataLengthLSB,
    AsyncStateData,
    AsyncStateChecksum
} AsyncParserState;


/*! Private class for RKDeviceConnection */
@interface RKDeviceSession : NSObject {
    RKDeviceConnection  *device;
    NSThread            *communicationThread;
    
    NSMutableDictionary *packetBins;
    NSString            *binLockObject;
    
    BOOL                sending;
    NSMutableDictionary *sentQueue;
    NSTimer             *sentQueueCleanUpTimer;
    
    NSUInteger          bytesSent; 
    
    NSUInteger          packetsSent;
    NSUInteger          packetsReceived;
    NSUInteger          packetsOutOfSequence;
    NSUInteger          packetsDropped;
    
    NSData              *writeData;
    NSTimeInterval      lastWrite;
    NSTimer             *writeTimer;
    
    ReceivedPacketType  packetType;
    PreambleParserState preambleState;
    
    struct {
        ResponseParserState state;
        id                  sentData;
        NSDate              *sentTimeStamp;
        uint8_t             responseCode;
        uint8_t             sequenceNumber;
        NSUInteger          dataLength;
        NSUInteger          dataParsed;
        NSMutableData       *data;
        uint8_t             checksum;   
    } responseParser;    
    
    struct {
        AsyncParserState    state;
        uint8_t             code;
        NSUInteger          dataLength;
        NSUInteger          dataParsed;
        NSMutableData       *data;
        uint8_t             checksum;
    } asyncParser;
    
    pthread_mutex_t     openMutex;
    pthread_cond_t      openCondition;
    BOOL                openFinished;
    pthread_mutex_t     closeMutex;
    pthread_cond_t      closeCondition;
    BOOL                closeFinished;
    BOOL                closing;
    
    CFRunLoopRef        runLoop;
    CFRunLoopSourceRef  sendRunLoopSource;
    CFRunLoopSourceRef  exitRunLoopSource;
}

@property (nonatomic, readonly) NSUInteger packetsSent;
@property (nonatomic, readonly) NSUInteger packetsReceived;

- (id)initWithDevice:(RKDeviceConnection *)aDevice;

- (BOOL)open;
- (void)close;

- (void)queueCommand:(RKDeviceCommand *)command;

@end

#pragma mark -
#pragma mark String Constants
// keys for response dictionary
extern NSString * const RKResponseSentDataKey;
extern NSString * const RKResponseCodeKey;
extern NSString * const RKResponseSequenceNumberKey;
extern NSString * const RKResponseDataKey;
extern NSString * const RKResponseTimeKey;
