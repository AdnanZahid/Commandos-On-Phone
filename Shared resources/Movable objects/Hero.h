//
//  Hero.h
//  Commandos On Phone
//
//  Created by Administrator on 25/10/2015.
//  Copyright © 2015 Adnan Zahid. All rights reserved.
//

#import "Soldier.h"

#import "IntruderAlertDelegate.h"

@interface Hero : Soldier

@property (nonatomic, strong) id <IntruderAlertDelegate> intruderAlertDelegate;

@end