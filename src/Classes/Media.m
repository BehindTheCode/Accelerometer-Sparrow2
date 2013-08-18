//
//  Media.m
//  Accelerometer-Sparrow2
//
//  Created by Joseph Caudill on 8/17/13.
//
//

#import "Media.h"

@implementation Media

// 1
static NSMutableDictionary *sounds = NULL;

#pragma mark Audio

// 2
+ (void)initSound
{
    if (sounds) return;
    
    [SPAudioEngine start];
    sounds = [[NSMutableDictionary alloc] init];
    
    // enumerate all sounds
    
    NSString *soundDir = [[NSBundle mainBundle] resourcePath];
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:soundDir];
    
    NSString *filename;
    while (filename = [dirEnum nextObject])
    {
        if ([[filename pathExtension] isEqualToString: @"aiff"])
        {
            SPSound *sound = [[SPSound alloc] initWithContentsOfFile:filename];
            [sounds setObject:sound forKey:filename];
        }
    }
}

// 3
+ (void)releaseSound
{
    sounds = nil;
    
    [SPAudioEngine stop];
}

// 1
+ (void)playSound:(NSString *)soundName
{
    SPSound *sound = [sounds objectForKey:soundName];
    
    if (sound)
        [sound play];
    else
        [[SPSound soundWithContentsOfFile:soundName] play];
}

// 2
+ (SPSoundChannel *)soundChannel:(NSString *)soundName
{
    SPSound *sound = [sounds objectForKey:soundName];
    
    // sound was not preloaded
    if (!sound)
        sound = [SPSound soundWithContentsOfFile:soundName];
    
    return [sound createChannel];
}

@end
