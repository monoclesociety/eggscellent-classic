//
//  RemoteClientController.m
//  pomodorable
//
//  Created by Kyle Kinkade on 1/30/12.
//  Copyright (c) 2012 Monocle Society LLC  All rights reserved.
//

#import "RemoteClientController.h"

@implementation RemoteClientController
@synthesize listedDevices;

+ (RemoteClientController *)sharedClient
{
    static RemoteClientController *singleton;
    if(!singleton)
        singleton = [[RemoteClientController alloc] init];
    
    return singleton;
}

- (id)init
{
    if(self = [super init])
    {
        listedDevices = [[NSMutableArray alloc] init];

        netServiceBrowser = [[NSNetServiceBrowser alloc] init];
        [netServiceBrowser setDelegate:self];
        [netServiceBrowser searchForServicesOfType:@"_pomodorable._tcp." inDomain:@"local."];
    }
    
    return self;
}


#pragma mark - NSNetServiceBrowser Delegate Methods

- (void)netServiceBrowser:(NSNetServiceBrowser *)sender didNotSearch:(NSDictionary *)errorInfo
{
	NSLog(@"DidNotSearch: %@", errorInfo);
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)sender didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing
{
    NSLog(@"Found remote service: %@", [netService name]);
    
    [self willChangeValueForKey:@"listedDevices"];
	[listedDevices addObject:netService];
    [self didChangeValueForKey:@"listedDevices"];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)sender didRemoveService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing
{
	NSLog(@"DidRemoveService: %@", [netService name]);
    
    NSNetService *deleteme = nil;
    for(NSNetService *ns in listedDevices)
    {
        if([ns.name isEqualToString:[netService name]])
        {
            deleteme = ns;
        }
    }
    
    [self willChangeValueForKey:@"listedDevices"];
    [listedDevices removeObject:deleteme];
    [self didChangeValueForKey:@"listedDevices"];
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)sender
{
//	NSLog(@"DidStopSearch");
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
	NSLog(@"DidNotResolve");
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
	NSLog(@"DidResolve: %@", [sender addresses]);
	
	if (serverAddresses == nil)
	{
		serverAddresses = [[sender addresses] mutableCopy];
	}
	
	if (asyncSocket == nil)
	{
		asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
	}
}

- (void)connectToNextAddress
{
	BOOL done = NO;
	
	while (!done && ([serverAddresses count] > 0))
	{
		NSData *addr;
		
		// Note: The serverAddresses array probably contains both IPv4 and IPv6 addresses.
		// 
		// If your server is also using GCDAsyncSocket then you don't have to worry about it,
		// as the socket automatically handles both protocols for you transparently.
		
		if (YES) // Iterate forwards
		{
			addr = [serverAddresses objectAtIndex:0];
			[serverAddresses removeObjectAtIndex:0];
		}
		else // Iterate backwards
		{
			addr = [serverAddresses lastObject];
			[serverAddresses removeLastObject];
		}
		
		NSLog(@"Attempting connection to %@", addr);
		
		NSError *err = nil;
		if ([asyncSocket connectToAddress:addr error:&err])
		{
			done = YES;
		}
		else
		{
			NSLog(@"Unable to connect: %@", err);
		}
		
	}
	
	if (!done)
	{
		NSLog(@"Unable to connect to any resolved address");
	}
}

#pragma mark - GCDAsyncSocket Delegate Methods

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	NSLog(@"Socket:DidConnectToHost: %@ Port: %hu", host, port);
    
    [asyncSocket writeData:[@"awesome!" dataUsingEncoding:NSASCIIStringEncoding] withTimeout:1000 tag:1];
	connected = YES;
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
	NSLog(@"SocketDidDisconnect:WithError: %@", err);
	
	if (!connected)
	{
		[self connectToNextAddress];
	}
}

@end