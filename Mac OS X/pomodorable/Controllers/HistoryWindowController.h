//
//  NoteWindowController.h
//  pomodorable
//
//  Created by Kyle Kinkade on 2/28/12.
//  Copyright (c) 2012 Monocle Society LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ModelStore.h"
#import "ColorView.h"

@interface HistoryWindowController : NSWindowController
{
    IBOutlet ColorView      *contentView;
    IBOutlet NSImageView    *imageView;
    IBOutlet NSButton       *clearButton;
    IBOutlet NSTableView    *historyTableView;
    
    IBOutlet NSArrayController *arrayController;
    
    NSManagedObjectContext  *__weak _managedObjectContext;
    
    NSDate *firstDay;
    NSDate *lastDay;
    int weekCounter;
}
@property (weak, nonatomic, readonly) NSManagedObjectContext  *managedObjectContext;

- (IBAction)previousWeekSelected:(id)sender;
- (IBAction)nextWeekSelected:(id)sender;
- (IBAction)clearTextSelected:(id)sender;
- (IBAction)close:(id)sender;
@end
