//
//  FsprgOrderDocumentRepresentation.h
//  FsprgEmbeddedStore
//
//  Created by Lars Steiger on 2/12/10.
//  Copyright 2010 FastSpring. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "FsprgOrder.h"


/*!
 * WebDocumentRepresentation that calls FsprgEmbeddedStoreDelegate on receiving the order.
 */
@interface FsprgOrderDocumentRepresentation : NSObject <WebDocumentRepresentation> {
	FsprgOrder *order;
}

- (FsprgOrder *)order;
- (void)setOrder:(FsprgOrder *)anOrder;

@end
