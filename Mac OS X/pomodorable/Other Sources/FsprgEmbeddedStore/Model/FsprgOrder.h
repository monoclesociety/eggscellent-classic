//
//  FsprgOrder.h
//  FsprgEmbeddedStore
//
//  Created by Lars Steiger on 2/12/10.
//  Copyright 2010 FastSpring. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FsprgOrderItem.h"


/*!
 * Order information. FsprgOrder is backed by a NSMutableDictionary that
 * can be accessed and modified via the raw and setRaw: methods.
 */
@interface FsprgOrder : NSObject {
	NSDictionary *raw;
}

+ (FsprgOrder *)orderFromData:(NSData *)aData;

- (FsprgOrder *)initWithDictionary:(NSDictionary *)aDictionary;
- (NSDictionary *)raw;
- (void)setRaw:(NSDictionary *)aDictionary;

- (BOOL)orderIsTest;
- (NSString *)orderReference;
- (NSString *)orderLanguage;
- (NSString *)orderCurrency;
- (NSNumber *)orderTotal;
- (NSNumber *)orderTotalUSD;
- (NSString *)customerFirstName;
- (NSString *)customerLastName;
- (NSString *)customerCompany;
- (NSString *)customerEmail;

/*!
 * Shortcut for [[self orderItems] objectAtIndex:0].
 * @result First item.
 */
- (FsprgOrderItem *)firstOrderItem;
- (NSArray *)orderItems;

@end
