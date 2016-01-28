//
//  AppDelegate.m
//  Commandos
//
//  Created by Administrator on 24/10/2015.
//  Copyright (c) 2015 Adnan Zahid. All rights reserved.
//

#import "AppDelegate.h"

#import "GameScene.h"

@implementation AppDelegate

- (id)init {
    
    if(self = [super init]) {
        
        NSRect contentSize = NSMakeRect(0.0f, 0.0f, 1000.0f, 1000.0f);
        NSUInteger windowStyleMask = NSTitledWindowMask | NSResizableWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask;
        self.window = [[NSWindow alloc] initWithContentRect:contentSize styleMask:windowStyleMask backing:NSBackingStoreBuffered defer:YES];
        self.window.backgroundColor = [NSColor whiteColor];
        self.window.title = @"MyBareMetalApp";
        
        NSMenu *mm = [NSApp mainMenu];
        NSMenuItem *myBareMetalAppItem = [mm itemAtIndex:0];
        NSMenu *subMenu = [myBareMetalAppItem submenu];
        NSMenuItem *prefMenu = [subMenu itemWithTag:100];
        prefMenu.target = self;
        prefMenu.action = @selector(showPreferencesMenu:);
        
        GameScene *scene = [GameScene sceneWithSize:self.window.frame.size];
        scene.scaleMode = SKSceneScaleModeAspectFit;
        
        self.skView = [[SKView alloc] initWithFrame:contentSize];
        self.skView.ignoresSiblingOrder = YES;
        self.skView.showsFPS = YES;
        self.skView.showsNodeCount = YES;
        
        [self.skView presentScene:scene];
    }
    return self;
}

-(IBAction)showPreferencesMenu:(id)sender
{
//    [NSApp runModalForWindow:[[PreferencesWindow alloc] initWithAppFrame:window.frame]];
}

-(void)applicationWillFinishLaunching:(NSNotification *)notification {
    
    [self.window setContentView:self.skView];
}

-(void)applicationDidFinishLaunching:(NSNotification *)notification {
    
    [self.window makeKeyAndOrderFront:self];
}

@end
