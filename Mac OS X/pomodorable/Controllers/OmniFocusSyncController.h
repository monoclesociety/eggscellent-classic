//
//  OmniFocusSyncController.h
//  pomodorable
//
//  Created by Kyle kinkade on 5/20/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskSyncController.h"

@interface OmniFocusSyncController : TaskSyncController
{
    NSThread *syncThread;
}
@property (strong, nonatomic) NSThread *syncThread;

@end
