#import "BackgroundView.h"
#import "StatusItemView.h"


@class PanelController;
@protocol PanelControllerDelegate <NSObject>

@optional
- (StatusItemView *)statusItemViewForPanelController:(PanelController *)controller;
@end

#pragma mark -
@class PanelViewController;
@class OverviewViewController;
@interface PanelController : NSWindowController <NSWindowDelegate>
{
    BOOL _isOpen;
    BOOL _pinned;
    BackgroundView *__weak _backgroundView;
    id<PanelControllerDelegate> __unsafe_unretained _delegate;
    
    OverviewViewController *overviewController;
}
@property (nonatomic, strong) OverviewViewController *overviewController;
@property (weak) IBOutlet BackgroundView *backgroundView;
@property (nonatomic, readonly) BOOL isOpen;
@property (nonatomic, assign) BOOL pinned;
@property (unsafe_unretained, nonatomic, readonly) id<PanelControllerDelegate> delegate;

- (id)initWithDelegate:(id<PanelControllerDelegate>)delegate;

- (void)openPanel;
- (void)closePanel;
- (NSRect)statusRectForWindow:(NSWindow *)window;

- (void)setupOverviewController;

- (void)panelDidDisappear;

@end
