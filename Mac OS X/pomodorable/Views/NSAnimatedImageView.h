//
//  NSAnimatedImageView.h
//  pomodorable
//
//  Created by Kyle kinkade on 2/19/13.
//  Copyright (c) 2013 Monocle Society LLC. All rights reserved.
//
#import <Cocoa/Cocoa.h>

@protocol NSAnimatedImageViewDelegate <NSObject>

- (void)animationEnded;

@end

@interface NSAnimatedImageView : NSView
{
    NSMutableArray *frames;
    int lastFrame;
    
    CVDisplayLinkRef displayLink;
    id <NSAnimatedImageViewDelegate> delegate;
}
@property (strong) id <NSAnimatedImageViewDelegate> delegate;
@property (readonly) BOOL isPlaying;
@property (strong) NSArray *frames;
@property (nonatomic) double frameRate;
@property (nonatomic) int animationTag;

- (void)start;
- (void)pause;
- (void)resume;
- (void)stop;

@end