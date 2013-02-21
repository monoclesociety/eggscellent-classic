//
//  NSAnimatedImageView.m
//  pomodorable
//
//  Created by Kyle kinkade on 2/19/13.
//  Copyright (c) 2013 Monocle Society LLC. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "NSAnimatedImageView.h"

@implementation NSAnimatedImageView

- (void)awakeFromNib
{
    NSLog(@"SHIIIIIII--");
    minFrameInterval = 1.0/30; //30fps default
    
    // TODO: move this to start method or something.
    // Create a display link capable of being used with all active displays
    CVDisplayLinkCreateWithActiveCGDisplays(&displayLink);
    
    // Set the renderer output callback function
    CVDisplayLinkSetOutputCallback(displayLink, MyDisplayLinkCallback, (__bridge void *)self);
    CVDisplayLinkStart(displayLink);
}

static CVReturn MyDisplayLinkCallback (CVDisplayLinkRef displayLink,
                                const CVTimeStamp *inNow,
                                const CVTimeStamp *inOutputTime,
                                CVOptionFlags flagsIn,
                                CVOptionFlags *flagsOut,
                                void *displayLinkContext)
{
    CVReturn error = [(__bridge NSAnimatedImageView *)displayLinkContext getFrameForTime:*inOutputTime];
    return error;
}


CVTimeStamp oldTime;
- (CVReturn)getFrameForTime:(CVTimeStamp)outputTime
{
    //double timeStampDelta = outputTime.hostTime - oldTime.hostTime;
    uint64_t oht = oldTime.hostTime;
    uint64_t pht = outputTime.hostTime;
    
    double timeStampDelta = pht - oht;
    timeStampDelta = timeStampDelta / NSEC_PER_SEC;
    
    if (fabsf( timeStampDelta ) > minFrameInterval)
    {
        [self frameWithDuration:timeStampDelta];
        oldTime = outputTime;
    }
    else
    {
        
    }

    return kCVReturnSuccess;
}

- (void)frameWithDuration:(float)dt
{
    
}

- (void)dealloc
{
    CVDisplayLinkRelease(displayLink);
}

@end
