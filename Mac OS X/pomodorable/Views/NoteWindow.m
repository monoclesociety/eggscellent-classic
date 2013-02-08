//
//  NoteWindow.m
//  pomodorable
//
//  Created by Kyle Kinkade on 3/1/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import "NoteWindow.h"

@implementation NoteWindow

- (BOOL)becomeFirstResponder
{
    return YES;
}

- (BOOL) canBecomeKeyWindow {return YES; }
- (BOOL) canBecomeMainWindow {return YES; }
- (BOOL) acceptsFirstResponder {return YES; }
- (BOOL) resignFirstResponder {return YES; }

@end
