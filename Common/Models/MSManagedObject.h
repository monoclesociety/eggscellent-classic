//
//  PomoManagedObject.h
//  pomodorable
//
//  Created by Kyle Kinkade on 1/20/12.
//  Copyright (c) 2012 Monocle Society LLC  All rights reserved.
//

#import <CoreData/CoreData.h>

@interface MSManagedObject : NSManagedObject
{
    NSDate *created;
    NSDate *modified;
}

@property (strong) NSDate *created;
@property (strong) NSDate *modified;

@end
