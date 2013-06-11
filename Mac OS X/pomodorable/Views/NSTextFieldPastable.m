//
//  NSTextFieldPastable.m
//  Eggscellent
//
//  Created by Piotr Szwach on 6/9/13.
//  Copyright (c) 2013 Monocle Society LLC. All rights reserved.
//

#import "NSTextFieldPastable.h"

@implementation NSTextFieldPastable

- (BOOL)performKeyEquivalent:(NSEvent *)theEvent
{
    if (([theEvent type] == NSKeyDown) && ([theEvent modifierFlags] & NSCommandKeyMask))
    {
        NSResponder * responder = [[self window] firstResponder];
        
        if ((responder != nil) && [responder isKindOfClass:[NSTextView class]])
        {
            NSTextView * textView = (NSTextView *)responder;
            NSRange range = [textView selectedRange];
            bool bHasSelectedTexts = (range.length > 0);
            
            unsigned short keyCode = [theEvent keyCode];
            
            bool bHandled = false;
                        
            //6 Z, 7 X, 8 C, 9 V
            if (keyCode == 6)
            {
                if ([[textView undoManager] canUndo])
                {
                    [[textView undoManager] undo];
                    bHandled = true;
                }
            }
            else if (keyCode == 7 && bHasSelectedTexts)
            {
                [textView cut:self];
                bHandled = true;
            }
            else if (keyCode== 8 && bHasSelectedTexts)
            {
                [textView copy:self];
                bHandled = true;
            }
            else if (keyCode == 9)
            {
                [textView paste:self];
                bHandled = true;
            }
            else if (keyCode == 0)
            {
                [textView selectAll:self];
                bHandled = true;
            }
            
            if (bHandled)
                return YES;
        }
    }
    
    return NO;
}


@end
