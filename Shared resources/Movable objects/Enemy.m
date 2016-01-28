//
//  Enemy.m
//  Commandos On Phone
//
//  Created by Administrator on 25/10/2015.
//  Copyright © 2015 Adnan Zahid. All rights reserved.
//

#import "Enemy.h"

#import "SpriteFactory.h"

@implementation Enemy

int movementSensorRadius = 4;

- (id)initWithPosition:(CGPoint)position andVelocity:(int)velocity {
    
    if (self = [super initWithPosition:position andVelocity:velocity]) {
        
        for (int i = -movementSensorRadius; i <= movementSensorRadius; i++) {
            
            [[Map sharedMap] addMovementSensorBoundaryPosition:CGPointMake(self.position.x + i, self.position.y + movementSensorRadius)];
            [[Map sharedMap] addMovementSensorBoundaryPosition:CGPointMake(self.position.x + i, self.position.y - movementSensorRadius)];
        }
        for (int i = -movementSensorRadius; i <= movementSensorRadius; i++) {
            
            [[Map sharedMap] addMovementSensorBoundaryPosition:CGPointMake(self.position.x + movementSensorRadius, self.position.y + i)];
            [[Map sharedMap] addMovementSensorBoundaryPosition:CGPointMake(self.position.x - movementSensorRadius, self.position.y + i)];
        }
    }
    
    return self;
}

@end