//
//  Media.h
//  Accelerometer-Sparrow2
//
//  Created by Joseph Caudill on 8/17/13.
//
//

#import <Foundation/Foundation.h>

@interface Media : NSObject

+ (void)initSound;
+ (void)releaseSound;

+ (SPSoundChannel *)soundChannel:(NSString *)soundName;
+ (void)playSound:(NSString *)soundName;

@end