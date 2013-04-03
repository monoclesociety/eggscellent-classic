//
//  PomodoroBadgeView.h
//  pomodorable
//
//  Created by Kyle Kinkade on 12/27/11.
//  Copyright (c) 2011 Monocle Society LLC  All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PomodoroBadgeView : NSView
{
    int plannedPomodoroCount;
    int completePomodoroCount;
    
    NSDictionary *completedCountAttributes;
    NSDictionary *plannedCountAttributes;
    NSDate *completed;
}
@property (nonatomic, assign) int plannedPomodoroCount;
@property (nonatomic, assign) int completePomodoroCount;
@property (nonatomic, strong) NSDate *completed;

- (NSDictionary *)attributesForFontName:(NSString *)fontName withSize:(int)fontSize;

@end
