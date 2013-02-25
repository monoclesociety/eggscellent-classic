//
//  MSButtonCell.m
//  pomodorable
//
//  Created by Kyle kinkade on 2/24/13.
//  Copyright (c) 2013 Monocle Society LLC. All rights reserved.
//

#import "MSButtonCell.h"

@implementation MSButtonCell

- (NSRect)drawTitle:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView
{
    if (![self isEnabled]) {
        return [super drawTitle:[self attributedTitle] withFrame:frame inView:controlView];
    }
    
    return [super drawTitle:title withFrame:frame inView:controlView];
}

@end
