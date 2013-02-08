//
//  MSSearchFieldCell.m
//  pomodorable
//
//  Created by Kyle Kinkade on 2/27/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import "MSSearchFieldCell.h"

@implementation MSSearchFieldCell
-(id)init
{
    if (self = [super init])
        m_pBGColor = [NSColor blueColor];
    return self;
}
- (void)setBackgroundColor:(NSColor*)pBGColor
{
    if (m_pBGColor != pBGColor)
    {
        m_pBGColor = pBGColor;
    }
}
- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    if (m_pBGColor != Nil)
    {
        [m_pBGColor setFill];
        NSRect frame = cellFrame;
        double radius = MIN(NSWidth(frame), NSHeight(frame)) / 2.0;
        [[NSBezierPath bezierPathWithRoundedRect:frame
                                         xRadius:radius yRadius:radius] fill];
    }
    [super drawInteriorWithFrame:cellFrame inView:controlView];
}

@end