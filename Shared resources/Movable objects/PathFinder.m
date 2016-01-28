//
//  PathFinder.m
//  Commandos On Phone
//
//  Created by Administrator on 23/10/2015.
//  Copyright © 2015 Adnan Zahid. All rights reserved.
//

#import "PathFinder.h"

#import "ShortestPathStep.h"

@implementation PathFinder {
    
    NSMutableArray *shortestPath;
    NSMutableArray *shortestPathOpenSteps;
    NSMutableArray *shortestPathClosedSteps;
}

- (void)moveToward:(CGPoint)target completion:(void (^)())completion {
    
    CGPoint fromTileCoord = self.position;
    CGPoint toTileCoord   = target;
    
    shortestPathOpenSteps = [NSMutableArray array];
    shortestPathClosedSteps = [NSMutableArray array];
    
    [self insertInOpenSteps:[[ShortestPathStep alloc] initWithPosition:fromTileCoord]];
    
    do {
        ShortestPathStep *currentStep = [shortestPathOpenSteps objectAtIndex:0];
        
        [shortestPathClosedSteps addObject:currentStep];
        [shortestPathOpenSteps removeObjectAtIndex:0];
        
        if (CGPointEqualToPoint(currentStep.position, toTileCoord)) {
            
            [self constructPathAndStartAnimationFromStep:currentStep completion:completion];
            ShortestPathStep *temporaryStep = currentStep;
            
            do {
                temporaryStep = temporaryStep.parent;
                
            } while (temporaryStep);
            
            shortestPathOpenSteps = nil;
            shortestPathClosedSteps = nil;
            break;
        }
        
        NSArray *adjacentSteps = [[Map sharedMap] walkableAdjacentTilesCoordForTileCoord:currentStep.position];
        
        for (NSValue *value in adjacentSteps) {
#if TARGET_OS_IPHONE
            ShortestPathStep *step = [[ShortestPathStep alloc] initWithPosition:[value CGPointValue]];
#else
            ShortestPathStep *step = [[ShortestPathStep alloc] initWithPosition:[value pointValue]];
#endif
            
            if ([shortestPathClosedSteps containsObject:step]) {
                continue;
            }
            
            int moveCost = [self costToMoveFromStep:currentStep toAdjacentStep:step];
            
            NSUInteger index = [shortestPathOpenSteps indexOfObject:step];
            
            if (index == NSNotFound) {
                
                step.parent = currentStep;
                
                step.gScore = currentStep.gScore + moveCost;
                
                step.hScore = [self computeHScoreFromCoord:step.position toCoord:toTileCoord];
                
                [self insertInOpenSteps:step];
            }
            else {
                
                step = [shortestPathOpenSteps objectAtIndex:index];
                
                if ((currentStep.gScore + moveCost) < step.gScore) {
                    
                    step.gScore = currentStep.gScore + moveCost;
                    
                    [shortestPathOpenSteps removeObjectAtIndex:index];
                    
                    [self insertInOpenSteps:step];
                }
            }
        }
        
    } while ([shortestPathOpenSteps count] > 0);
}

- (void)constructPathAndStartAnimationFromStep:(ShortestPathStep *)step completion:(void (^)())completion {
    
    shortestPath = [NSMutableArray array];
    
    do {
        if (step.parent) {
            [shortestPath insertObject:step atIndex:0];
        }
        step = step.parent;
    } while (step);
    
    [self animateTowardStepIndex:0 completion:completion];
}

- (void)animateTowardStepIndex:(int)stepIndex completion:(void (^)())completion {
    
    if (stepIndex < shortestPath.count) {
        
        ShortestPathStep *nextStep = shortestPath[stepIndex];
        [self animatePosition:nextStep.position completion:^{
        
            if (completion) {
                completion();
            } else {
                [self animateTowardStepIndex:stepIndex + 1 completion:nil];
            }
        }];
        
    } else {
        shortestPath = nil;
        
        [self.reachedDestinationDelegate iHaveReachedDestination];
        
        [self iHaveReachedDestination];
    }
}

- (void)animatePosition:(CGPoint)position completion:(void (^)())completion {
    
}

- (void)iHaveReachedDestination {
    
}

- (void)insertInOpenSteps:(ShortestPathStep *)step {
    
    int stepFScore = [step fScore];
    NSUInteger count = [shortestPathOpenSteps count];
    
    int i = 0;
    for (; i < count; i++) {
        
        if (stepFScore <= [[shortestPathOpenSteps objectAtIndex:i] fScore]) {
            break;
        }
    }
    [shortestPathOpenSteps insertObject:step atIndex:i];
}

- (int)computeHScoreFromCoord:(CGPoint)fromCoord toCoord:(CGPoint)toCoord {
    
    return fabs(toCoord.x - fromCoord.x) + fabs(toCoord.y - fromCoord.y);
}

- (int)costToMoveFromStep:(ShortestPathStep *)fromStep toAdjacentStep:(ShortestPathStep *)toStep {
    
    return ((fromStep.position.x != toStep.position.x) && (fromStep.position.y != toStep.position.y)) ? 14 : 10;
}

@end