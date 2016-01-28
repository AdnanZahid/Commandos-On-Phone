//
//  Map.m
//  Commandos On Phone
//
//  Created by Administrator on 23/10/2015.
//  Copyright © 2015 Adnan Zahid. All rights reserved.
//

#import "Map.h"

#import "SpriteFactory.h"

@implementation Map {
    
//    NSMutableArray *validTiles;
    NSMutableArray *occupiedTiles;
    NSMutableArray *movementSensorBoundaryTiles;
}

SINGLETON_FOR_CLASS(Map)


int const minBlocks = 10;

- (NSValue *)valueWithPoint:(CGPoint)point {
    
#if TARGET_OS_IPHONE
    return [NSValue valueWithCGPoint:point];
#else
    return [NSValue valueWithPoint:point];
#endif
}

- (BOOL)isWallAtTileCoord:(CGPoint)point {
    
    return [occupiedTiles containsObject:[self valueWithPoint:point]];
}

- (BOOL)isMovementSensorBoundaryAtTileCoord:(CGPoint)point {
    
    return [movementSensorBoundaryTiles containsObject:[self valueWithPoint:point]];
}

- (BOOL)isValidTileCoord:(CGPoint)point {
    
    return YES;
//    return [validTiles containsObject:[NSValue valueWithCGPoint:point]];
}

- (void)addOccupiedPosition:(CGPoint)position {
    
    [occupiedTiles addObject:[self valueWithPoint:position]];
}

- (void)addMovementSensorBoundaryPosition:(CGPoint)position {
    
    [movementSensorBoundaryTiles addObject:[self valueWithPoint:position]];
}

- (NSArray *)walkableAdjacentTilesCoordForTileCoord:(CGPoint)tileCoord {
    
    NSMutableArray *availableAdjacents = [NSMutableArray arrayWithCapacity:8];
    
    BOOL t = NO;
    BOOL l = NO;
    BOOL b = NO;
    BOOL r = NO;
    
    // Top
    CGPoint p = CGPointMake(tileCoord.x, tileCoord.y - 1);
    if ([self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
        [availableAdjacents addObject:[self valueWithPoint:p]];
        t = YES;
    }
    
    // Left
    p = CGPointMake(tileCoord.x - 1, tileCoord.y);
    if ([self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
        [availableAdjacents addObject:[self valueWithPoint:p]];
        l = YES;
    }
    
    // Bottom
    p = CGPointMake(tileCoord.x, tileCoord.y + 1);
    if ([self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
        [availableAdjacents addObject:[self valueWithPoint:p]];
        b = YES;
    }
    
    // Right
    p = CGPointMake(tileCoord.x + 1, tileCoord.y);
    if ([self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
        [availableAdjacents addObject:[self valueWithPoint:p]];
        r = YES;
    }
    
    
    // Top Left
    p = CGPointMake(tileCoord.x - 1, tileCoord.y - 1);
    if (t && l && [self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
        [availableAdjacents addObject:[self valueWithPoint:p]];
    }
    
    // Bottom Left
    p = CGPointMake(tileCoord.x - 1, tileCoord.y + 1);
    if (b && l && [self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
        [availableAdjacents addObject:[self valueWithPoint:p]];
    }
    
    // Top Right
    p = CGPointMake(tileCoord.x + 1, tileCoord.y - 1);
    if (t && r && [self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
        [availableAdjacents addObject:[self valueWithPoint:p]];
    }
    
    // Bottom Right
    p = CGPointMake(tileCoord.x + 1, tileCoord.y + 1);
    if (b && r && [self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
        [availableAdjacents addObject:[self valueWithPoint:p]];
    }
    
    
    return [NSArray arrayWithArray:availableAdjacents];
}

- (NSMutableArray *)setupGrid:(CGFloat)width andHeight:(CGFloat)height {
    
    occupiedTiles = [NSMutableArray array];
    movementSensorBoundaryTiles = [NSMutableArray array];
    NSMutableArray *lines = [NSMutableArray array];
    
    self.columnWidth = self.rowHeight = width/minBlocks;
    
    if (width == height) {
        self.columns = self.rows = minBlocks;
        
    } else {
        self.columns = width/self.columnWidth;
        self.rows    = height/self.rowHeight;
    }
    
    for (int i = 0; i < self.columns; i++) {
        
        CGFloat x = self.columnWidth * i;
//        [lines addObject:[self drawLineFromPoint:CGPointMake(x, 0) toPoint:CGPointMake(x, height)]];
        
        [occupiedTiles addObject:[self valueWithPoint:CGPointMake(i, 0)]];
        [occupiedTiles addObject:[self valueWithPoint:CGPointMake(i, self.rows - 1)]];
        
        [lines addObject:[self setupFire:CGPointMake(x,                    0.5f  * self.rowHeight)]];
        [lines addObject:[self setupFire:CGPointMake(x, ((self.rows - 1) + 0.5f) * self.rowHeight)] ];
    }
    
    for (int i = 0; i < self.rows; i++) {
        
        CGFloat y = self.rowHeight * i;
//        [lines addObject:[self drawLineFromPoint:CGPointMake(0, y) toPoint:CGPointMake(width, y)]];
        
        [occupiedTiles addObject:[self valueWithPoint:CGPointMake(0, i)]];
        [occupiedTiles addObject:[self valueWithPoint:CGPointMake(self.columns - 1, i)]];
        
        [lines addObject:[self setupFire:CGPointMake(                      0.5f  * self.rowHeight, y)]];
        [lines addObject:[self setupFire:CGPointMake(((self.columns - 1) + 0.5f) * self.rowHeight, y)]];
    }
    
    return lines;
}

- (SKShapeNode *)drawLineFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
    
    SKShapeNode *line = [SKShapeNode node];
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, nil, fromPoint.x, fromPoint.y);
    CGPathAddLineToPoint(pathToDraw, nil, toPoint.x, toPoint.y);
    line.path = pathToDraw;
    [line setStrokeColor:[SKColor blackColor]];
    return line;
}

- (SKSpriteNode *)setupFire:(CGPoint)point {
    
    SKSpriteNode *fire = [SpriteFactory spriteWithAtlas:@"fire" repeatForever:YES removeOnCompletion:YES];
    fire.position = point;
    
    fire.xScale = 0.9f;
    fire.yScale = 0.9f;
    
    return fire;
}

@end