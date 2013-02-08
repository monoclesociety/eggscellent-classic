//
//  WindowController.h
//  pomodorable
//
//  Created by Kyle Kinkade on 5/15/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OverviewViewController.h"

@interface WindowController : NSWindowController
{
    IBOutlet OverviewViewController *viewController;
}
@end
