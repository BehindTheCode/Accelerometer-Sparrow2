//
//  MarbleSprite.m
//  Accelerometer-Sparrow2
//
//  Created by Joseph Caudill on 8/17/13.
//
//

#import "MarbleSprite.h"
#import "Media.h"

@implementation MarbleSprite
{
    SPImage *_Image;
    BOOL _lastWasEdgeX;
    BOOL _lastWasEdgeY;
    float _velocityX;
    float _velocityY;
}

// 1) Factory Method for creating the Ball Sprite
+ (MarbleSprite*)marble
{
    return [[MarbleSprite alloc] init];
}

// 2) Override to the init method to call our setup method
- (id)init
{
    self = [super init];
    if (self) {
        
        [self setup];
        
    }
    return self;
}

// 3) Adds the image to the sprite
- (void)setup
{
    // Draw the marble
    _Image = [SPImage imageWithContentsOfFile:@"blueMarble.png"];
    _Image.x = -_Image.width / 2;
    _Image.y = -_Image.height / 2;
    [self addChild:_Image];
    
    _velocityX = 0.0f;
    _velocityY = 0.0f;
}

- (void)advanceTime:(double)seconds
{
    self.x += _velocityX * seconds * seconds;
    self.y += _velocityY * seconds * seconds;
    
}

-(BOOL) checkEdgeCollide{
    
    BOOL didCollide = FALSE;
    SPRectangle *ballBounds = [self boundsInSpace:[Sparrow root]];
    int ballRadius = self.width / 2;
    float stageWidth = [Sparrow stage].width;
    float stageHeight = [Sparrow stage].height;
    
    // Stop the ball if it's reached a boundary
    if (ballBounds.left < 0 || ballBounds.right > stageWidth) {
        if (!_lastWasEdgeX)
        {
            [self collide];
            _lastWasEdgeX = didCollide = TRUE;
        }
        _velocityX = 0; //stop velocity
        self.x = self.x < ballRadius ? ballRadius : stageWidth - ballRadius;
    }else {
        _lastWasEdgeX = FALSE;
    }
    
    if (ballBounds.top < 0 || ballBounds.bottom > stageHeight)
    {
        if (!_lastWasEdgeY)
        {
            [self collide];
            _lastWasEdgeY = didCollide = TRUE;
        }
        _velocityY = 0; //stop velocity
        self.y=self.y < ballRadius ? ballRadius : stageHeight - ballRadius;
    }else {
        _lastWasEdgeY = FALSE;
    }
    
    return didCollide;
}


- (void)collide
{
    [Media playSound:@"marbleCollide.aiff"];
}

- (void)accellorateByX:(int)x y:(int)y
{
    _velocityX += x;
    _velocityY += y;
}

@end