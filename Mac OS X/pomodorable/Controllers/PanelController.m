#import "PanelController.h"
#import "BackgroundView.h"
#import "StatusItemView.h"
#import "MenubarController.h"
#import "OverviewViewController.h"

#define OPEN_DURATION .15
#define CLOSE_DURATION .1
#define MENU_ANIMATION_DURATION .1

@implementation PanelController
@synthesize pinned = _pinned;
@synthesize isOpen = _isOpen;
@synthesize backgroundView = _backgroundView;
@synthesize delegate = _delegate;
@synthesize overviewController;

#pragma mark - Init and Dealloc

- (id)initWithDelegate:(id<PanelControllerDelegate>)delegate;// panelViewController:(PanelViewController *)pvc
{
    self = [super initWithWindowNibName:@"PanelController"];
    if (self != nil)
    {
        _delegate = delegate;
        self.overviewController = [[OverviewViewController alloc] initWithNibName:nil bundle:nil];
    }
    return self;
}


#pragma mark - overriden methods

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Make a fully skinned panel
    NSPanel *panel = (id)[self window];
    [panel setAcceptsMouseMovedEvents:YES];
    [panel setStyleMask:[panel styleMask] ^ NSTitledWindowMask];
    [panel setLevel:NSPopUpMenuWindowLevel];
    [panel setOpaque:NO];
    [panel setBackgroundColor:[NSColor clearColor]];
    
    [self setupOverviewController];
}

- (void)setupOverviewController
{
    // Resize panel
    NSWindow *panel = [self window];
    NSRect statusRect = [self statusRectForWindow:panel];
    NSRect panelRect = [[self window] frame];
    panelRect.origin.y = NSMaxY(statusRect) - NSHeight(panelRect);
    
    NSTimeInterval openDuration = OPEN_DURATION;
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:openDuration];
    [[((NSPanel *)self.window) animator] setFrame:panelRect display:YES];
    [NSAnimationContext endGrouping];
    
    self.overviewController.panelController = self;
    [[self.window contentView] addSubview:overviewController.view];
}

#pragma mark - Public accessors

- (void)togglePanel:(BOOL)flag
{
    if(flag)
    {
        [self openPanel];
    }
    else
    {
        [self closePanel];
    }
}

#pragma mark - NSWindowDelegate

- (void)windowWillClose:(NSNotification *)notification
{
    [self closePanel];
}

- (void)windowDidResignKey:(NSNotification *)notification;
{
    if ([[self window] isVisible])
    {
        [self closePanel];
    }
}

- (void)windowDidResize:(NSNotification *)notification
{
//    NSWindow *panel = [self window];
//    NSRect statusRect = [self statusRectForWindow:panel];
//    NSRect panelRect = [panel frame];
    
//    CGFloat statusX = roundf(NSMidX(statusRect));
//    CGFloat panelX = statusX - NSMinX(panelRect);
 //   self.backgroundView.arrowX = panelX;
}

#pragma mark - Keyboard

- (void)cancelOperation:(id)sender
{
    [self closePanel];
}

#pragma mark - Public methods

- (NSRect)statusRectForWindow:(NSWindow *)window
{
    NSRect screenRect = [[window screen] frame];
    NSRect statusRect = NSZeroRect;
    
    StatusItemView *statusItemView = nil;
    if ([self.delegate respondsToSelector:@selector(statusItemViewForPanelController:)])
    {
        statusItemView = [self.delegate statusItemViewForPanelController:self];
    }
    
    if (statusItemView)
    {
        statusRect = statusItemView.globalRect;
        statusRect.origin.y = NSMinY(statusRect) - NSHeight(statusRect);
    }
    else
    {
        statusRect.size = NSMakeSize(STATUS_ITEM_VIEW_WIDTH, [[NSStatusBar systemStatusBar] thickness]);
        statusRect.origin.x = roundf((NSWidth(screenRect) - NSWidth(statusRect)) / 2);
        statusRect.origin.y = NSHeight(screenRect) - NSHeight(statusRect) * 2;
    }
    return statusRect;
}

- (void)openPanel
{
    NSWindow *panel = [self window];
    
    NSRect screenRect = [[panel screen] frame];
    NSRect statusRect = [self statusRectForWindow:panel];
    
    NSRect panelRect = [panel frame];
    panelRect.origin.x = roundf(NSMidX(statusRect) - NSWidth(panelRect) / 2);
    panelRect.origin.y = NSMaxY(statusRect) - NSHeight(panelRect);
    
    if (NSMaxX(panelRect) > (NSMaxX(screenRect) - ARROW_HEIGHT))
        panelRect.origin.x -= NSMaxX(panelRect) - (NSMaxX(screenRect) - ARROW_HEIGHT);
    
    [NSApp activateIgnoringOtherApps:NO];
    [panel setAlphaValue:0];
    [panel setFrame:statusRect display:YES];
    [panel makeKeyAndOrderFront:nil];
    
//    NSTimeInterval openDuration = OPEN_DURATION;
    
//    NSEvent *currentEvent = [NSApp currentEvent];
//    if ([currentEvent type] == NSLeftMouseDown)
//    {
//        NSUInteger clearFlags = ([currentEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask);
//        BOOL shiftPressed = (clearFlags == NSShiftKeyMask);
//        BOOL shiftOptionPressed = (clearFlags == (NSShiftKeyMask | NSAlternateKeyMask));
//        if (shiftPressed || shiftOptionPressed)
//        {
//            openDuration *= 10;
//            
////            if (shiftOptionPressed)
////                NSLog(@"Icon is at %@\n\tMenu is on screen %@\n\tWill be animated to %@",
////                      NSStringFromRect(statusRect), NSStringFromRect(screenRect), NSStringFromRect(panelRect));
//        }
//    }
    
    [overviewController viewWillAppear];

    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0];
            [[panel animator] setFrame:panelRect display:YES];
            [[panel animator] setAlphaValue:1];
    [NSAnimationContext endGrouping];
    
    [overviewController viewDidAppear];
    
    _isOpen = YES;
}

- (void)closePanel
{
    if(self.pinned)
        return;
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:CLOSE_DURATION];
    [[[self window] animator] setAlphaValue:0];
    [NSAnimationContext endGrouping];
    
    dispatch_after(dispatch_walltime(NULL, NSEC_PER_SEC * CLOSE_DURATION * 2), dispatch_get_main_queue(), ^{
        [self close];
    });
    
    _isOpen = NO;
}

- (void)panelDidDisappear
{
    [overviewController viewDidDisappear];
}

@end
