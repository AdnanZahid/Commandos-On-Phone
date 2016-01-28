//
//  SpriteFactory.h
//  Iron cage
//
//  Created by Adnan Zahid on 6/24/15.
//  Copyright (c) 2015 Adnan Zahid. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SpriteFactory : NSObject

+ (SKSpriteNode *)spriteWithAtlas:(NSString *)atlasName repeatForever:(BOOL)repeatForever removeOnCompletion:(BOOL)removeOnCompletion;

@end