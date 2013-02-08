#import "Panel.h"
#import "PanelController.h"

@implementation Panel

- (BOOL)canBecomeKeyWindow;
{
    return YES; // Allow Search field to become the first responder
}

- (void)orderOut:(id)sender
{
    [super orderOut:sender];
    PanelController *mainPanel = (PanelController *)self.windowController;
    [mainPanel panelDidDisappear];
}

@end
