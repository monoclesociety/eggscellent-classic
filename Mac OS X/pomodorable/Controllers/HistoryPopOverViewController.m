//
//  HistoryPopOverViewController.m
//  Eggscellent
//
//  Created by Kyle kinkade on 4/25/13.
//  Copyright (c) 2013 Monocle Society LLC. All rights reserved.
//

#import "HistoryPopOverViewController.h"
#import "ColorView.h"

@interface HistoryPopOverViewController ()

@end

@implementation HistoryPopOverViewController
@synthesize activity;
@synthesize ribbonView;
@synthesize internalDistractions;
@synthesize externalDistractions;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//    
//    if(!loaded)
//    {
//
//        loaded = YES;
//    }
//}

- (void)setActivity:(Activity *)newActivity
{
    activity = newActivity;
    ribbonView.plannedPomodoroCount = [newActivity.plannedCount intValue];
    ribbonView.completePomodoroCount = [newActivity.completedEggs count];
    internalDistractions.stringValue = [newActivity.internalInterruptionCount stringValue];
    externalDistractions.stringValue = [newActivity.externalInterruptionCount stringValue];
}

@end
