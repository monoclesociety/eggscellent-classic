//
//  ColorView.h
//  pomodorable
//
//  Created by Kyle Kinkade on 12/22/11.
//  Copyright (c) 2011 Monocle Society LLC  All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ColorView : NSView
{
    NSColor *backgroundColor;
}
@property (nonatomic, strong) NSColor *backgroundColor;


-(NSColor *)colorForPoint:(NSPoint)point;

@end
