//
//  FsprgLicense.m
//  FsprgEmbeddedStore
//
//  Created by Lars Steiger on 2/24/10.
//  Copyright 2010 FastSpring. All rights reserved.
//

#import "FsprgLicense.h"


@implementation FsprgLicense

+ (FsprgLicense *)licenseWithDictionary:(NSDictionary *)aDictionary
{
	return [[[FsprgLicense alloc] initWithDictionary:aDictionary] autorelease];
}

- (FsprgLicense *)initWithDictionary:(NSDictionary *)aDictionary
{
	self = [super init];
	if (self != nil) {
		[self setRaw:aDictionary];
	}
	return self;
}
- (NSDictionary *)raw
{
    return [[raw retain] autorelease]; 
}

- (void)setRaw:(NSDictionary *)aDictionary
{
    if (raw != aDictionary) {
        [raw release];
        raw = [aDictionary retain];
    }
}

- (NSString *)licenseName
{
	return [[self raw] valueForKey:@"LicenseName"];
}

- (NSString *)licenseEmail
{
	return [[self raw] valueForKey:@"LicenseEmail"];
}

- (NSString *)licenseCompany
{
	return [[self raw] valueForKey:@"LicenseCompany"];
}

- (NSString *)firstLicenseCode
{
	return [[self licenseCodes] objectAtIndex:0];
}

- (NSArray *)licenseCodes
{
	return [[self raw] valueForKey:@"LicenseCodes"];
}

- (NSDictionary *)licensePropertyList
{
	return [[self raw] valueForKey:@"LicensePropertyList"];
}

- (NSURL *)licenseURL
{
	return [NSURL URLWithString:[[self raw] valueForKey:@"LicenseURL"]];
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
	// Don't need KVO as data won't change. Prevent having to keep (retain) instance variables.
	return FALSE;
}

- (void)dealloc
{
    [self setRaw:nil];
	
    [super dealloc];
}

@end
