#import "StatusItemView.h"

@implementation StatusItemView

@synthesize statusItem = _statusItem;
@synthesize image = _image;
@synthesize alternateImage = _alternateImage;
@synthesize action = _action;
@synthesize target = _target;

@synthesize timerString;
#pragma mark -

- (id)initWithStatusItem:(NSStatusItem *)statusItem
{
    CGFloat itemWidth = [statusItem length];
    CGFloat itemHeight = [[NSStatusBar systemStatusBar] thickness];
    NSRect itemRect = NSMakeRect(0.0, 0.0, itemWidth, itemHeight);
    self = [super initWithFrame:itemRect];
    
    if (self != nil)
    {
        _statusItem = statusItem;
        _statusItem.view = self;
    }
    return self;
}


#pragma mark -

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
	[self.statusItem drawStatusBarBackgroundInRect:dirtyRect withHighlight:NO];//self.isHighlighted];
    
    NSImage *icon = self.image;
    CGFloat iconX = 0;
    CGFloat iconY = 4;
    NSPoint iconPoint = NSMakePoint(iconX, iconY);
    
    CGRect f = self.frame;
    f.origin = CGPointMake(0, 0);
    [icon drawAtPoint:iconPoint fromRect:f operation:NSCompositeSourceOver fraction:1];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
    NSFont *txtFont = [NSFont fontWithName:@"Helvetica" size:13];
    [dict setObject:txtFont forKey:NSFontAttributeName];
    [timerString drawAtPoint:CGPointMake(22, iconY) withAttributes:dict];
}

#pragma mark -
#pragma mark Mouse tracking

- (void)mouseDown:(NSEvent *)theEvent
{
    [NSApp sendAction:self.action to:self.target from:self];
}

#pragma mark - set image methods

- (void)setImage:(NSImage *)newImage
{
    _image = newImage;
    [self setNeedsDisplay:YES];
}

- (void)setAlternateImage:(NSImage *)newImage
{
    _alternateImage = newImage;
}

#pragma mark -

- (NSRect)globalRect
{
    NSRect frame = [self frame];
    frame.origin = [self.window convertBaseToScreen:frame.origin];
    return frame;
}

@end
