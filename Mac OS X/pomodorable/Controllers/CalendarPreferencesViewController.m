//
//  CalendarPreferencesViewController.m
//  pomodorable
//
//  Created by Kyle kinkade on 3/2/13.
//  Copyright (c) 2013 Monocle Society LLC. All rights reserved.
//
#import <EventKit/EventKit.h>
#import "CalendarPreferencesViewController.h"

@interface CalendarPreferencesViewController ()

@end

@implementation CalendarPreferencesViewController
@synthesize sourcesPopUpButton = _sourcesPopUpButton;
@synthesize calendarController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Initialization code here.
    }
    
    return self;
}

#pragma mark - NSPopUpButton

- (void)populateCalendarSourceList
{
    [_sourcesPopUpButton removeAllItems];
    
    //first populate the list
    EKSource *selected = nil;
    EKSource *iCloud = nil;
    NSArray *sources = [calendarController supportedCalendarSources];
    for(EKSource *source in sources)
    {
        if(source.sourceType == EKSourceTypeCalDAV && [source.title isEqualToString:@"iCloud"])
        {
            [_sourcesPopUpButton addItemWithTitle:source.title];
        }
    }
        
    EKSource *final = (selected == nil) ? iCloud : selected;
    [_sourcesPopUpButton selectItemWithTitle:final.title];

    //might be useful later
//    [popUpButton.menu addItem:[NSMenuItem separatorItem]];
//    [popUpButton addItemWithTitle:@"Choose Sound..."];
}

#pragma mark - MASPreferencesViewController Methods

- (NSString *)identifier
{
    return @"Calendar Preferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:@"calendar"];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Calendar", @"Toolbar item name for the Calendar preference pane");
}

- (CGFloat)initialHeightOfView;
{
    return self.view.frame.size.height;
}

@end
