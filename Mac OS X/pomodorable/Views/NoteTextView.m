//
//  NoteTextView.m
//  pomodorable
//
//  Created by Kyle Kinkade on 3/1/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import "NoteTextView.h"

@implementation NoteTextView

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender 
{
//    NSPasteboard *pboard;
//    NSDragOperation sourceDragMask;
//    sourceDragMask = [sender draggingSourceOperationMask];
//    pboard = [sender draggingPasteboard];
//
//    NSLog(@"pboard: %@", [pboard description]);
//    NSLog(@"source: %@", sourceDragMask);
    return YES;
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    return [super draggingEntered:sender];
}

#pragma mark -
#pragma mark Init/Dealloc

- (void)initLinedTextView
{
    // It is very important that the typing attributes are not NULL, as they will be used by
	// our drawing methods to calculate line height.
	[self setLineColor:[NSColor colorWithDeviceRed:0.777 green:0.875 blue:0.742 alpha:1.000]];
	[self setImage:nil];
	[self setDrawsLinesAndImage:NO];
    
    NSFont *inlineFont = [NSFont fontWithName:@"Courier" size:12.0];
    if(!inlineFont)
        inlineFont = [NSFont systemFontOfSize:12];
    
	[self setTypingAttributes:[NSDictionary dictionaryWithObject:inlineFont
														  forKey:NSFontAttributeName]];
}

// -initWithFrame invokes this method
- (id)initWithFrame:(NSRect)frameRect textContainer:(NSTextContainer *)textContainer
{
	if (self = [super initWithFrame:frameRect textContainer:textContainer])
	{
		[self initLinedTextView];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
	if (self = [super initWithCoder:coder])
	{
		[self initLinedTextView];
	}
	return self;
}


/*************************** Accessor Methods ***************************/

#pragma mark -
#pragma mark Accessor Methods

- (void)setLineColor:(NSColor *)color
{
	lineColor = color;
	[self setNeedsDisplayInRect:[self visibleRect]];
}

- (NSColor *)lineColor
{
	return lineColor;
}

- (void)setImage:(NSImage *)newImage
{
	image = newImage;
	[self setNeedsDisplayInRect:[self visibleRect]];
}

- (NSImage *)image
{
	return image;
}

- (void)setDrawsLinesAndImage:(BOOL)flag
{
	drawsLinesAndImage = flag;
	[self setNeedsDisplayInRect:[self visibleRect]];
}

- (BOOL)drawsLinesAndImage
{
	return drawsLinesAndImage;
}

/*************************** Drawing Methods ***************************/

#pragma mark -
#pragma mark Drawing Methods

//- (NSRange)glyphRangeForRect:(NSRect)aRect
//{
//	NSRange glyphRange;
//    NSLayoutManager *layoutManager = [self layoutManager];
//    NSTextContainer *textContainer = [self textContainer];
//    NSPoint containerOrigin = [self textContainerOrigin];
//	
//	// Convert from view coordinates to container coordinates
//	aRect = NSOffsetRect(aRect, -containerOrigin.x, -containerOrigin.y);
//	
//    glyphRange = [layoutManager glyphRangeForBoundingRect:aRect inTextContainer:textContainer];
//	
//	return glyphRange;
//}
//
//- (void)drawViewBackgroundInRect:(NSRect)rect
//{
//	// Do normal drawing first
//	[super drawViewBackgroundInRect:rect];
//	
//	// Is there an image to draw? If so, do so now
//	if (image)
//	{
//		// Copied from KBCorkboardView's -drawCardForItem:inRect:
//		BOOL imageFlippedState = [image isFlipped];
//		[image setFlipped:YES];	// We are in a flipped co-ordinate system
//		NSRect imgRect = NSMakeRect(0,0,[image size].width,[image size].height);
//		NSRect drawRect = rect;
//		// Make sure image is in proportion - so that it fills the height
//		drawRect.size.width = drawRect.size.height * (imgRect.size.width/imgRect.size.height);
//		drawRect.origin.x += (rect.size.width - drawRect.size.width)/2.0;
//		
//		// But if it is still too small, we have to scale it so that it fills the width and not the height
//		if (drawRect.size.width > rect.size.width)
//		{
//			drawRect = rect;
//			drawRect.size.height = drawRect.size.width * (imgRect.size.height/imgRect.size.width);
//			drawRect.origin.y += (rect.size.height - drawRect.size.height)/2.0;
//		}
//		
//		[image drawInRect:drawRect
//				 fromRect:imgRect
//				operation:NSCompositeSourceOver
//				 fraction:0.25];
//		
//		[image setFlipped:imageFlippedState];	// Reset the image to its former flipped state
//		
//		// If we aren't meant to draw the lines too, return
//		if (![self drawsLinesAndImage])
//			return;
//	}
//	
//	// Just in case the default line width changes...
//	float bezierDefaultLineWidth = [NSBezierPath defaultLineWidth];
//	[NSBezierPath setDefaultLineWidth:1.0];
//	
//	// Now draw the lines
//	NSLayoutManager *layoutManager = [self layoutManager];
//	NSPoint p1, p2;
//    NSRange lineRange;
//	float defaultLineHeight;
//	if ([self typingAttributes])
//	{
//		defaultLineHeight = [layoutManager defaultLineHeightForFont:
//                             [[self typingAttributes] objectForKey:NSFontAttributeName]];
//	}
//	else
//		defaultLineHeight = 14.0;
//	NSRect lineRect = NSMakeRect(0,rect.origin.y-defaultLineHeight,0,defaultLineHeight);
//	NSRange glyphRange = [self glyphRangeForRect:rect];
//	NSUInteger i = glyphRange.location;
//	
//	[lineColor set];
//	
//	// First draw the lines for the text
//	while (i < NSMaxRange(glyphRange))
//	{
//        lineRect = [layoutManager lineFragmentRectForGlyphAtIndex:i
//												   effectiveRange:&lineRange];
//		
//		p1 = NSMakePoint(rect.origin.x, (int)NSMaxY(lineRect)+0.5);
//		p2 = NSMakePoint(NSMaxX(rect), (int)NSMaxY(lineRect)+0.5);
//		[NSBezierPath strokeLineFromPoint:p1 toPoint:p2];
//		
//        i = NSMaxRange(lineRange);
//    }
//	
//	// Now continue to fill up the area with no text with lines
//	while (NSMaxY(lineRect) < NSMaxY(rect))
//	{
//		lineRect.origin.y += lineRect.size.height;
//		p1 = NSMakePoint(rect.origin.x, (int)NSMaxY(lineRect)+0.5);
//		p2 = NSMakePoint(NSMaxX(rect), (int)NSMaxY(lineRect)+0.5);
//		[NSBezierPath strokeLineFromPoint:p1 toPoint:p2];
//	}
//	
//	[NSBezierPath setDefaultLineWidth:bezierDefaultLineWidth];	// Reset
//}
//
//- (void)setNeedsDisplayInRect:(NSRect)aRect avoidAdditionalLayout:(BOOL)flag
//{
//	// All though this is not ideal as it is very expensive, we have to brute force
//	// the view to redraw its visible rect every time it is redrawn - otherwise the lines
//	// below the one currently being drawn may not get updated. Fortunately, this view
//	// is designed only to be used in small areas, such as for index cards, so this
//	// should not cause us too much grief.
//	[super setNeedsDisplayInRect:[self visibleRect] avoidAdditionalLayout:flag];
//}

@end