//
//  MSSearchFieldCell.h
//  pomodorable
//
//  Created by Kyle Kinkade on 2/27/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface MSSearchFieldCell: NSSearchFieldCell
{
    NSColor *m_pBGColor;
}
- (void)setBackgroundColor:(NSColor*)pBGColor;
@end

