//
//  PathFinder.h
//  Commandos On Phone
//
//  Created by Administrator on 23/10/2015.
//  Copyright © 2015 Adnan Zahid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

#import "Map.h"

#import "ReachedDestinationDelegate.h"

@interface PathFinder : NSObject

@property (nonatomic) CGPoint position;

@property (nonatomic, strong) id <ReachedDestinationDelegate> reachedDestinationDelegate;

- (void)moveToward:(CGPoint)target completion:(void (^)())completion;

@end
