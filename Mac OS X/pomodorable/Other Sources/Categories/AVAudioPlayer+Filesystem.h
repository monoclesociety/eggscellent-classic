//
//  AVAudioPlayer+Filesystem.h
//  pomodorable
//
//  Created by Kyle kinkade on 2/23/13.
//  Copyright (c) 2013 Monocle Society LLC. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAudioPlayer (Filesystem)

+ (AVAudioPlayer *)soundForPreferenceKey:(NSString *)preferenceKey;

@end
