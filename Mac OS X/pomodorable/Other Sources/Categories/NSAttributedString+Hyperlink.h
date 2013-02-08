//
//  NSAttributedString+Hyperlink.h
//  pomodorable
//
//  Created by Kyle kinkade on 8/12/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Hyperlink)
+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL;
@end