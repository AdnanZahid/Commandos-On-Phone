//
//  GameScene.m
//  Commandos On Phone
//
//  Created by Administrator on 20/10/2015.
//  Copyright (c) 2015 Adnan Zahid. All rights reserved.
//

#import "GameScene.h"

#import "Movable objects/Car.h"
#import "Movable objects/Hero.h"
#import "Movable objects/Enemy.h"
#import "Map/Map.h"

#import "SpriteFactory.h"
#import "SKButton.h"

@implementation GameScene {
    
    CGFloat width;
    CGFloat height;
    
    Car *car;
    Hero *hero;
    Enemy *enemy;
    
    CGFloat blockSize;
    
    SKButton *gunButton;
    SKButton *walkButton;
}

CGFloat const buttonScale = 0.5f;

- (void)didMoveToView:(SKView *)view {
    
    width = self.view.frame.size.width;
    height = self.view.frame.size.height;
    
    [self setupBackground];
    
    NSMutableArray *lines = [[Map sharedMap] setupGrid:width andHeight:height];
    
    blockSize = [[Map sharedMap] columnWidth];
    
    for (SKNode *line in lines) {
        [self addChild:line];
    }
    
    [self setupHero:CGPointMake(2, 2)];
    
    [self setupEnemy:CGPointMake(7, 12)];
    
    [self setupCar:CGPointMake(5, 2) atlasName:@"car2"];
    [self setupCar:CGPointMake(5, 4) atlasName:@"car1"];
    [self setupCar:CGPointMake(5, 6) atlasName:@"car2"];
    [self setupCar:CGPointMake(5, 8) atlasName:@"car1"];
    [self setupCar:CGPointMake(5, 10) atlasName:@"car2"];
    
    [self setupFire:CGPointMake(3, 2)];
    [self setupFire:CGPointMake(3, 3)];
    [self setupFire:CGPointMake(3, 4)];
    [self setupFire:CGPointMake(3, 5)];
    [self setupFire:CGPointMake(3, 6)];
    [self setupFire:CGPointMake(3, 7)];
    [self setupFire:CGPointMake(3, 8)];
    
    [self setupFire:CGPointMake(7, 2)];
    [self setupFire:CGPointMake(7, 3)];
    [self setupFire:CGPointMake(7, 4)];
    [self setupFire:CGPointMake(7, 5)];
    [self setupFire:CGPointMake(7, 6)];
    [self setupFire:CGPointMake(7, 7)];
    [self setupFire:CGPointMake(7, 8)];
    
    [self setupGunButton];
    [self setupWalkButton];
}

- (void)setupBackground {
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"grass"];
    
    CGFloat scaleX = width/background.size.width;
    CGFloat scaleY = height/background.size.height;
    
    background.xScale = scaleX;
    background.yScale = scaleY;
    
    background.position = CGPointMake(width/2, height/2);
    
    background.zPosition = -100;
    
    [self addChild:background];
}

- (void)setupGunButton {
    
    gunButton = [[SKButton alloc] initWithImageNamedNormal:@"gunIconSelected" selected:@"gunIconSelected" disabled:@"gunIcon" scale:0.5f];
    gunButton.isEnabled = NO;
    gunButton.position = CGPointMake(width - gunButton.size.width/2, gunButton.size.height/2);
    [gunButton setTouchDownTarget:self action:@selector(toggleGun)];
    
    gunButton.zPosition = 100;
    
    [self addChild:gunButton];
}

- (void)setupWalkButton {
    
    walkButton = [[SKButton alloc] initWithImageNamedNormal:@"walkIconSelected" selected:@"walkIconSelected" disabled:@"walkIcon" scale:0.5f];
    walkButton.isEnabled = NO;
    walkButton.position = CGPointMake(walkButton.size.width/2, height - walkButton.size.height/2);
//    [walkButton setTouchDownTarget:self action:@selector(toggleWalk)];
    
    walkButton.zPosition = 100;
    
    [self addChild:walkButton];
}

- (void)toggleGun {
    
    gunButton.isEnabled = !gunButton.isEnabled;
    walkButton.isEnabled = !walkButton.isEnabled;
}

- (void)setupCar:(CGPoint)position atlasName:(NSString *)atlasName {
    
    car = [[Car alloc] initWithPosition:position atlasName:atlasName];
    [self addChild:car.sprite];
}

- (void)setupHero:(CGPoint)position {
    
    hero = [[Hero alloc] initWithPosition:position andVelocity:blockSize];
//    hero.runMode = YES;
    hero.intruderAlertDelegate = self;
    hero.reachedDestinationDelegate = self;
    [self addChild:hero.sprite];
}

- (void)setupEnemy:(CGPoint)position {
    
    enemy = [[Enemy alloc] initWithPosition:position andVelocity:blockSize];
    //    enemy.runMode = YES;
    [self addChild:enemy.sprite];
}

- (CGFloat)distanceBetweenPoints:(CGPoint)first second:(CGPoint)second {
    return hypotf(second.x - first.x, second.y - first.y);
}

- (void)huntMeDown {
    
    [enemy.sprite removeAllActions];
    void (^completion)() = ^{[self huntMeDown];};
    
    if ([self distanceBetweenPoints:hero.position second:enemy.position] > 4) {
        
        [enemy moveToward:hero.position completion:completion];
//        [car moveToward:hero.position completion:completion];
    } else {
        
        [enemy shootAtPosition:hero.position completion:completion];
    }
}

#if TARGET_OS_IPHONE
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        [self onTouch:location tapCount:touch.tapCount];
    }
}
#else
- (void)mouseDown:(NSEvent *)theEvent {
    
    CGPoint location = [theEvent locationInNode:self];
    
    [self onTouch:location];
}
#endif

- (void)onTouch:(CGPoint)location tapCount:(NSUInteger)tapCount {
    
    [hero.sprite removeAllActions];
    
    int x = location.x/blockSize;
    int y = location.y/blockSize;
    
    if (gunButton.isEnabled) {
        
        if (tapCount == 1) {
            [hero shootAtPosition:CGPointMake(x, y) completion:nil];
            [self makeExplosion:location];
        }
    } else {
        
        if (tapCount == 1) {
            
            hero.runMode = NO;
            [hero moveToward:CGPointMake(x, y) completion:nil];
        } else if (tapCount == 2) {
            
            hero.runMode = YES;
            [hero moveToward:CGPointMake(x, y) completion:nil];
        }
    }
}

- (void)iHaveReachedDestination {
    
}

- (void)makeExplosion:(CGPoint)position {
    
    SKSpriteNode *gunShotExplosion = [SpriteFactory spriteWithAtlas:@"gunShotExplosion" repeatForever:NO removeOnCompletion:YES];
    gunShotExplosion.position = position;
    [self addChild:gunShotExplosion];
}

- (void)update:(CFTimeInterval)currentTime {
    
}

- (void)setupFire:(CGPoint)position {
    
    [[Map sharedMap] addOccupiedPosition:position];
    
    SKSpriteNode *fire = [SpriteFactory spriteWithAtlas:@"fire" repeatForever:YES removeOnCompletion:YES];
    fire.position = CGPointMake((position.x + 0.5f) * blockSize, (position.y + 1.0f) * blockSize);
    
    fire.xScale = 0.9f;
    fire.yScale = 0.9f;
    
    [self addChild:fire];
}

@end