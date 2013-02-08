//
//  MSSearchField.m
//  pomodorable
//
//  Created by Kyle Kinkade on 2/27/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import "MSSearchField.h"
#import "MSSearchFieldCell.h"
@implementation MSSearchField

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (BOOL)becomeFirstResponder
{
    BOOL result = [super becomeFirstResponder];
  //  NSLog(@"becomes first responder: %d", result);
    return result;
}

- (BOOL)resignFirstResponder
{
    [((MSSearchFieldCell *)self.cell) setBackgroundColor:[NSColor colorWithDeviceWhite:.98 alpha:1]];
        [self setNeedsDisplay:YES];
    BOOL result = [super resignFirstResponder];
   // NSLog(@"resign first responder: %d", result);
    return result;
}

- (BOOL)acceptsFirstResponder
{
    BOOL result = [super acceptsFirstResponder];
  //  NSLog(@"Accepts first responder: %d", result);
    return result;
}

+ (Class)cellClass
{
    return [MSSearchFieldCell class];
}

@end
