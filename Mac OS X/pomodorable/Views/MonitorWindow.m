//
//  MonitorWindow.m
//  pomodorable
//
//  Created by Kyle Kinkade on 12/16/11.
//  Copyright (c) 2011 Monocle Society LLC  All rights reserved.
//

#import "MonitorWindow.h"

@implementation MonitorWindow

- (void)awakeFromNib
{
    [super awakeFromNib];
}

//- (void)initializeClickThrough
//{
//    CGEnableEventStateCombining(TRUE);
//    // Don't let our events block local hardware events
//    CGSetLocalEventsFilterDuringSupressionState(kCGEventFilterMaskPermitAllEvents,kCGEventSupressionStateSupressionInterval);
//    CGSetLocalEventsFilterDuringSupressionState(kCGEventFilterMaskPermitAllEvents,kCGEventSupressionStateRemoteMouseDrag);
//}
//
//- (void) sendEvent: (NSEvent *) anEvent
//{
//    switch ([anEvent type]) 
//    {
//        case NSLeftMouseDown: 
//        {
//            // Enable click-through window
//            [self setIgnoresMouseEvents:TRUE];
//            // Initialize click-through
//            [self initializeClickThrough];
//            // We are now in click-through state until left mouse button is released
//            // Re-post left mouse-down event
//            CGPostMouseEvent(mouseLoc, FALSE, 1,TRUE);
//            break;
//        }
//        case NSLeftMouseUp: 
//        {
//            // Re-post left mouse-up event
//            CGPostMouseEvent(mouseLocCG, FALSE, 1,FALSE);
//            // Disable click-through windows (runs [self setIgnoresMouseEvents:FALSE] asynchronously)
//            [self performSelector: @selector(disableIgnoreMouseEvents) withObject:NULL afterDelay: 0.1];
//        }
//    }
//}

@end
