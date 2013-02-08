//
//  NoteView.m
//  pomodorable
//
//  Created by Kyle Kinkade on 3/27/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import "NoteView.h"

@implementation NoteView

- (void)drawRect:(NSRect)dirtyRect
{
    //Fill with clear
    [[NSColor clearColor] setFill];
    NSRectFill(dirtyRect);

    // draw rounded rect with background color
    NSBezierPath* roundedRectanglePath = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:6 yRadius:6];
    [self.backgroundColor setFill];
    [roundedRectanglePath fill];
    
    //create gradient on top of window
    NSColor *startColor = [NSColor colorWithDeviceRed:0.988 green:0.984 blue:0.878 alpha:1.000];
    NSColor *endColor = [NSColor colorWithDeviceRed:0.988 green:0.984 blue:0.878 alpha:0.000];
    NSGradient* awesome = [[NSGradient alloc] initWithStartingColor:startColor endingColor:endColor];
    CGRect f = self.bounds;
    f.origin.y = f.size.height - 48;
    f.size.height = 48;
    NSBezierPath* roundedGradientPath = [NSBezierPath bezierPathWithRoundedRect:f xRadius:6 yRadius:6];
    [awesome drawInBezierPath:roundedGradientPath angle:-90];
    
    //create "red" lines
    CGFloat maxY = NSMaxY(self.frame);
    CGContextRef c = (CGContextRef )[[NSGraphicsContext currentContext] graphicsPort];
    CGColorRef black = CGColorCreateGenericRGB(0.949, 0.713, 0.317, 1);
    CGContextSetStrokeColorWithColor(c, black);
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, 0.0f, maxY - 49.0f);
    CGContextAddLineToPoint(c, self.frame.size.width, maxY - 49.0f);
    CGContextSetLineWidth(c, 2);
    CGContextSetLineCap(c, kCGLineCapSquare);
    CGContextClosePath(c);
    CGContextStrokePath(c);
    
    CGContextSetStrokeColorWithColor(c, black);
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, 0.0f, maxY - 51.5f);
    CGContextAddLineToPoint(c, self.frame.size.width, maxY - 51.5f);
    CGContextSetLineWidth(c, 1);
    CGContextSetLineCap(c, kCGLineCapSquare);
    CGContextClosePath(c);
    CGContextStrokePath(c);
    
    CGColorRelease(black);
    
    //stroke entire rounded rectangle with clear
    [[NSColor clearColor] setStroke];
    [roundedRectanglePath setLineWidth:1];
    [roundedRectanglePath stroke];
}

@end