//
//  FsprgEmbeddedStoreController.h
//  FsprgEmbeddedStore
//
//  Created by Lars Steiger on 2/12/10.
//  Copyright 2010 FastSpring. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "FsprgEmbeddedStoreDelegate.h"


/*!
 * Controller for FastSpring's embedded store.
 */
@interface FsprgEmbeddedStoreController : NSObject {
    WebView* webView;
    id <FsprgEmbeddedStoreDelegate> delegate;
    NSString *storeHost;
    NSMutableDictionary *hostCertificates;
    NSMapTable *connectionsToRequests;
}

- (WebView *)webView;
/*!
 * Connects this controller to a web view.
 * @param aWebView Web view to connect.
 */
- (void)setWebView:(WebView *)aWebView;

- (id <FsprgEmbeddedStoreDelegate>)delegate;
/*!
 * Sets a delegate to which it has a weak reference.
 * @param aDelegate Delegate to set.
 */
- (void)setDelegate:(id <FsprgEmbeddedStoreDelegate>)aDelegate;

/*!
 * Loads the store using the given parameters.
 * @param parameters Parameters that get passed to the store.
 */
- (void)loadWithParameters:(FsprgStoreParameters *)parameters;

/*!
 * Loads the store with content of a file (XML plist). Useful to develop and test the order confirmation view. You can create that plist file by using the bundeled TestApp.app.
 * @param aPath File path.
 */
- (void)loadWithContentsOfFile:(NSString *)aPath;

/*!
 * Useful to trigger e.g. the hidden flag of a progress bar.
 * @result TRUE if loading a page.
 */
- (BOOL)isLoading;

/*!
 * Useful to provide the value for a progress bar.
 * @result The loading progress in percent of a page (0 - 100)
 */
- (double)estimatedLoadingProgress;

/**
 * Useful to show a secure icon.
 * @result TRUE if connection is secure (SSL)
 */
- (BOOL)isSecure;

/**
 *
 * @result NSArray containing SecCertificateRef objects for the host of the main frame, if it was loaded via https.
 */
- (NSArray *)securityCertificates;

/*!
 * Host that delivers the store (e.g. sites.fastspring.com).
 * @result <code>nil</code> until the store has been loaded.
 */
- (NSString *)storeHost;

@end