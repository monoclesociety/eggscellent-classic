//
//  AppController.h
//  Eggscellent
//
//  Created by Wojciech Roszkowiak on 6/11/13.
//  Copyright (c) 2013 Monocle Society LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FsprgEmbeddedStoreController.h"

@interface AppController : NSObject <FsprgEmbeddedStoreDelegate> {
}

@property (strong) FsprgEmbeddedStoreController *storeController;
@property (strong) IBOutlet WebView* storeView;

- (IBAction)load:(id)sender;
- (void)registerApp;

@end