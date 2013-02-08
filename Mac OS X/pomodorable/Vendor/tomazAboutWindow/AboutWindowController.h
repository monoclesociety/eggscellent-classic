//
//  AboutWindowController.h
//  ScrollingAboutWindow
//
//  Created by Tomaž Kragelj on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AboutWindowController : NSWindowController

- (IBAction)getInTouch:(id)sender;

@property (nonatomic, weak) IBOutlet NSTextField *applicationNameLabel;
@property (nonatomic, weak) IBOutlet NSTextField *applicationVersionLabel;
@property (nonatomic, weak) IBOutlet NSTextField *punchLineLabel;
@property (nonatomic, weak) IBOutlet NSTextField *copyrightLabel;
@property (nonatomic, weak) IBOutlet NSView *creditsView;

@end

#pragma mark -

@interface BackgroundColorView : NSView
@property (nonatomic, strong) NSColor *gb_backgroundColor;
@end
