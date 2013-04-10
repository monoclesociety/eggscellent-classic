//
//  AppDelegate.m
//  helper
//
//  Created by Kyle kinkade on 6/14/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import "AppDelegate.h"
#import <ServiceManagement/ServiceManagement.h>

@implementation AppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Check if main app is already running; if yes, do nothing and terminate helper app
    BOOL alreadyRunning = NO;
    NSArray *running = [[NSWorkspace sharedWorkspace] runningApplications];
    for (NSRunningApplication *app in running)
    {
        if ([[app bundleIdentifier] isEqualToString:@"com.monoclesociety.eggscellent.osx"])
        {
            NSLog(@"EGGSCELLENT IS ALREADY RUNNING");
            alreadyRunning = YES;
        }
    }
    
    if (!alreadyRunning)
    {
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSLog(@"Bundle Path: %@",path);
        NSArray *p = [path pathComponents];
        NSMutableArray *pathComponents = [NSMutableArray arrayWithArray:p];
        [pathComponents removeLastObject];
        [pathComponents removeLastObject];
        [pathComponents removeLastObject];
        [pathComponents addObject:@"MacOS"];
        [pathComponents addObject:@"Eggscellent"];
        NSString *newPath = [NSString pathWithComponents:pathComponents];
        NSLog(@"Final Path: %@", newPath);
        [[NSWorkspace sharedWorkspace] launchApplication:newPath];
    }
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}



@end
