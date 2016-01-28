//
//  AppDelegate.h
//  Commandos
//

//  Copyright (c) 2015 Adnan Zahid. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>

@property (strong, nonatomic) NSWindow *window;
@property (strong, nonatomic) SKView *skView;

@end
