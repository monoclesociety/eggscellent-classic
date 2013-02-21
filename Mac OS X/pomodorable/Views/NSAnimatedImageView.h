//
//  NSAnimatedImageView.h
//  pomodorable
//
//  Created by Kyle kinkade on 2/19/13.
//  Copyright (c) 2013 Monocle Society LLC. All rights reserved.
//
#import <Cocoa/Cocoa.h>

@interface NSAnimatedImageView : NSView
{
    NSMutableArray *frames;
    float frameRate;
    int lastFrame;
    
    CVDisplayLinkRef displayLink;
}
@property (readonly) BOOL isPlaying;
@property (strong) NSArray *frames;

- (void)play;
- (void)pause;
- (void)stop;

@end