//
//  ColorView.m
//  pomodorable
//
//  Created by Kyle Kinkade on 12/22/11.
//  Copyright (c) 2011 Monocle Society LLC  All rights reserved.
//

#import "ColorView.h"

@implementation ColorView
@synthesize backgroundColor;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        
    }
    return self;
}  
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        // Initialization code here.
        self.backgroundColor = [NSColor clearColor];
    }
    
    return self;
}


- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    [backgroundColor setFill];
    NSRectFill(dirtyRect);
}

-(NSColor *)colorForPoint:(NSPoint)point
{
    NSColor *pixelColor;
    [self lockFocus];  // NSReadPixel pulls data out of the current focused graphics context, so -lockFocus is necessary here.
    pixelColor = NSReadPixel(point);
    [self unlockFocus];
    
    return pixelColor;
}


    





@end
