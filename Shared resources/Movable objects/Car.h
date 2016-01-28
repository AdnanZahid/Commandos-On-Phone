//
//  Car.h
//  Commandos On Phone
//
//  Created by Administrator on 20/10/2015.
//  Copyright © 2015 Adnan Zahid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

#import "PathFinder.h"

@interface Car : PathFinder

@property (nonatomic, strong) SKSpriteNode *sprite;

- (id)initWithPosition:(CGPoint)position atlasName:(NSString *)atlasName;
- (void)animatePosition:(CGPoint)position completion:(void (^)())completion;

@end