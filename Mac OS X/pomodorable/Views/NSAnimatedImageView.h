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
    
    
    float minFrameInterval;
    CFTimeInterval lastFrame;
    CVDisplayLinkRef displayLink;
}
@end