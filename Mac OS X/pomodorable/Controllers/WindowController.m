//
//  WindowController.m
//  pomodorable
//
//  Created by Kyle Kinkade on 5/15/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//
#import "WindowController.h"
#import <objc/runtime.h>

@interface WindowController(ShutUpXcode)
- (float)roundedCornerRadius;
- (void)drawRectOriginal:(NSRect)rect;
- (NSWindow*)window;
@end


@implementation WindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) 
    {
        // Initialization code here.
    }
    
    return self;
}
- (void)windowWillLoad
{
    [super windowWillLoad];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    NSView *v = viewController.view;
    [self.window.contentView addSubview:v];
}

@end
