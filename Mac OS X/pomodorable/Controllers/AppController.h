//
//  AppController.h
//  Eggscellent
//
//  Created by Wojciech Roszkowiak on 6/11/13.
//  Copyright (c) 2013 Monocle Society LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FsprgEmbeddedStoreController.h"

@protocol AppControllerDelegate

@required
- (void)productPurchasedForName:(NSString *)userName serialNumber:(NSString *)serialNumber;

@end

@interface AppController : NSObject <FsprgEmbeddedStoreDelegate> {
}

@property (strong) FsprgEmbeddedStoreController *storeController;
@property (strong) IBOutlet WebView* storeView;
@property (assign) id<AppControllerDelegate> delegate;

- (IBAction)reloadPage:(id)sender;
- (void)loadStorePage;

@end