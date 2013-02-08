//
//  NotificationsPreferencesViewController.m
//  pomodorable
//
//  Created by Kyle Kinkade on 11/22/11.
//  Copyright (c) 2011 Monocle Society LLC All rights reserved.
//

#import "NotificationsPreferencesViewController.h"
#import "AppDelegate.h"
#import "EggTimer.h"

@interface NotificationsPreferencesViewController (private)
- (void)populatePopUpButton:(NSPopUpButton *)popUpButton withList:(NSArray *)list forPreference:(NSString *)preferenceKey;
- (void)populatePopUpButtons;
- (NSString *)audioPathForFiles:(NSArray *)files withPopUpButton:(NSPopUpButton *)popUpButton;
- (NSString *)chooseCustomSoundForControl:(id)sender;
@end

@implementation NotificationsPreferencesViewController
@synthesize window;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Initialization code here.
        NSString *s = [[NSBundle mainBundle] pathForResource:@"Audio" ofType:@"plist"];
        NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:s];
        ticks = [d objectForKey:@"Ticks"];
        completions = [d objectForKey:@"Completions"];
        customs = [[NSUserDefaults standardUserDefaults] arrayForKey:@"customAudio"];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self populatePopUpButtons];
}


#pragma mark - MASPreferencesWindowController Delegate Methods

- (void)viewDidDisappear;
{
    [previewSound stop];
    previewSound = nil;
}

#pragma mark - Custom Methods

- (void)populatePopUpButtons;
{
    [self populatePopUpButton:tickSelection withList:ticks forPreference:@"tickAudioPath"];
    [self populatePopUpButton:pomodoroCompletion withList:completions forPreference:@"pomodoroAudioPath"];
    [self populatePopUpButton:breakCompletion withList:completions forPreference:@"breakAudioPath"];
}

- (void)populatePopUpButton:(NSPopUpButton *)popUpButton withList:(NSArray *)list forPreference:(NSString *)preferenceKey;
{
    [popUpButton removeAllItems];
    
    NSString *defaultFilename = [[NSUserDefaults standardUserDefaults] stringForKey:preferenceKey];
    NSString *defaultTitle = nil;
    int i = 0;
    for(; i < [list count]; i++)
    {
        NSDictionary *sound = [list objectAtIndex:i];
        [popUpButton addItemWithTitle:[sound objectForKey:@"name"]];
        if([[sound objectForKey:@"filename"] isEqualToString:defaultFilename])
        {
            defaultTitle = [sound objectForKey:@"name"];
        }
    }
    
    if([customs count])
    {
        [popUpButton.menu addItem:[NSMenuItem separatorItem]];
        for(NSDictionary *sound in customs)
        {
            [popUpButton addItemWithTitle:[sound objectForKey:@"name"]];
            if([[sound objectForKey:@"filename"] isEqualToString:defaultFilename])
            {
                defaultTitle = [sound objectForKey:@"name"];
            }
        }
    }

    [popUpButton selectItemWithTitle:defaultTitle];
    [popUpButton.menu addItem:[NSMenuItem separatorItem]];
    [popUpButton addItemWithTitle:@"Choose Sound..."];
}
- (NSString *)audioStoragePath
{
    NSString *lul  = NSHomeDirectory();
    lul = [lul stringByAppendingPathComponent:@"Sounds"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:lul isDirectory:NULL])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:lul withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    return lul;
}
- (void)registerSound:(NSString *)audioPath forPreference:(NSString *)preferenceKey
{
    if(!audioPath)
        return;
    
    
    NSString *audioStoragePathForSound = audioPath;
    
    //either play a preview sound because you're not in a pomodoro
    BOOL pomodoroStopped = ([EggTimer currentTimer].status == TimerStatusStopped);
    if(pomodoroStopped)
    {        
        [previewSound stop];
        previewSound = nil;
        previewSound = [NSSound soundNamed:audioPath];
        if(!previewSound)
        {
            NSData *d = [NSData dataWithContentsOfFile:audioPath];
        
            NSString *quickCheckForAudioAtPath = [[self audioStoragePath] stringByAppendingPathComponent:[audioPath lastPathComponent]];
            if(![[NSFileManager defaultManager] fileExistsAtPath:quickCheckForAudioAtPath])
            {
                audioStoragePathForSound = quickCheckForAudioAtPath;
                [d writeToFile:audioStoragePathForSound atomically:NO];
            }
            
            previewSound = [[NSSound alloc] initWithData:d];
        }
        float volume = [[NSUserDefaults standardUserDefaults] floatForKey:@"audioVolume"];
        [previewSound setDelegate:self];
        [previewSound setVolume:volume];
        [previewSound setLoops:NO];
        [previewSound play]; 
    }
    
    //save the new change for the sound for the appropriate key
    [[NSUserDefaults standardUserDefaults] setValue:audioStoragePathForSound forKey:preferenceKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //or tell the app delegate to play a different sound when it's in a pomodoro
    if(!pomodoroStopped)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"soundChanged" object:preferenceKey];
}

- (NSString *)chooseCustomSoundForControl:(id)sender;
{
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:YES];
    [panel setAllowsMultipleSelection:NO];
    
    NSArray *soundTypes = [NSSound soundUnfilteredTypes];
    [panel setAllowedFileTypes:soundTypes];
    
    NSString *customSound = nil;
    if([panel runModal])
    {
        NSURL *theDoc = [[panel URLs] objectAtIndex:0];
        NSString *name = [[theDoc pathComponents] lastObject];
        customSound = [theDoc path];
        
        NSString *customAudioPath = [[self audioStoragePath] stringByAppendingPathComponent:[customSound lastPathComponent]];
        
        NSDictionary *newItem = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", customAudioPath, @"filename", nil];
        
        if(!customs)
        {
            customs = [NSArray arrayWithObject:newItem];
        }
        else 
        {
            customs = [customs arrayByAddingObject:newItem];
        }
        
        [[NSUserDefaults standardUserDefaults] setValue:customs forKey:@"customAudio"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self populatePopUpButtons];
    }
    else 
    {
        //go back to current selection
    }
    
    return customSound;
}

- (NSString *)audioPathForFiles:(NSArray *)files withPopUpButton:(NSPopUpButton *)popUpButton
{
    int index = (int)[popUpButton indexOfSelectedItem];
    NSString *audioPath = nil;
    if(index < [files count])
    {
        NSDictionary *d = [files objectAtIndex:index];
        audioPath = [d objectForKey:@"filename"];
    }
    else
    {
        if([[popUpButton titleOfSelectedItem] isEqualToString:@"Choose Sound..."])
        {
            audioPath = [self chooseCustomSoundForControl:popUpButton];
        }
        else 
        {
            int adjustedIndex = index - ((int)[files count] + 1);
            NSDictionary *d = [customs objectAtIndex:adjustedIndex];
            audioPath = [d objectForKey:@"filename"];
        }
    }
    
    return audioPath;
}

#pragma mark - IBActions

- (IBAction)newCompletedSoundSelected:(id)sender
{
    NSString *audioPath = [self audioPathForFiles:completions withPopUpButton:(NSPopUpButton *)sender];
    
    if(sender == pomodoroCompletion)
    {
        [self registerSound:audioPath forPreference:@"pomodoroAudioPath"];
    }
    else
    {
        [self registerSound:audioPath forPreference:@"breakAudioPath"];
    }
}

- (IBAction)newTickSoundSelected:(id)sender;
{
    NSString *audioPath = [self audioPathForFiles:ticks withPopUpButton:tickSelection];

    [self registerSound:audioPath forPreference:@"tickAudioPath"];
}

- (IBAction)volumeChange:(id)sender;
{
    if(previewSound)
    {
        NSNumber *n = (NSNumber *)volumeSlider.objectValue;
        float volume = [n floatValue] / 100;
        [previewSound setVolume:volume];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"audioVolumeChanged" object:volumeSlider.objectValue];
}

#pragma mark NSSound Delegate methods

- (void)sound:(NSSound *)sound didFinishPlaying:(BOOL)aBool;
{
    previewSound = nil;
}

#pragma mark - MASPreferencesViewController Methods

- (NSString *)identifier
{
    return @"Audio Preferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:@"speaker"];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Audio", @"Toolbar item name for the General preference pane");
}

- (CGFloat)initialHeightOfView;
{
    return self.view.frame.size.height;
}

@end