//
//  RemoteController.m
//  pomodorable
//
//  Created by Kyle Kinkade on 12/11/11.
//  Copyright (c) 2011 Monocle Society LLC. All rights reserved.
//
// You can optionally add TXT record stuff
//
//NSMutableDictionary *txtDict = [NSMutableDictionary dictionaryWithCapacity:2];
//
//[txtDict setObject:@"moo" forKey:@"cow"];
//[txtDict setObject:@"quack" forKey:@"duck"];
//
//NSData *txtData = [NSNetService dataFromTXTRecordDictionary:txtDict];
//[netService setTXTRecordData:txtData];

#import "RemoteServerController.h"

@implementation RemoteServerController
@synthesize running;
@synthesize paired;

- (id)init
{
    if(self = [super init])
    {
        
    }
    return self;
}

#pragma mark - Server Methods

- (BOOL)start
{
    if(asyncSocket)
        return NO;
    
    asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];  
    connectedSockets = [[NSMutableArray alloc] init];
    
    NSError *err = nil;
    if ([asyncSocket acceptOnPort:0 error:&err])
    {
        UInt16 port = [asyncSocket localPort];
        netService = [[NSNetService alloc] initWithDomain:@"local."
                                                     type:@"_pomodorable._tcp."
                                                     name:@""
                                                     port:port];
        
        [netService setDelegate:self];
        [netService publish];
    }
    else
    {
        NSLog(@"Error in acceptOnPort:error: -> %@", err);
        return NO;
    }
    
    return YES;
}

- (void)stop
{
    //stop publishing service
    //disconnect
    [self disconnect];
}

- (void)disconnect
{
    //disconnect service
}

#pragma mark - AsyncSocket Delegate methods

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
	NSLog(@"Accepted new socket from %@:%hu", [newSocket connectedHost], [newSocket connectedPort]);
	
	// The newSocket automatically inherits its delegate & delegateQueue from its parent.
    [newSocket readDataWithTimeout:-1 tag:POMODORO_WELCOME];
	[connectedSockets addObject:newSocket];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
	[connectedSockets removeObject:sock];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    switch(tag)
    {
        case POMODORO_WELCOME:
        break;
    }
    NSLog(@"got tag: %d", (int)tag);
}

#pragma mark - NSNetService Delegate Methods

- (void)netServiceDidPublish:(NSNetService *)ns
{
	NSLog(@"Bonjour Service Published: domain(%@) type(%@) name(%@) port(%i)",
			  [ns domain], [ns type], [ns name], (int)[ns port]);
}

- (void)netService:(NSNetService *)ns didNotPublish:(NSDictionary *)errorDict
{
	// Override me to do something here...
	// 
	// Note: This method in invoked on our bonjour thread.
	
	NSLog(@"Failed to Publish Service: domain(%@) type(%@) name(%@) - %@",
               [ns domain], [ns type], [ns name], errorDict);
}

@end
