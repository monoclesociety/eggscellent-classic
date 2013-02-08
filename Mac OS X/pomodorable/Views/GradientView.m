//
//  GradientView.m
//  pomodorable
//
//  Created by Kyle Kinkade on 3/25/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    //// Gradient Declarations 
    NSColor *stickyNoteColor = [NSColor colorWithDeviceRed:0.969 green:0.965 blue:0.702 alpha:1.000];
    NSColor *stickyNoteClearColor = [NSColor colorWithDeviceRed:0.969 green:0.965 blue:0.702 alpha:0.000];
    NSGradient* awesome = [[NSGradient alloc] initWithStartingColor:stickyNoteColor endingColor:stickyNoteClearColor];
    [awesome drawInRect:self.bounds angle:90];
    
    //// Cleanup
}

@end
