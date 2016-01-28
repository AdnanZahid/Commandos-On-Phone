//
//  GameScene.h
//  Commandos On Phone
//

//  Copyright (c) 2015 Adnan Zahid. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "IntruderAlertDelegate.h"

#import "ReachedDestinationDelegate.h"

@interface GameScene : SKScene <IntruderAlertDelegate, ReachedDestinationDelegate>

@end