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
@property (weak) HistoryWindowController *historyController;
@property (strong) IBOutlet NSButton *infoButton;

- (IBAction)toggleCompleteActivity:(id)sender;

@end
