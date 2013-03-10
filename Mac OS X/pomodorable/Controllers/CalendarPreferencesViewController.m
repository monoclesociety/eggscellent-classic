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
@property (strong) NSArray *sources;
@end

@implementation CalendarPreferencesViewController
@synthesize sourcesPopUpButton = _sourcesPopUpButton;
@synthesize sources = _sources;
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

- (void)awakeFromNib
{
    [self populateCalendarSourceList];
}

#pragma mark - IBActions

- (IBAction)changeSource:(id)sender
{
    NSInteger index = _sourcesPopUpButton.indexOfSelectedItem;
    EKSource *source = [_sources objectAtIndex:index];
    
    calendarController.calendarSource = source;
}

#pragma mark - NSPopUpButton

- (void)populateCalendarSourceList
{
    [_sourcesPopUpButton removeAllItems];
    
    //first populate the list
    EKSource *iCloud = nil;
    _sources = [calendarController supportedCalendarSources];
    for(EKSource *source in _sources)
    {
        if(source.sourceType == EKSourceTypeCalDAV && [source.title isEqualToString:@"iCloud"])
        {
            iCloud = source;
        }
        [_sourcesPopUpButton addItemWithTitle:source.title];
    }
    
    //set selected source
    EKSource *selectedSource = calendarController.calendarSource;
    if(selectedSource == nil && iCloud != nil)
    {
        selectedSource = calendarController.calendarSource = iCloud;
    }
    [_sourcesPopUpButton selectItemWithTitle:selectedSource.title];
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
