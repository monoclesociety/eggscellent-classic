//
//  IntegrationPreferencesViewController.h
//  pomodorable
//
//  Created by Kyle Kinkade on 11/22/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MASPreferencesViewController.h"

@interface IntegrationPreferencesViewController : NSViewController <MASPreferencesViewController>
{
    IBOutlet NSPopUpButton  *taskSyncIntegration;
    IBOutlet NSTextField    *taskLearnMore;
    IBOutlet NSTextField    *taskAwayMessage;
}
@property (nonatomic, weak) NSWindow *window;

- (IBAction)taskSyncChanged:(id)sender;

@end
