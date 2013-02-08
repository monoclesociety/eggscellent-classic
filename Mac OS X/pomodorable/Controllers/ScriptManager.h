//
//  ScriptManager.h
//  pomodorable
//
//  Created by Kyle Kinkade on 11/22/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScriptManager : NSObject
{
    NSMutableDictionary *scripts;
}

+ (ScriptManager *)sharedManager;

- (NSAppleEventDescriptor *)executeScript:(NSString *)scriptId;
- (NSAppleEventDescriptor *)executeScript:(NSString *)scriptId withParameter:(NSString*)parameter;
- (NSAppleEventDescriptor *)executeScript:(NSString *)scriptId withParameters:(NSArray *)parameters;
- (NSAppleEventDescriptor *)executeSource:(NSString *)scriptId;

@end
