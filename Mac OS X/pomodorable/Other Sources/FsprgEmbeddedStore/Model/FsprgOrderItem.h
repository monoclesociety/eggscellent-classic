//
//  FsprgOrderItem.h
//  FsprgEmbeddedStore
//
//  Created by Lars Steiger on 2/24/10.
//  Copyright 2010 FastSpring. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FsprgFulfillment.h"
#import "FsprgLicense.h"
#import "FsprgFileDownload.h"


/*!
 * Order item information. FsprgOrderItem is backed by a NSMutableDictionary that
 * can be accessed and modified via the raw and setRaw: methods.
 */
@interface FsprgOrderItem : NSObject {
	NSDictionary *raw;
}

+ (FsprgOrderItem *)itemWithDictionary:(NSDictionary *)aDictionary;

- (FsprgOrderItem *)initWithDictionary:(NSDictionary *)aDictionary;
- (NSDictionary *)raw;
- (void)setRaw:(NSDictionary *)aDictionary;

- (NSString *)productName;
- (NSString *)productDisplay;
- (NSNumber *)quantity;
- (NSNumber *)itemTotal;
- (NSNumber *)itemTotalUSD;

/*!
 * This reference can be used to make calls to FastSpring's Subscription API.
 * See https://support.fastspring.com/entries/236487-api-subscriptions
 */
- (NSString *)subscriptionReference;

/*!
 * This URL can be presented to the customer to manage their subscription.
 */
- (NSURL *)subscriptionCustomerURL;

- (FsprgFulfillment *)fulfillment;

/*!
 * Shortcut for [[self fulfillment] valueForKey:@"license"].
 * @result License information.
 */
- (FsprgLicense *)license;

/*!
 * Shortcut for [[self fulfillment] valueForKey:@"download"].
 * @result Download information.
 */
- (FsprgFileDownload *)download;

@end
