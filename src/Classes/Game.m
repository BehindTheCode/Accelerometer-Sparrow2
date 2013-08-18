//
//  Game.m
//  AppScaffold
//

#import "Game.h"
#import "PlayingField.h"

@implementation Game
{
    PlayingField *_field;
    BOOL _isPlaying;
}

- (id)init
{
    if ((self = [super init]))
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _field = [[PlayingField alloc] init];
    [self addChild: _field];
    
    [self addEventListener:@selector(onEnterFrame:) atObject:self
                   forType:SP_EVENT_TYPE_ENTER_FRAME];
    
    _isPlaying = TRUE;
}

- (void)onEnterFrame:(SPEnterFrameEvent*)event
{
    double passedTime = event.passedTime;
    
    if (_isPlaying) {
        // Game Action
        [_field advanceTime:passedTime];
    }
}

@end
