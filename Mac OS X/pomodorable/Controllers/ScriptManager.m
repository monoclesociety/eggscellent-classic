//
//  ScriptManager.m
//  pomodorable
//
//  Created by Kyle Kinkade on 11/22/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//

#import "ScriptManager.h"

@implementation ScriptManager

#pragma mark - Init and Singletons

+ (ScriptManager *)sharedManager;
{
    static ScriptManager *singleton;
    if(!singleton)
    {
        singleton = [[ScriptManager alloc] init];
    }
    
    return singleton;
}

- (id)init
{
    if(self = [super init])
    {
        scripts = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - script execution methods

- (NSAppleEventDescriptor *)executeSource:(NSString *)scriptId
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:scriptId withExtension:@"applescript"];
    if(!url)
        return nil;
    NSString *source = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
    NSDictionary *errorInfo = nil;
    NSAppleScript *applescript = [[NSAppleScript alloc] initWithSource:source];
    NSAppleEventDescriptor *aed = [applescript executeAndReturnError:&errorInfo];
    
    if(errorInfo)
        NSLog(@"POMO execute applescript error: %@", [errorInfo description]);
    
	return aed;
}

- (NSAppleEventDescriptor *)executeScript:(NSString*) scriptId
{
    NSDictionary *errorInfo = nil;
	NSAppleScript* applescript = [scripts objectForKey:scriptId];
	if (nil == applescript) 
    {
        NSURL *url = [[NSBundle mainBundle] URLForResource:scriptId withExtension:@"applescript"];
        if(!url)
            return nil;

		applescript = [[NSAppleScript alloc] initWithContentsOfURL:url error:&errorInfo];
        
        if(errorInfo)
        {
            return nil;
        }
        
        if(applescript)
            [scripts setObject:applescript forKey:scriptId];
        
	}
    errorInfo = nil;
    NSAppleEventDescriptor *aed = [applescript executeAndReturnError:&errorInfo];
    
    if(errorInfo)
        return nil;
    
	return aed;
}

- (NSAppleEventDescriptor *)executeScript:(NSString *)scriptId withParameter:(NSString*)parameter 
{
	NSString* scriptText = [scripts objectForKey:scriptId];
    NSError *error = nil;
	if (nil == scriptText) 
    {
        NSURL *url = [[NSBundle mainBundle] URLForResource:scriptId withExtension:@"applescript"];
        
		scriptText = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
		[scripts setObject:scriptText forKey:scriptId];
	}

    NSString *fullSource = [NSString stringWithFormat:scriptText, parameter];
	NSAppleScript* applescript = [[NSAppleScript alloc] initWithSource:fullSource];
    
    NSDictionary *errorInfo = nil;
    NSAppleEventDescriptor *ed = [applescript executeAndReturnError:&errorInfo];
	return (ed);
}

//TODO: This method should really be made resuable with the method above. not sure why my brain can't figure it out lately (save me future self!)
//      Future self says: "I help those who helped themselves."
- (NSAppleEventDescriptor *)executeScript:(NSString *)scriptId withParameters:(NSArray *)parameters
{
	NSString* scriptText = [scripts objectForKey:scriptId];
	if (nil == scriptText)
    {
		NSString* scriptFileName = [[NSBundle mainBundle] pathForResource: scriptId ofType: @"applescript"];
        NSError *error;
		scriptText = [[NSString alloc] initWithContentsOfURL:[NSURL fileURLWithPath: scriptFileName] encoding:NSUTF8StringEncoding error:&error];
		[scripts setObject:scriptText forKey:scriptId];
	}
        
    for(NSString *parameter in parameters)
    {
        NSRange range = [scriptText rangeOfString:@"¡"];
        scriptText = [scriptText stringByReplacingCharactersInRange:range withString:parameter];
    }
    
	NSAppleScript* applescript = [[NSAppleScript alloc] initWithSource:scriptText];
    
    NSDictionary *error;
	NSAppleEventDescriptor *retValue = [applescript executeAndReturnError:&error];
    return retValue;
}

@end