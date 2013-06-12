//
//  FsprgOrderTest.m
//  FsprgEmbeddedStore
//
//  Created by Lars Steiger on 2/24/10.
//  Copyright 2010 FastSpring. All rights reserved.
//

#import "FsprgOrderTest.h"


@implementation FsprgOrderTest

- (void) setUp
{
	NSString *orderFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"complicated" ofType:@"plist"];
	NSData *orderData = [NSData dataWithContentsOfFile:orderFilePath];
	order = [[FsprgOrder orderFromData:orderData] retain];
}

- (void) tearDown
{
    [order release];
}

- (void)testCustomerEmail
{
	STAssertEqualObjects(@"ryan@dewell.org", [order customerEmail], nil);
	STAssertEqualObjects(@"ryan@dewell.org", [order valueForKeyPath:@"customerEmail"], nil);
}

- (void)testProductName
{
	STAssertEqualObjects(@"ABC Book Organizer", [[order firstOrderItem] productName], nil);
	STAssertEqualObjects(@"ABC Book Organizer", [order valueForKeyPath:@"firstOrderItem.productName"], nil);
}

- (void)testLicenseCode
{
	STAssertEqualObjects(@"QEHCDK-375722-EVDEAM-744794-5934", [[[[[order firstOrderItem] fulfillment] valueForKey:@"supportLicense"] licenseCodes] objectAtIndex:0], nil);
	STAssertEqualObjects(@"QEHCDK-375722-EVDEAM-744794-5934", [order valueForKeyPath:@"firstOrderItem.fulfillment.supportLicense.firstLicenseCode"], nil);
	STAssertEquals(1, [[order valueForKeyPath:@"firstOrderItem.fulfillment.supportLicense.licenseCodes.@count"] intValue], nil);
}

- (void)testFileURL
{
	STAssertEqualObjects(@"https://localhost:8443/bm-hosted/demo/order/dl/DM100219-7871-29151/8508",
						 [[[[[order firstOrderItem] fulfillment] valueForKey:@"windows_file"] fileURL] description], nil);
	STAssertEqualObjects(@"https://localhost:8443/bm-hosted/demo/order/dl/DM100219-7871-29151/8508",
						 [[order valueForKeyPath:@"firstOrderItem.fulfillment.windows_file.fileURL"] description], nil);
}

@end
