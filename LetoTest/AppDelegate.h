//
//  AppDelegate.h
//  LetoTest
//
//  Created by Julien on 13/10/2013.
//  Copyright (c) 2013 Julien Claverie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TBXML;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
	TBXML *tbxml;
}

@property (strong, nonatomic) UIWindow *window;

@end
