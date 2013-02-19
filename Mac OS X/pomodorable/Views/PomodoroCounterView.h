//
//  PomodoroCounterView.h
//  pomodorable
//
//  Created by Kyle Kinkade on 11/12/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PomodoroCounterView : NSView
{
    NSImage     *unfilledPomodoroImage;
    
    NSNumber    *plannedCount;
}
@property (nonatomic, strong) NSImage   *unfilledPomodoroImage;
@property (nonatomic, strong) NSNumber  *plannedCount;

@end