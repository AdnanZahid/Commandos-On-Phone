//
//  Soldier.m
//  Commandos On Phone
//
//  Created by Administrator on 20/10/2015.
//  Copyright © 2015 Adnan Zahid. All rights reserved.
//

#import "Soldier.h"

@implementation Soldier {
    
    NSArray *walkBackwardFrames;
    NSArray *walkForwardFrames;
    NSArray *walkLeftFrames;
    NSArray *walkRightFrames;
    
    NSArray *walkLeftBackwardFrames;
    NSArray *walkLeftForwardFrames;
    NSArray *walkRightBackwardFrames;
    NSArray *walkRightForwardFrames;
    
    NSMutableArray *shootBackwardFrames;
    NSMutableArray *shootForwardFrames;
    NSMutableArray *shootRightFrames;
    NSMutableArray *shootLeftFrames;
    
    NSMutableArray *shootRightForwardFrames;
    NSMutableArray *shootLeftForwardFrames;
    NSMutableArray *shootRightBackwardFrames;
    NSMutableArray *shootLeftBackwardFrames;
    
    NSUInteger frameNumber;
    
    int speed;
    CGFloat walkOneBlockTime;
}

- (id)initWithPosition:(CGPoint)position andVelocity:(int)velocity {
    
    if (self = [super init]) {
        
        walkBackwardFrames = @[[self setupFrames:@"walkBackward"], [self setupFrames:@"runBackward"]];
        walkForwardFrames = @[[self setupFrames:@"walkForward"], [self setupFrames:@"runForward"]];

        walkLeftFrames = @[[self setupFrames:@"walkLeft"], [self setupFrames:@"runLeft"]];
        walkRightFrames = @[[self setupFrames:@"walkRight"], [self setupFrames:@"runRight"]];
        
        walkLeftBackwardFrames = @[[self setupFrames:@"walkLeftBackward"], [self setupFrames:@"runLeftBackward"]];
        walkLeftForwardFrames = @[[self setupFrames:@"walkLeftForward"], [self setupFrames:@"runLeftForward"]];
        
        walkRightBackwardFrames = @[[self setupFrames:@"walkRightBackward"], [self setupFrames:@"runRightBackward"]];
        walkRightForwardFrames = @[[self setupFrames:@"walkRightForward"], [self setupFrames:@"runRightForward"]];
        
        shootBackwardFrames = [self setupFrames:@"shootBackward"];
        shootForwardFrames = [self setupFrames:@"shootForward"];
        shootRightFrames = [self setupFrames:@"shootRight"];
        shootLeftFrames = [self setupFrames:@"shootLeft"];
        
        shootRightForwardFrames = [self setupFrames:@"shootRightForward"];
        shootLeftForwardFrames = [self setupFrames:@"shootLeftForward"];
        shootRightBackwardFrames = [self setupFrames:@"shootRightBackward"];
        shootLeftBackwardFrames = [self setupFrames:@"shootLeftBackward"];
        
        SKTexture *texture = walkForwardFrames[0][0];
        self.sprite = [SKSpriteNode spriteNodeWithTexture:texture];
        
        speed = velocity;
        self.position = position;
        
        walkOneBlockTime = 0.5f;
        
        self.sprite.xScale = 0.75f;
        self.sprite.yScale = 0.75f;
    }
    
    return self;
}

- (void)shootAtPosition:(CGPoint)position completion:(void(^)())completion {
    
    if (position.x < self.position.x && position.y < self.position.y) {
        
        [self shootAnimationWithFrames:shootLeftBackwardFrames completion:completion];
        
    } else if (position.x < self.position.x && position.y > self.position.y) {
        
        [self shootAnimationWithFrames:shootLeftForwardFrames completion:completion];
        
    } else if (position.x > self.position.x && position.y < self.position.y) {
        
        [self shootAnimationWithFrames:shootRightBackwardFrames completion:completion];
        
    } else if (position.x > self.position.x && position.y > self.position.y) {
        
        [self shootAnimationWithFrames:shootRightForwardFrames completion:completion];
        
    } else if (position.x < self.position.x) {
        
        [self shootAnimationWithFrames:shootLeftFrames completion:completion];
        
    } else if (position.x > self.position.x) {
        
        [self shootAnimationWithFrames:shootRightFrames completion:completion];
        
    } else if (position.y < self.position.y) {
        
        [self shootAnimationWithFrames:shootBackwardFrames completion:completion];
        
    } else if (position.y > self.position.y) {
        
        [self shootAnimationWithFrames:shootForwardFrames completion:completion];
    }
}

- (void)shootAnimationWithFrames:(NSMutableArray *)frames completion:(void(^)())completion {
    
    if (completion) {
        [self.sprite runAction:[SKAction animateWithTextures:frames timePerFrame:0.1f resize:YES restore:NO] completion:^{
        
            completion();
        }];
    } else {
        [self.sprite runAction:[SKAction animateWithTextures:frames timePerFrame:0.1f resize:YES restore:NO]];
    }
}

- (void)setRunMode:(BOOL)runMode {
    
    _runMode = runMode;
    
    if (runMode) {
        walkOneBlockTime = 0.35f;
        
    } else {
        walkOneBlockTime = 0.5f;
    }
}

- (CGPoint)convertToActionPosition:(CGPoint)position {
    
    return CGPointMake((position.x + 0.5f) * speed, (position.y + 0.75f) * speed);
}

- (void)setPosition:(CGPoint)position {
    
    [super setPosition:position];

    self.sprite.position = [self convertToActionPosition:position];
    
//    [[Map sharedMap] addOccupiedPosition:position];
}

- (void)animatePosition:(CGPoint)position completion:(void (^)())completion {
    
    [self decideWhatWalkAnimationToPlay:position];
    
    [super setPosition:position];
    
    CGPoint location = [self convertToActionPosition:position];
    SKAction *walkToward = [SKAction moveTo:location duration:walkOneBlockTime];
    
    [self.sprite runAction:walkToward completion:^{
        
        completion();
    }];
}

- (void)decideWhatWalkAnimationToPlay:(CGPoint)position {
    
    if (position.x < self.position.x && position.y < self.position.y) {
        
        [self playWalkAnimation:walkLeftBackwardFrames];
        
    } else if (position.x < self.position.x && position.y > self.position.y) {
        
        [self playWalkAnimation:walkLeftForwardFrames];
        
    } else if (position.x > self.position.x && position.y < self.position.y) {
        
        [self playWalkAnimation:walkRightBackwardFrames];
        
    } else if (position.x > self.position.x && position.y > self.position.y) {
        
        [self playWalkAnimation:walkRightForwardFrames];
        
    } else if (position.x < self.position.x) {
        
        [self playWalkAnimation:walkLeftFrames];
        
    } else if (position.x > self.position.x) {
        
        [self playWalkAnimation:walkRightFrames];
        
    } else if (position.y < self.position.y) {
        
        [self playWalkAnimation:walkBackwardFrames];
        
    } else if (position.y > self.position.y) {
        
        [self playWalkAnimation:walkForwardFrames];
    }
}

- (void)playWalkAnimation:(NSArray *)frames {
    
    NSMutableArray *animationArray = frames[self.runMode];
    NSUInteger frameCount = animationArray.count;
    CGFloat timePerFrame = walkOneBlockTime/frameCount;
    
    [self.sprite runAction:[SKAction animateWithTextures:animationArray timePerFrame:timePerFrame resize:YES restore:NO]];
}

- (void)iHaveReachedDestination {
    
}

- (NSMutableArray *)setupFrames:(NSString *)atlasName {
    
    NSMutableArray *frames = [NSMutableArray array];
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:atlasName];
    
    for (int i=1; i <= atlas.textureNames.count; i++) {
        NSString *textureName = [NSString stringWithFormat:@"image%d", i];
        SKTexture *texture = [atlas textureNamed:textureName];
        [frames addObject:texture];
    }
    
    return frames;
}

- (void)walkForward {
    
    [self moveWithDirectionArray:walkForwardFrames velocityMultiplier:CGVectorMake(0, 1)];
}

- (void)walkBackward {
    
    [self moveWithDirectionArray:walkBackwardFrames velocityMultiplier:CGVectorMake(0, -1)];
}

- (void)walkRight {
    
    [self moveWithDirectionArray:walkRightFrames velocityMultiplier:CGVectorMake(1, 0)];
}

- (void)walkLeft {
    
    [self moveWithDirectionArray:walkLeftFrames velocityMultiplier:CGVectorMake(-1, 0)];
}

- (void)moveWithDirectionArray:(NSArray *)directionArray velocityMultiplier:(CGVector)velocityMultiplier {
    
    frameNumber = (frameNumber + 1) % 8;
    
    [self.sprite runAction:[SKAction setTexture:directionArray[self.runMode][frameNumber] resize:YES]];
    
    self.position = CGPointMake(self.position.x + velocityMultiplier.dx, self.position.y + velocityMultiplier.dy);
}

@end