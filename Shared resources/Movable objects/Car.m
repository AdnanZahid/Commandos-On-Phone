//
//  Car.m
//  Commandos On Phone
//
//  Created by Administrator on 20/10/2015.
//  Copyright © 2015 Adnan Zahid. All rights reserved.
//

#import "Car.h"

@implementation Car {
    
    NSMutableArray *frames;
    NSUInteger framesCount;
    
    NSUInteger degreesRotated;
    NSUInteger frameNumber;
    
    NSMutableArray *rotatingFrames;
}

int const velocity = 32;
CGFloat const moveOneBlockTime = 0.5f;
CGFloat const oneFrameDegreeEquivalent = 7.5f;

- (id)initWithPosition:(CGPoint)position atlasName:(NSString *)atlasName {
    
    if (self = [super init]) {
        
        [self setupFramesWithAtlasName:atlasName];
        
        degreesRotated = 0;
        self.position = position;
        
        framesCount = frames.count;
        
        self.sprite.xScale = 0.5f;
        self.sprite.yScale = 0.5f;
    }
    
    return self;
}

- (void)setupFramesWithAtlasName:(NSString *)atlasName {
    
    frames = [NSMutableArray array];
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:atlasName];
    
    for (int i=1; i <= atlas.textureNames.count; i++) {
        NSString *textureName = [NSString stringWithFormat:@"image%d", i];
        SKTexture *temp = [atlas textureNamed:textureName];
        [frames addObject:temp];
    }
    SKTexture *texture = frames[0];
    self.sprite = [SKSpriteNode spriteNodeWithTexture:texture];
}

- (CGPoint)convertToActionPosition:(CGPoint)position {
    
    return CGPointMake((position.x + 0.5f) * velocity, (position.y + 0.5f) * velocity);
}

- (void)setPosition:(CGPoint)position {
    
    [super setPosition:position];
    
    self.sprite.position = [self convertToActionPosition:position];
    
    [[Map sharedMap] addOccupiedPosition:position];
}

- (void)animatePosition:(CGPoint)position completion:(void (^)())completion {
    
    [self decideWhatDirectionToFace:position completion:^{
        
        CGPoint location = [self convertToActionPosition:position];
        SKAction *moveToward = [SKAction moveTo:location duration:moveOneBlockTime];
        
        [self.sprite runAction:moveToward completion:^{
            
            [super setPosition:position];
            if (completion) {
                completion();
            }
        }];
    }];
}

- (void)decideWhatDirectionToFace:(CGPoint)position completion:(void (^)())completion {
    
    rotatingFrames = [NSMutableArray array];
    
    CGFloat xDistance = position.x - self.position.x;
    CGFloat yDistance = position.y - self.position.y;
    
    CGFloat radianTheta = atan2(yDistance, xDistance);
    CGFloat theta = (radianTheta * 180.0f)/M_PI;
    
    int integerEquivalentOfTheta = roundf(theta/oneFrameDegreeEquivalent);
    
    NSUInteger desiredFrame;
    if (integerEquivalentOfTheta < 0) {
        desiredFrame = framesCount + integerEquivalentOfTheta;
    } else {
        desiredFrame = integerEquivalentOfTheta;
    }
    
    NSUInteger a;
    NSUInteger b;
    
    BOOL rotateLeft;
    NSUInteger howMuchToRotate;
    if (desiredFrame > frameNumber) {
        a = desiredFrame - frameNumber;
        b = (framesCount - desiredFrame) + frameNumber;
        
        if (a < b) {
            rotateLeft = YES;
            howMuchToRotate = a;
        } else {
            rotateLeft = NO;
            howMuchToRotate = b;
        }
        
    } else {
        a = frameNumber - desiredFrame;
        b = (framesCount - frameNumber) + desiredFrame;
        
        if (a < b) {
            rotateLeft = NO;
            howMuchToRotate = a;
        } else {
            rotateLeft = YES;
            howMuchToRotate = b;
        }
    }
    
    if (howMuchToRotate == 0) {
        
        completion();
    } else {
        for (int i = 0; i < howMuchToRotate; i++) {
            
            if (rotateLeft) {
                [self rotateLeft];
            } else {
                
                [self rotateRight];
            }
            
            [rotatingFrames addObject:frames[frameNumber]];
        }
        
        [self rotateWithCompletion:completion howMuchToRotate:howMuchToRotate];
    }
}

- (void)rotateLeft {
    
    frameNumber = (frameNumber + 1) % framesCount;
}

- (void)rotateRight {
    
    frameNumber --;
    
    if (frameNumber == -1) {
        frameNumber = frames.count - 1;
    }
}

- (void)rotateWithCompletion:(void (^)())completion howMuchToRotate:(NSUInteger)howMuchToRotate {
    
    degreesRotated = oneFrameDegreeEquivalent * frameNumber;
    [self.sprite runAction:[SKAction animateWithTextures:rotatingFrames timePerFrame:moveOneBlockTime/howMuchToRotate resize:YES restore:NO] completion:completion];
    
    rotatingFrames = nil;
}

- (void)moveForward {
    
    CGPoint carPosition = self.sprite.position;
    
    carPosition.x += velocity * sin((degreesRotated * M_PI)/180.0f);
    carPosition.y += velocity * cos((degreesRotated * M_PI)/180.0f);
    
    self.sprite.position = carPosition;
}

- (void)moveBackward {
    
    CGPoint carPosition = self.sprite.position;
    
    carPosition.x -= velocity * sin((degreesRotated * M_PI)/180.0f);
    carPosition.y -= velocity * cos((degreesRotated * M_PI)/180.0f);
    
    self.sprite.position = carPosition;
}

@end