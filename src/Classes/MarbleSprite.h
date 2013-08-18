//
//  MarbleSprite.h
//  Accelerometer-Sparrow2
//
//  Created by Joseph Caudill on 8/17/13.
//
//
#import <Foundation/Foundation.h>

@interface MarbleSprite : SPSprite <SPAnimatable>

+ (MarbleSprite*) marble;

- (void) advanceTime:(double)seconds;
- (BOOL) checkEdgeCollide;
- (void) accellorateByX:(int)x y:(int)y;

@end