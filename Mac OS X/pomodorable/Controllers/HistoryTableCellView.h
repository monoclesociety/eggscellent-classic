//
//  HistoryTableCellView.h
//  Eggscellent
//
//  Created by Kyle kinkade on 4/13/13.
//  Copyright (c) 2013 Monocle Society LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HistoryWindowController.h"

@interface HistoryTableCellView : NSTableCellView
{
    
}
@property (strong) IBOutlet NSTextField *dateLabel;
@property (strong) IBOutlet NSTextField *timersLabel;
@property (strong) IBOutlet NSTextField *distractionsLabel;
@property (strong) IBOutlet NSButton    *checkmarkButton;

- (IBAction)toggleCompleteActivity:(id)sender;

@end
