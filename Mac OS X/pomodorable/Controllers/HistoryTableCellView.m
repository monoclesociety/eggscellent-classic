//
//  HistoryTableCellView.m
//  Eggscellent
//
//  Created by Kyle kinkade on 4/13/13.
//  Copyright (c) 2013 Monocle Society LLC. All rights reserved.
//

#import "HistoryTableCellView.h"

@implementation HistoryTableCellView

- (IBAction)toggleCompleteActivity:(id)sender
{
    Activity *a = (Activity *)self.objectValue;
    BOOL completed = (a.completed);
    
    NSDate *completedDate = completed ? nil : [NSDate date];
    a.completed = completedDate;
    [a save];
    
    if(a == [Activity currentActivity] && [EggTimer currentTimer].status == TimerStatusRunning)
    {
        [[EggTimer currentTimer] stop];
    }
}

@end
