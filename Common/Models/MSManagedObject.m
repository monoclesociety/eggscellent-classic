//
//  PomoManagedObject.m
//  pomodorable
//
//  Created by Kyle Kinkade on 1/20/12.
//  Copyright (c) 2012 Monocle Society LLC  All rights reserved.
//

#import "MSManagedObject.h"

@implementation MSManagedObject
@dynamic modified;
@dynamic created;

#pragma mark - Core Data overrides

- (void)awakeFromInsert
{
    self.created = [NSDate date];
}

- (void)willSave 
{
    [self setPrimitiveValue:[NSDate date] forKey:@"modified"];
    [super willSave];
}

@end
