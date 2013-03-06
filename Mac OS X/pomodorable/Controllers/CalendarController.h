//
//  CalendarController.h
//  pomodorable
//
//  Created by Kyle kinkade on 3/1/13.
//  Copyright (c) 2013 Monocle Society LLC. All rights reserved.
//

#import <EventKit/EventKit.h>
@interface CalendarController : NSObject

@property (readonly) EKEventStore *calendarStore;
@property (readonly) EKCalendar *eggscellentCalendar;
@property (readonly) EKSource *eggscellentCalendarSource;

- (BOOL)setCalendarSource:(EKSource *)calendarSource;
- (NSArray *)supportedCalendars;
- (BOOL)createCalendarLogForEgg:(Egg *)egg;

@end