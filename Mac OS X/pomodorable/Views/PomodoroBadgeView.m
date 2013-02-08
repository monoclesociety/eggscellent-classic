//
//  PomodoroBadgeView.m
//  pomodorable
//
//  Created by Kyle Kinkade on 12/27/11.
//  Copyright (c) 2011 Monocle Society LLC  All rights reserved.
//

#import "PomodoroBadgeView.h"

@implementation PomodoroBadgeView
@synthesize plannedPomodoroCount;
@synthesize completePomodoroCount;
@synthesize completed;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) 
    {
        self.completePomodoroCount = 0;
        self.completePomodoroCount = 0;
    }
    
    return self;
}


- (NSImage *)ribbonForPercentageComplete
{
    float ribbonNumberTag = 1;
    float divisionalSlice = 1.0f / MAX_EGG_COUNT;
    if(self.plannedPomodoroCount)
        ribbonNumberTag = ((float)self.completePomodoroCount / (float)self.plannedPomodoroCount) / divisionalSlice;
    
    ribbonNumberTag = MAX(ribbonNumberTag, 1);
    NSString *imageName = nil;
    if(self.completePomodoroCount > self.plannedPomodoroCount)
    {
        imageName = @"ribbonOverdue";
    }
    else
    {
        //round off 
        int ribbonNumber = ((int)(ribbonNumberTag * 100 + 0.5)) / 100.0;
        imageName = [NSString stringWithFormat:@"ribbon%d", (int)ribbonNumber];
    }
    
    return [NSImage imageNamed:imageName];
}

- (NSDictionary *)attributesForFontName:(NSString *)fontName withSize:(int)fontSize
{
    NSMutableDictionary *stringAttributes = [[NSMutableDictionary alloc] init];
    NSColor *txtColor = [NSColor whiteColor];
    NSFont *txtFont = [NSFont fontWithName:fontName size:fontSize];
    
    if(!txtFont)
    {
        return nil;
    }
    
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowOffset:NSMakeSize(0.0,-1.0)];
    [shadow setShadowBlurRadius:1.0];
    [shadow setShadowColor:[NSColor colorWithDeviceWhite:0.0 alpha:0.7]];
    
    [stringAttributes setObject:txtFont forKey:NSFontAttributeName];
    [stringAttributes setObject:txtColor forKey:NSForegroundColorAttributeName];
    [stringAttributes setObject:shadow forKey:NSShadowAttributeName];
    
    return stringAttributes;
}

- (void)drawRect:(NSRect)dirtyRect
{
    if(!completedCountAttributes)
    {
        completedCountAttributes = [self attributesForFontName:@"Baskerville SemiBold" withSize:24];
        if(!completedCountAttributes)
            completedCountAttributes = [self attributesForFontName:@"Helvetica Bold" withSize:24];
        
        plannedCountAttributes = [self attributesForFontName:@"Baskerville Italic" withSize:13];
        if(!plannedCountAttributes)
            plannedCountAttributes = [self attributesForFontName:@"Helvetica" withSize:13];
    }
    
    CGRect r = self.frame;
    r.origin = CGPointMake(0, 0);
    if(!completed)
    {
        // Draw ribbon color (50 x 52 pixels)
        [[self ribbonForPercentageComplete] drawInRect:r fromRect:r operation:NSCompositeSourceOver fraction:1];

        // Draw completed pomodoro count
        NSString *completedString = [NSString stringWithFormat:@"%d", completePomodoroCount];
        NSMutableAttributedString *completedAttributedString = [[NSMutableAttributedString alloc] initWithString:completedString attributes:completedCountAttributes];
        CGSize s = [completedAttributedString size];
        CGFloat padding = (dirtyRect.size.width - s.width) / 2;
        [completedAttributedString drawAtPoint:NSPointFromCGPoint(CGPointMake(padding, 52 - 27))];
        
        // Draw planned "X of X" count
        NSString *plannedString = [NSString stringWithFormat:@"of %d", plannedPomodoroCount];
        NSMutableAttributedString *plannedAttributedString  = [[NSMutableAttributedString alloc] initWithString:plannedString  attributes:plannedCountAttributes];
        padding = 15;
        [plannedAttributedString drawAtPoint:NSPointFromCGPoint(CGPointMake(padding, 52 - 38))];
    }
    else
    {
        [[NSImage imageNamed:@"ribbon8"] drawInRect:r fromRect:r operation:NSCompositeSourceOver fraction:1];
        
        //draw the check mark
        NSDictionary *d = [self attributesForFontName:@"Helvetica" withSize:24];
        NSMutableAttributedString *check = [[NSMutableAttributedString alloc] initWithString:@"✓" attributes:d];
        CGFloat paddingx = 16;
        CGFloat paddingy = 17;

        [check drawAtPoint:NSPointFromCGPoint(CGPointMake(paddingx, paddingy))];
    }
}

@end
