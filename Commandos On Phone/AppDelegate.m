//
//  AppDelegate.m
//  Commandos On Phone
//
//  Created by Administrator on 20/10/2015.
//  Copyright © 2015 Adnan Zahid. All rights reserved.
//

#import "AppDelegate.h"

#import "GameViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    GameViewController *gameViewController = [[GameViewController alloc] init];
    self.window.rootViewController = gameViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end