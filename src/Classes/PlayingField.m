//
//  PlayingField.m
//  Accelerometer-Sparrow2
//
//  Created by Joseph Caudill on 8/17/13.
//
//

#import <CoreMotion/CoreMotion.h>
#import "PlayingField.h"
#import "MarbleSprite.h"

#define ACCEL_FACTOR 10000
#define NUM_FILTER_POINTS 3

@implementation PlayingField
{
    CMMotionManager *_motionManager;
    NSMutableArray *rawAccelY;
    NSMutableArray *rawAccelX;
    SPJuggler *_Juggler;
    MarbleSprite *_marble;
}

- (id)init
{
    if (self = [super init])
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _Juggler = [[SPJuggler alloc] init];
    
    _motionManager = [[CMMotionManager alloc] init];
    [_motionManager startAccelerometerUpdates];
    
    rawAccelY = [NSMutableArray arrayWithCapacity:NUM_FILTER_POINTS];
    rawAccelX = [NSMutableArray arrayWithCapacity:NUM_FILTER_POINTS];
    for (int i = 0; i < NUM_FILTER_POINTS; i++)
    {
        [rawAccelY addObject:[NSNumber numberWithFloat:0.0]];
        [rawAccelX addObject:[NSNumber numberWithFloat:0.0]];
    }
    
    // Set a background
    NSString *bgFileName = @"woodBG.png";
    SPImage *background = [[SPImage alloc] initWithContentsOfFile:bgFileName];
    background.pivotX = background.width / 2;
    background.pivotY = background.height / 2;
    background.x = [Sparrow stage].width / 2;
    background.y = [Sparrow stage].height / 2;
    [self addChild:background];
    
    _marble = [MarbleSprite marble];
    _marble.x = 150;
    _marble.y = 100;
    [self addChild:_marble];
    [_Juggler addObject:_marble];
}

- (void)advanceTime:(double)seconds
{
    [self processAcceloration];
    
    [_Juggler advanceTime:seconds];
    [_marble checkEdgeCollide];
}

- (void) processAcceloration
{
    // 1
    float accelX =  0.0;
    float accelY =  0.0;
    // insert newest value
    // will push current values over by 1 spot, extending length by 1
    
    // 2
    [rawAccelY insertObject:[NSNumber numberWithFloat: _motionManager.accelerometerData.acceleration.y] atIndex:0];
    
    [rawAccelX insertObject:[NSNumber numberWithFloat: _motionManager.accelerometerData.acceleration.x] atIndex:0];
    
    // remove oldest value, returning length to NUM_FILTER_POINTS
    
    [rawAccelY removeObjectAtIndex:NUM_FILTER_POINTS];
    [rawAccelX removeObjectAtIndex:NUM_FILTER_POINTS];
    
    // 3
    // perform averaging
    
    for (NSNumber *raw in rawAccelY)
    {
        accelY += [raw floatValue];
    }
    accelY *= ACCEL_FACTOR / NUM_FILTER_POINTS;
    
    for (NSNumber *raw in rawAccelX)
    {
        accelX += [raw floatValue];
    }
    accelX *= ACCEL_FACTOR / NUM_FILTER_POINTS;
    
    [_marble accellorateByX:accelX y:-accelY];
}
@end