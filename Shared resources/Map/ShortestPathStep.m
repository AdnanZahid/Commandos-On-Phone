//
//  ShortestPathStep.m
//  Commandos On Phone
//
//  Created by Administrator on 23/10/2015.
//  Copyright © 2015 Adnan Zahid. All rights reserved.
//

#import "ShortestPathStep.h"

@implementation ShortestPathStep

- (id)initWithPosition:(CGPoint)position {
    
    if ((self = [super init])) {
        self.position = position;
        self.gScore = 0;
        self.hScore = 0;
        self.parent = nil;
    }
    return self;
}

- (BOOL)isEqual:(ShortestPathStep *)other {
    
    return CGPointEqualToPoint(self.position, other.position);
}

- (int)fScore {
    
    return self.gScore + self.hScore;
}

@end