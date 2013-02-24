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
@synthesize frameRate = _frameRate;
@synthesize animationTag = _animationTag;
@synthesize delegate = _delegate;

- (void)awakeFromNib
{
    [self setWantsLayer:YES];
    
    frames = [NSMutableArray arrayWithCapacity:168];    
    _frameRate = 1.0/30; //30fps default
    
    // Create a display link capable of being used with all active displays
    CVDisplayLinkCreateWithActiveCGDisplays(&displayLink);
    
    // Set the renderer output callback function
    CVDisplayLinkSetOutputCallback(displayLink, MyDisplayLinkCallback, (__bridge void *)self);
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
    uint64_t oht = oldTime.hostTime;
    uint64_t pht = outputTime.hostTime;
    
    double timeStampDelta = pht - oht;
    timeStampDelta = timeStampDelta / NSEC_PER_SEC;
    
    if (fabsf( timeStampDelta ) > _frameRate)
    {
        [self performSelectorOnMainThread:@selector(frameWithDuration) withObject:nil waitUntilDone:NO];
        oldTime = outputTime;
    }

    return kCVReturnSuccess;
}

- (void)frameWithDuration
{
    int nextFrame = lastFrame + 1;

    if ([frames count] == nextFrame || (!_isPlaying))
    {
        [_delegate animationEnded];
        return;
    }
    
    NSString *s = [frames objectAtIndex:nextFrame];
    NSImage *i = [[NSImage alloc] initWithContentsOfFile:s];
    
    self.layer.contents = (id)i;
    
    lastFrame = nextFrame;
}

#pragma mark - Settings

- (void)setFrameRate:(double)aFrameRate
{
    _frameRate = 1.0 / aFrameRate;
}

#pragma mark - Playback methods

- (void)start;
{
    lastFrame = 0;
    _isPlaying = YES;
    CVDisplayLinkStart(displayLink);
}

- (void)pause;
{
    _isPlaying = NO;
}

- (void)resume;
{
    _isPlaying = YES;
}

- (void)stop;
{
    _isPlaying = NO;
    lastFrame = 0;
    CVDisplayLinkStop(displayLink);
}

@end
