//
//  HiddenButton.m
//  pomodorable
//
//  Created by Kyle Kinkade on 3/6/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import "HiddenButton.h"

@implementation HiddenButton

- (BOOL)accessibilityIsIgnored
{
    return YES;
}

@end
