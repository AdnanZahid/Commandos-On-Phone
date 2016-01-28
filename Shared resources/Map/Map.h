//
//  Map.h
//  Commandos On Phone
//
//  Created by Administrator on 23/10/2015.
//  Copyright © 2015 Adnan Zahid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

#import "CommonMacros.h"

@interface Map : NSObject

@property int columns;
@property int rows;

@property CGFloat columnWidth;
@property CGFloat rowHeight;

SINGLETONDECLARATION_FOR_CLASS(Map)

- (void)addOccupiedPosition:(CGPoint)position;

- (void)addMovementSensorBoundaryPosition:(CGPoint)position;

- (BOOL)isWallAtTileCoord:(CGPoint)point;

- (BOOL)isMovementSensorBoundaryAtTileCoord:(CGPoint)point;

- (NSArray *)walkableAdjacentTilesCoordForTileCoord:(CGPoint)tileCoord;

- (NSMutableArray *)setupGrid:(CGFloat)width andHeight:(CGFloat)height;

@end