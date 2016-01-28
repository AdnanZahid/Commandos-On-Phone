//
//  Hero.m
//  Commandos On Phone
//
//  Created by Administrator on 25/10/2015.
//  Copyright © 2015 Adnan Zahid. All rights reserved.
//

#import "Hero.h"

@implementation Hero

- (void)animatePosition:(CGPoint)position completion:(void (^)())completion {
    
    [super animatePosition:position completion:completion];
    
    if ([[Map sharedMap] isMovementSensorBoundaryAtTileCoord:position]) {
        
        [self.intruderAlertDelegate huntMeDown];
    }
}

- (void)shootAtPosition:(CGPoint)position completion:(void(^)())completion {
    
    [super shootAtPosition:position completion:completion];
    
    [self.intruderAlertDelegate huntMeDown];
}

@end