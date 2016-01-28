//
//  main.m
//  Commandos
//
//  Created by Administrator on 24/10/2015.
//  Copyright © 2015 Adnan Zahid. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    
    @autoreleasepool {
        NSApplication * application = [NSApplication sharedApplication];
        
        AppDelegate * appDelegate = [[AppDelegate alloc] init];
        
        [application setDelegate:appDelegate];
        [application run];
        
        return EXIT_SUCCESS;
    }
}