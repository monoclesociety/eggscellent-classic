//
//  GradientView.m
//  pomodorable
//
//  Created by Kyle Kinkade on 3/25/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView
@synthesize topColor;
@synthesize bottomColor;

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    //// Gradient Declarations
    NSGradient* awesome = [[NSGradient alloc] initWithStartingColor:bottomColor endingColor:topColor];
    [awesome drawInRect:self.bounds angle:90];
    
    //// Cleanup
}

@end
