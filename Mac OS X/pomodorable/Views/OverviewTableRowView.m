//
//  OverviewTableRowView.m
//  pomodorable
//
//  Created by Kyle Kinkade on 12/30/11.
//  Copyright (c) 2011 Monocle Society LLC  All rights reserved.
//

#import "OverviewTableRowView.h"
#import "OverviewTableCellView.h"

@implementation OverviewTableRowView

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if([self numberOfColumns])
    {
        OverviewTableCellView *v = (OverviewTableCellView *)[self viewAtColumn:0];
        //v.selected = selected;
        [v setSelected:selected];
    }
}

@end
