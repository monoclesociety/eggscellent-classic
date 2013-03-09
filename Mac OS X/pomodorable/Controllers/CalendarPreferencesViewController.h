//
//  CalendarPreferencesViewController.h
//  pomodorable
//
//  Created by Kyle kinkade on 3/2/13.
//  Copyright (c) 2013 Monocle Society LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MASPreferencesViewController.h"
#import "CalendarController.h"

@interface CalendarPreferencesViewController : NSViewController <MASPreferencesViewController>
@property (weak) CalendarController *calendarController;
@property (strong) IBOutlet NSPopUpButton* sourcesPopUpButton;
@property (nonatomic, unsafe_unretained) NSWindow *window;
@end
