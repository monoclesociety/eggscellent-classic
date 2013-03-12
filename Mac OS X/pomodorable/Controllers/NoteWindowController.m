//
//  NoteWindowController.m
//  pomodorable
//
//  Created by Kyle Kinkade on 2/28/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import "NoteWindowController.h"
#import "ColorView.h"

@implementation NoteWindowController

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

    [textView setFont:[NSFont fontWithName:@"Helvetica-Light" size:17]];
    [textView setTextContainerInset:NSSizeFromString(@"15,0")];
    
    //set up "clear" button font and color
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];    
    pStyle.alignment = NSCenterTextAlignment;
    NSColor *txtColor = [NSColor colorWithDeviceRed:0.423 green:0.415 blue:0.317 alpha:1];
    NSFont *txtFont = [NSFont systemFontOfSize:12];
    
    NSDictionary *txtDict = [NSDictionary dictionaryWithObjectsAndKeys:pStyle, NSParagraphStyleAttributeName, txtFont, NSFontAttributeName, txtColor,  NSForegroundColorAttributeName, nil];
    NSAttributedString *stopString = [[NSMutableAttributedString alloc] initWithString:@"Clear" attributes:txtDict];
    [clearButton setAttributedTitle:stopString];
    ((ColorView *)self.window.contentView).backgroundColor = textView.backgroundColor;
    
//    NSButton *closeButton = [NSWindow
//                   standardWindowButton:NSWindowCloseButton forStyleMask:NSTitledWindowMask];
//    [self.window.contentView addSubview:closeButton];
}

- (void)showWindow:(id)sender
{
    NSString *noteString = [[NSUserDefaults standardUserDefaults] stringForKey:@"note"];
    if(noteString)
        textView.string = noteString;
    [super showWindow:sender];
}

- (void)close
{
    NSString *noteString = textView.string;
    if(noteString)
    {
        [[NSUserDefaults standardUserDefaults] setObject:textView.string forKey:@"note"];
        [[NSUserDefaults standardUserDefaults] synchronize];        
    }
    [super close];
}

#pragma mark - IBActions

- (IBAction)clearTextSelected:(id)sender;
{
    [textView setString:@""];
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