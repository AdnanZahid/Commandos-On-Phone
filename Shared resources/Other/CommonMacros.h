//
//  CommonMacros.h
//  Commandos On Phone
//
//  Created by Administrator on 23/10/2015.
//  Copyright © 2015 Adnan Zahid. All rights reserved.
//

#define SINGLETONDECLARATION_FOR_CLASS(classname)\
+ (id) shared##classname; \

#define SINGLETON_FOR_CLASS(classname)\
+ (id) shared##classname {\
static dispatch_once_t pred = 0;\
__strong static id _sharedObject = nil;\
dispatch_once(&pred, ^{\
_sharedObject = [[self alloc] init];\
});\
return _sharedObject;\
}