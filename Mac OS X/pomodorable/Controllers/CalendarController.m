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
@synthesize eggscellentCalendar = _eggscellentCalendar;
@synthesize eggscellentCalendarSource = _eggscellentCalendarSource;

- (id)init
{
    if(self = [super init])
    {
        _calendarStore = [[EKEventStore alloc] initWithAccessToEntityTypes:EKEntityMaskEvent];
    }
    return self;
}

- (void)start
{
    
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
    NSString *titleFormat = NSLocalizedString(@"(%d of %d) - %@", @"Title - x of x");
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

- (EKSource *)eggscellentCalendarSource
{
    if(_eggscellentCalendar)
        return _eggscellentCalendarSource;
    
    EKSource* localSource = nil;
    NSMutableArray *sources = [NSMutableArray array];
    for (EKSource* source in _calendarStore.sources)
    {
        if(source.sourceType != EKSourceTypeBirthdays)
        {
            [sources addObject:source];
        }
    }
    return localSource;
}

- (EKCalendar *)eggscellentCalendar
{
    if(_eggscellentCalendar)
        return _eggscellentCalendar;
    
    NSString *calendarIdentifier = [[NSUserDefaults standardUserDefaults] stringForKey:@"eggscellentCalendarIdentifier"];
    if(!calendarIdentifier)
    {
        EKSource *eggSource = [self eggscellentCalendarSource];
        _eggscellentCalendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:_calendarStore];
        _eggscellentCalendar.source = eggSource;
        _eggscellentCalendar.title = @"Eggscellent";
        
        NSError *error = nil;
        [_calendarStore saveCalendar:_eggscellentCalendar commit:YES error:&error];
        [[NSUserDefaults standardUserDefaults] setValue:_eggscellentCalendar.calendarIdentifier forKey:@"eggscellentCalendarIdentifier"];
    }
    else
    {
        _eggscellentCalendar = [_calendarStore calendarWithIdentifier:calendarIdentifier];
    }
    
    return _eggscellentCalendar;
}

@end
