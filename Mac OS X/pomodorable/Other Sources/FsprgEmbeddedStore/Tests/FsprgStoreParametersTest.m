//
//  FsprgStoreParametersTest.m
//  FsprgEmbeddedStore
//
//  Created by Lars Steiger on 3/1/10.
//  Copyright 2010 FastSpring. All rights reserved.
//

#import "FsprgStoreParametersTest.h"


@implementation FsprgStoreParametersTest

- (void) setUp
{
	params = [[FsprgStoreParameters parameters] retain];
	[params setOrderProcessType:kFsprgOrderProcessDetail];
}

- (void) tearDown
{
    [params release];
}

- (void)testEmpty
{
	STAssertEqualObjects(@"http://sites.fastspring.com//product/", [[params toURL] description], nil);
}

- (void)testNoParam
{
	[params setStoreId:@"storeId" withProductId:@"productId"];
	
	STAssertEqualObjects(@"http://sites.fastspring.com/storeId/product/productId", [[params toURL] description], nil);
}

- (void)testOneParam
{
	[params setStoreId:@"storeId" withProductId:@"productId"];
	[params setMode:kFsprgModeTest];
	
	STAssertEqualObjects(@"http://sites.fastspring.com/storeId/product/productId?mode=test", [[params toURL] description], nil);
}

- (void)testTwoParams
{
	[params setStoreId:@"storeId" withProductId:@"productId"];
	[params setMode:kFsprgModeTest];
	[params setCampaign:@"aCampaign"];
	
	STAssertEqualObjects(@"http://sites.fastspring.com/storeId/product/productId?campaign=aCampaign&mode=test", [[params toURL] description], nil);
}

- (void)testAllParams
{
	[params setLanguage:@"aLanguage"];
	[params setStoreId:@"storeId" withProductId:@"productId"];
	[params setMode:kFsprgModeTest];
	[params setCampaign:@"aCampaign"];
	[params setOption:@"anOption"];
	[params setReferrer:@"aReferrer"];
	[params setSource:@"aSource"];
	
	STAssertEqualObjects(@"http://sites.fastspring.com/storeId/product/productId?campaign=aCampaign&language=aLanguage&mode=test&option=anOption&referrer=aReferrer&source=aSource",
						 [[params toURL] description], nil);
}

- (void)testSpecialChars
{
	[params setStoreId:@"ä" withProductId:@"ö"];
	[params setCampaign:@"ü"];
	[params setOption:@">"];
	[params setReferrer:@"<"];
	[params setSource:@"%"];
	
	STAssertEqualObjects(@"http://sites.fastspring.com/%C3%A4/product/%C3%B6?campaign=%C3%BC&option=%3E&referrer=%3C&source=%25",
						 [[params toURL] description], nil);
}

- (void)testParamViaRaw
{
	[params setStoreId:@"storeId" withProductId:@"productId"];
	[[params raw] setValue:@"aValue" forKey:@"additional"];
	
	STAssertEqualObjects(@"http://sites.fastspring.com/storeId/product/productId?additional=aValue", [[params toURL] description], nil);
}

- (void)testContactDefaults
{
	[params setStoreId:@"storeId" withProductId:@"productId"];
	[params setContactFname:@"fname"];
	[params setContactLname:@"lname"];
	[params setContactEmail:@"email"];
	[params setContactCompany:@"company"];
	[params setContactPhone:@"phone"];

	STAssertEqualObjects(@"https://sites.fastspring.com/storeId/product/productId?contact_company=company&contact_email=email&contact_fname=fname&contact_lname=lname&contact_phone=phone", [[params toURL] description], nil);
}

- (void)testInstantOrderProcess
{
	[params setOrderProcessType:kFsprgOrderProcessInstant];
	[params setStoreId:@"storeId" withProductId:@"productId"];
	
	STAssertEqualObjects(@"https://sites.fastspring.com/storeId/instant/productId", [[params toURL] description], nil);
}

- (void)testUnknownOrderProcess
{
	[params setOrderProcessType:@"foo"];
	[params setStoreId:@"storeId" withProductId:@"productId"];

	STAssertThrows([params toURLRequest], nil);
}

@end
