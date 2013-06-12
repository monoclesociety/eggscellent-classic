//
//  FsprgOrderDocumentRepresentation.m
//  FsprgEmbeddedStore
//
//  Created by Lars Steiger on 2/12/10.
//  Copyright 2010 FastSpring. All rights reserved.
//

#import "FsprgOrderDocumentRepresentation.h"
#import "FsprgEmbeddedStoreController.h"


@implementation FsprgOrderDocumentRepresentation

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self setOrder:nil];
	}
	return self;
}

- (FsprgOrder *)order
{
    return [[order retain] autorelease]; 
}

- (void)setOrder:(FsprgOrder *)anOrder
{
    if (order != anOrder) {
        [order release];
        order = [anOrder retain];
    }
}

- (NSString *)title
{
	return @"";
}
- (NSString *)documentSource
{
	return nil;
}
- (BOOL)canProvideDocumentSource
{
	return FALSE;
}

- (void)setDataSource:(WebDataSource *)aDataSource
{
}

- (void)receivedData:(NSData *)aData withDataSource:(WebDataSource *)aDataSource
{
	[self setOrder:[FsprgOrder orderFromData:aData]];
	FsprgEmbeddedStoreController *delegate = [[[aDataSource webFrame] webView] frameLoadDelegate];
	[[delegate delegate] didReceiveOrder:[self order]];
}

- (void)receivedError:(NSError *)anError withDataSource:(WebDataSource *)aDataSource
{
}

- (void)finishedLoadingWithDataSource:(WebDataSource *)aDataSource
{
}

- (void)dealloc
{
    [self setOrder:nil];
	
    [super dealloc];
}

@end
