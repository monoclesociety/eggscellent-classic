//
//  NSAutoRefreshTextField.m
//  Eggscellent
//
//  Created by Kyle kinkade on 10/3/13.
//  Copyright (c) 2013 Monocle Society LLC. All rights reserved.
//

#import "NSAutoRefreshTextField.h"

@implementation NSAutoRefreshTextField

- (void)setStringValue:(NSString *)aString
{
    [super setStringValue:aString];
    [self setNeedsLayout:YES];
    [self setNeedsDisplay:YES];
}

@end
