//
//  NSAttributedString+Hyperlink.m
//  pomodorable
//
//  Created by Kyle kinkade on 8/12/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import "NSAttributedString+Hyperlink.h"

@implementation NSAttributedString (Hyperlink)
+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL
{
    
    //set up "clear" button font and color
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    pStyle.alignment = NSCenterTextAlignment;
    NSColor *txtColor = [NSColor blueColor];
    NSFont *txtFont = [NSFont fontWithName:@"Lucida Grande" size:13];//[NSFont systemFontOfSize:13];
    
    NSDictionary *txtDict = [NSDictionary dictionaryWithObjectsAndKeys: pStyle, NSParagraphStyleAttributeName,
                             txtFont, NSFontAttributeName,
                             txtColor, NSForegroundColorAttributeName,
                             [aURL absoluteString], NSLinkAttributeName,
                             [NSNumber numberWithInt:NSSingleUnderlineStyle], NSUnderlineStyleAttributeName,
                             nil];
    NSAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:inString attributes:txtDict];
    return attrString;
}
@end