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
@synthesize frames;
@synthesize isPlaying = _isPlaying;

- (void)awakeFromNib
{
    [self setWantsLayer:YES];
    
    frames = [NSMutableArray arrayWithCapacity:168];
    [frames addObjectsFromArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"egg_sequences/10_egg_hatch"]];
    [frames addObjectsFromArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"egg_sequences/11_egg_out"]];
    
    frameRate = 1.0/30; //30fps default
    
    // TODO: move this to start method or something.
    // Create a display link capable of being used with all active displays
    CVDisplayLinkCreateWithActiveCGDisplays(&displayLink);
    
    // Set the renderer output callback function
    CVDisplayLinkSetOutputCallback(displayLink, MyDisplayLinkCallback, (__bridge void *)self);
    
    CVDisplayLinkStart(displayLink);
}

- (void)dealloc
{
    CVDisplayLinkRelease(displayLink);
}

#pragma mark - CVDisplayLink setup

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
    
    if (fabsf( timeStampDelta ) > frameRate)
    {
        [self performSelectorOnMainThread:@selector(frameWithDuration) withObject:nil waitUntilDone:NO];
        oldTime = outputTime;
    }
    else
    {
        
    }

    return kCVReturnSuccess;
}

- (void)drawRect:(NSRect)dirtyRect
{
    int nextFrame = lastFrame + 1;
    
    if ([frames count] == nextFrame)
    {
        nextFrame = 0;
    }
    
    NSString *s = [frames objectAtIndex:nextFrame];
    NSImage *i = [[NSImage alloc] initWithContentsOfFile:s];
    
    self.layer.contents = (id)i;
    
    lastFrame = nextFrame;
}

- (void)frameWithDuration
{
    int nextFrame = lastFrame + 1;
    if ([frames count] == nextFrame)
        [self stop];
    
    NSString *s = [frames objectAtIndex:nextFrame];
    NSImage *i = [[NSImage alloc] initWithContentsOfFile:s];
    
    self.layer.contents = (id)i;
    
    lastFrame = nextFrame;
}

#pragma mark - Settings

- (void)setFrameRate:(double)aFrameRate
{
    frameRate = 1.0 / aFrameRate;
}

#pragma mark - Playback methods

- (void)play;
{
    CVDisplayLinkStart(displayLink);
}

- (void)pause;
{
    CVDisplayLinkStop(displayLink);
}

- (void)stop;
{
    CVDisplayLinkStop(displayLink);
    lastFrame = 0;
}

@end
