//
//  Soldier.h
//  Commandos On Phone
//
//  Created by Administrator on 20/10/2015.
//  Copyright © 2015 Adnan Zahid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

#import "PathFinder.h"

@interface Soldier : PathFinder

@property (nonatomic, strong) SKSpriteNode *sprite;
@property (nonatomic) BOOL runMode;

- (id)initWithPosition:(CGPoint)position andVelocity:(int)velocity;

- (void)shootAtPosition:(CGPoint)position completion:(void(^)())completion;

- (void)animatePosition:(CGPoint)position completion:(void (^)())completion;

@end