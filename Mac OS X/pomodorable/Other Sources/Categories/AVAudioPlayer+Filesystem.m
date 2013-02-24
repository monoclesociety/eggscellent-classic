//
//  AVAudioPlayer+Filesystem.m
//  pomodorable
//
//  Created by Kyle kinkade on 2/23/13.
//  Copyright (c) 2013 Monocle Society LLC. All rights reserved.
//

#import "AVAudioPlayer+Filesystem.h"

@implementation AVAudioPlayer (Filesystem)


+ (AVAudioPlayer *)soundForPreferenceKey:(NSString *)preferenceKey
{
    NSString *audioPath = [[NSUserDefaults standardUserDefaults] stringForKey:preferenceKey];
    AVAudioPlayer *returnSound = nil;
    
    NSString *fileName = [audioPath stringByDeletingPathExtension];
    //most likely is
    NSString *lul = [[NSBundle mainBundle] pathForResource:fileName ofType:[audioPath pathExtension]];
    NSData *fileData = [NSData dataWithContentsOfFile:lul];
    returnSound = [[AVAudioPlayer alloc] initWithData:fileData error:NULL];
    
    //someone using custom sounds? how unlikely!
    if(!returnSound)
    {
        fileData = [NSData dataWithContentsOfFile:audioPath];
        returnSound = [[AVAudioPlayer alloc] initWithData:fileData error:NULL];
    }
    
    float volume = [[NSUserDefaults standardUserDefaults] floatForKey:@"audioVolume"] / 100.0f;
    [returnSound setVolume:volume];
    return returnSound;
}

@end
