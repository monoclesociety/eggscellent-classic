//
//  NoteTextView.h
//  pomodorable
//
//  Created by Kyle Kinkade on 3/1/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "ColorView.h"

@interface NoteTextView : ColorView
{
    NSColor *lineColor;
	NSImage *image;
	BOOL drawsLinesAndImage;
}
- (void)setLineColor:(NSColor *)color;
- (NSColor *)lineColor;
- (void)setImage:(NSImage *)newImage;
- (NSImage *)image;
- (void)setDrawsLinesAndImage:(BOOL)flag;
- (BOOL)drawsLinesAndImage;
@end
