//
//  HistoryPopOverViewController.h
//  Eggscellent
//
//  Created by Kyle kinkade on 4/25/13.
//  Copyright (c) 2013 Monocle Society LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TaskRibbonView.h"
#import "Activity.h"

@interface HistoryPopOverViewController : NSViewController
{
    BOOL loaded;
}
@property (nonatomic, weak) Activity                            *activity;
@property (nonatomic, strong) IBOutlet TaskRibbonView           *ribbonView;
@property (nonatomic, strong) IBOutlet NSTextField              *internalDistractions;
@property (nonatomic, strong) IBOutlet NSTextField              *externalDistractions;
@end