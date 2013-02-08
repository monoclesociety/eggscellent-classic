//
//  RoundedBox.m
//  RoundedBox
//
//  Created by Matt Gemmell on 01/11/2005.
//  Copyright 2006 Matt Gemmell. http://mattgemmell.com/
//
//  Permission to use this code:
//
//  Feel free to use this code in your software, either as-is or 
//  in a modified form. Either way, please include a credit in 
//  your software's "About" box or similar, mentioning at least 
//  my name (Matt Gemmell). A link to my site would be nice too.
//
//  Permission to redistribute this code:
//
//  You can redistribute this code, as long as you keep these 
//  comments. You can also redistribute modified versions of the 
//  code, as long as you add comments to say that you've made 
//  modifications (keeping these original comments too).
//
//  If you do use or redistribute this code, an email would be 
//  appreciated, just to let me know that people are finding my 
//  code useful. You can reach me at matt.gemmell@gmail.com
//

#import "RoundedBox.h"

#define MG_TITLE_INSET 3.0


@implementation RoundedBox

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDefaults];
    }
    return self;
}




- (void)setDefaults
{
    [[self titleCell] setLineBreakMode:NSLineBreakByTruncatingTail];
    [[self titleCell] setEditable:YES];
    
    borderWidth = 2.0;
    [self setBorderColor:[NSColor grayColor]];
    [self setBackgroundColor:[NSColor colorWithCalibratedWhite:0.90 alpha:1.0]];
    [self setTitleFont:[NSFont boldSystemFontOfSize:[NSFont systemFontSizeForControlSize:NSSmallControlSize]]];
    
    [self setSelected:NO];
}


- (void)awakeFromNib
{
    // For when we've been created in a nib file
    [self setDefaults];
}


- (BOOL)preservesContentDuringLiveResize
{
    // NSBox returns YES for this, but doing so would screw up the gradients.
    return NO;
}

- (void)drawRect:(NSRect)rect 
{
    if(!selected)
        return;
    // Construct rounded rect path
    NSRect boxRect = [self bounds];
    NSRect bgRect = boxRect;
    bgRect = NSInsetRect(boxRect, borderWidth / 2.0, borderWidth / 2.0);
    bgRect = NSIntegralRect(bgRect);
    bgRect.origin.x += 0.5;
    bgRect.origin.y += 0.5;
    int minX = NSMinX(bgRect);
    int midX = NSMidX(bgRect);
    int maxX = NSMaxX(bgRect);
    int minY = NSMinY(bgRect);
    int midY = NSMidY(bgRect);
    int maxY = NSMaxY(bgRect);
    float radius = 4.0;
    NSBezierPath *bgPath = [NSBezierPath bezierPath];
    
    // Bottom edge and bottom-right curve
    [bgPath moveToPoint:NSMakePoint(midX, minY)];
    [bgPath appendBezierPathWithArcFromPoint:NSMakePoint(maxX, minY) 
                                     toPoint:NSMakePoint(maxX, midY) 
                                      radius:radius];
    
    // Right edge and top-right curve
    [bgPath appendBezierPathWithArcFromPoint:NSMakePoint(maxX, maxY) 
                                     toPoint:NSMakePoint(midX, maxY) 
                                      radius:radius];
    
    // Top edge and top-left curve
    [bgPath appendBezierPathWithArcFromPoint:NSMakePoint(minX, maxY) 
                                     toPoint:NSMakePoint(minX, midY) 
                                      radius:radius];
    
    // Left edge and bottom-left curve
    [bgPath appendBezierPathWithArcFromPoint:NSMakePoint(minX, minY) 
                                     toPoint:NSMakePoint(midX, minY) 
                                      radius:radius];
    [bgPath closePath];
    
    
    // Draw background
    
//    if ([self drawsGradientBackground]) {
//        // Draw gradient background
//        NSGraphicsContext *nsContext = [NSGraphicsContext currentContext];
//        [nsContext saveGraphicsState];
//        [bgPath addClip];
//        CTGradient *gradient = [CTGradient gradientWithBeginningColor:[self gradientStartColor] endingColor:[self gradientEndColor]];
//        NSRect gradientRect = [bgPath bounds];
//        [gradient fillRect:gradientRect angle:270.0];
//        [nsContext restoreGraphicsState];
//    } else 
    {
        // Draw solid color background
        [backgroundColor set];
        [bgPath fill];
    }
    
    // Draw rounded rect around entire box
    [[NSColor whiteColor] set];
    [bgPath setLineWidth:2];
    [bgPath stroke];
}


- (BOOL)selected
{
    return selected;
}


- (void)setSelected:(BOOL)newSelected
{
    selected = newSelected;
    [self setNeedsDisplay:YES];
}


- (NSColor *)borderColor
{
    return borderColor;
}


- (void)setBorderColor:(NSColor *)newBorderColor
{
    borderColor = newBorderColor;
    [self setNeedsDisplay:YES];
}

- (NSColor *)backgroundColor
{
    return backgroundColor;
}


- (void)setBackgroundColor:(NSColor *)newBackgroundColor
{
    backgroundColor = newBackgroundColor;
}
 
@end
