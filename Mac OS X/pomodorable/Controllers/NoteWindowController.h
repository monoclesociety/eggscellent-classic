//
//  NoteWindowController.h
//  pomodorable
//
//  Created by Kyle Kinkade on 2/28/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NoteWindowController : NSWindowController
{
    IBOutlet NSTextView *textView;
    IBOutlet NSImageView *imageView;
    IBOutlet NSButton *clearButton;
}

- (IBAction)clearTextSelected:(id)sender;
- (IBAction)close:(id)sender;
@end
