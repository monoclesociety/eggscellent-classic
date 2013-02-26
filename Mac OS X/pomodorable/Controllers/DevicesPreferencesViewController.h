//
//  DevicesPreferencesViewController.h
//  pomodorable
//
//  Created by Kyle Kinkade on 1/31/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MASPreferencesViewController.h"

@interface DevicesPreferencesViewController : NSViewController <MASPreferencesViewController>
{
    NSArrayController *__weak arrayController;
}
@property (nonatomic, weak) IBOutlet NSArrayController *arrayController;
@property (nonatomic, unsafe_unretained) NSWindow *window;

- (IBAction)debugSelected:(id)sender;

@end
