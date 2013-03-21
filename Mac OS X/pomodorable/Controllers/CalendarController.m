//
//  CalendarController.m
//  pomodorable
//
//  Created by Kyle kinkade on 3/1/13.
//  Copyright (c) 2013 Monocle Society LLC. All rights reserved.
//


#import "CalendarController.h"
#import "Egg.h"
#import "EggTimer.h"

@implementation CalendarController
@synthesize calendarStore = _calendarStore;
@synthesize calendarSource = _calendarSource;
@synthesize eggscellentCalendar = _eggscellentCalendar;

- (id)init
{
    if(self = [super init])
    {
        _calendarStore = [[EKEventStore alloc] initWithAccessToEntityTypes:EKEntityMaskEvent];
    }
    return self;
}

- (BOOL)createCalendarLogForEgg:(Egg *)egg
{
    EKEvent *logEvent = [EKEvent eventWithEventStore:_calendarStore];
    logEvent.calendar = [self eggscellentCalendar];
    
    //set up start and end date.
    NSDate *startDate = egg.created;
    NSDate *endDate = [startDate dateByAddingTimeInterval:[egg.timeEstimated integerValue]];
    logEvent.startDate = startDate;
    logEvent.endDate = endDate;

    //(0 of 2) - Create a brand new feature that will log all completed timers in a calendar.
    NSString *titleFormat = NSLocalizedString(@"(%d of %d) - %@", @"(x of x) - Title");
    logEvent.title = [NSString stringWithFormat:titleFormat,
                                                [egg.activity.completedEggs count],
                                                [egg.activity.plannedCount intValue],
                                                 egg.activity.name, nil];
    
    logEvent.allDay = NO;
    
    NSError *error = nil;
    [_calendarStore saveEvent:logEvent span:EKSpanThisEvent commit:YES error:&error];
    return (error == nil);
}

#pragma mark - EventKit Stack

- (NSArray *)supportedCalendarSources;
{
    NSMutableArray *sources = [NSMutableArray array];
    for (EKSource* source in _calendarStore.sources)
    {
        if(source.sourceType != EKSourceTypeBirthdays)
        {
            [sources addObject:source];
        }
    }
    return sources;
}
 
- (EKSource *)calendarSource
{
    if(_calendarSource)
        return _calendarSource;
    
    NSString *sourceIdentifier = [[NSUserDefaults standardUserDefaults] stringForKey:@"calendarSourceIdentifier"];
    if(sourceIdentifier)
    {
        _calendarSource = [_calendarStore sourceWithIdentifier:sourceIdentifier];
    }
    
    return _calendarSource;
}

- (void)setCalendarSource:(EKSource *)calendarSource
{
    _calendarSource = calendarSource;
    NSString *sourceIdentifier = _calendarSource.sourceIdentifier;
    [[NSUserDefaults standardUserDefaults] setObject:sourceIdentifier forKey:@"calendarSourceIdentifier"];
    
    _eggscellentCalendar = nil;
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"eggscellentCalendarIdentifier"];
}

- (EKCalendar *)eggscellentCalendar
{
    if(_eggscellentCalendar)
        return _eggscellentCalendar;
    
    NSString *calendarIdentifier = [[NSUserDefaults standardUserDefaults] stringForKey:@"eggscellentCalendarIdentifier"];
    if(!calendarIdentifier)
    {
        EKSource *eggSource = [self calendarSource];
        
        EKCalendar *cal = nil;
        NSSet *calendars = [eggSource calendarsForEntityType:EKEntityTypeEvent];
        for(EKCalendar *calendar in calendars)
        {
            if([calendar.title isEqualToString:@"Eggscellent"])
            {
                cal = calendar;
            }
        }
        
        if(!cal)
        {
            cal = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:_calendarStore];
            cal.source = eggSource;
            cal.title = @"Eggscellent";
            NSError *error = nil;
            [_calendarStore saveCalendar:cal commit:YES error:&error];
        }
        _eggscellentCalendar = cal;
        
        [[NSUserDefaults standardUserDefaults] setValue:_eggscellentCalendar.calendarIdentifier forKey:@"eggscellentCalendarIdentifier"];
    }
    else
    {
        _eggscellentCalendar = [_calendarStore calendarWithIdentifier:calendarIdentifier];
    }
    
    return _eggscellentCalendar;
}

@end
