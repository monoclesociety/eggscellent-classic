//
//  NoteWindowController.m
//  pomodorable
//
//  Created by Kyle Kinkade on 2/28/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import "HistoryWindowController.h"
#import "ColorView.h"

@implementation HistoryWindowController

#pragma mark - memory based methods

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) 
    {
        // Initialization code here.
    }
    
    return self;
}

#pragma mark - NSWindowController Lifecycle

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self.window setLevel:NSFloatingWindowLevel];
    [self.window setAcceptsMouseMovedEvents:YES];
    [self.window setMovableByWindowBackground:YES];
    [self.window setOpaque:NO];
    [self.window setStyleMask:NSResizableWindowMask];
    
    //set up "clear" button font and color
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];    
    pStyle.alignment = NSCenterTextAlignment;
    NSColor *txtColor = [NSColor colorWithDeviceRed:0.423 green:0.415 blue:0.317 alpha:1];
    NSFont *txtFont = [NSFont systemFontOfSize:12];
    
    NSDictionary *txtDict = [NSDictionary dictionaryWithObjectsAndKeys:pStyle, NSParagraphStyleAttributeName, txtFont, NSFontAttributeName, txtColor,  NSForegroundColorAttributeName, nil];
    NSAttributedString *stopString = [[NSMutableAttributedString alloc] initWithString:@"Clear" attributes:txtDict];
    [clearButton setAttributedTitle:stopString];
    
    ((ColorView *)self.window.contentView).backgroundColor = [NSColor colorWithDeviceRed:0.969 green:0.965 blue:0.702 alpha:1.000];
}

- (void)showWindow:(id)sender
{
    [super showWindow:sender];
}

- (void)close
{
    [super close];
}

#pragma mark - IBActions

- (IBAction)clearTextSelected:(id)sender;
{
}

- (IBAction)close:(id)sender;
{
    [self close];
}

#pragma mark - Image Drop NoteTextView Notifications

- (void)imageDropped:(NSNotification *)note
{
    
}

@end