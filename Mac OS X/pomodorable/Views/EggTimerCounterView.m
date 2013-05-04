//
//  PomodoroCounterView.m
//  pomodorable
//
//  Created by Kyle Kinkade on 11/12/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//

#import "EggTimerCounterView.h"

@implementation EggTimerCounterView
@synthesize unfilledPomodoroImage;
@synthesize plannedCount;

- (void)awakeFromNib
{
    [super awakeFromNib];    
    self.unfilledPomodoroImage = [NSImage imageNamed:@"pom_count-off"];
}


- (void)setPlannedCount:(NSNumber *)aPlannedCount;
{
    plannedCount = aPlannedCount;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];

    NSSize iconSize = NSSizeFromString(@"16,16");//self.pomodoroImage.size;
    int i = 0;
    
    CGRect inRect = self.frame;
    
    
    CGRect fromRect = self.frame;
    fromRect.origin = CGPointMake(0, 0);
    int pCount = [plannedCount intValue];
    while(i < pCount)
    {
        NSString *s  = [NSString stringWithFormat:@"egg_count-%d", i + 1, nil];
        NSString *imagePath = [[NSBundle mainBundle] pathForImageResource:s];
        NSImage *img = [[NSImage alloc] initWithContentsOfFile:imagePath];
        
        CGFloat iconX = ((i * iconSize.width) + (i * 2));
        inRect.origin = NSMakePoint(iconX, 0);
        [img drawInRect:inRect fromRect:fromRect operation:NSCompositeSourceOver fraction:1];
        i++;
    }
    
    if(pCount < MAX_EGG_COUNT)
    {
        int remaining = MAX_EGG_COUNT - pCount;
        
        NSSize iconSize = self.unfilledPomodoroImage.size;
        int ii = 0;
        while(ii < remaining)
        {
            CGFloat iconX = ((i * iconSize.width) + (i * 2));
            inRect.origin = NSMakePoint(iconX, 0);

            [self.unfilledPomodoroImage drawInRect:inRect fromRect:fromRect operation:NSCompositeSourceOver fraction:1];
            i++;
            ii++;
        }
    }
}

@end