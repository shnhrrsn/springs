//
//  SPRAppDelegate.m
//  Springs
//
//  Created by Shaun Harrison on 5/2/15.
//  Copyright (c) 2015 shnhrrsn. All rights reserved.
//

#import "SPRAppDelegate.h"

#import "SPRUIKitSpringViewController.h"
#import "SPRRBBSpringViewController.h"
#import "SPRPOPSpringViewController.h"
#import "SPRJNWSpringViewController.h"

@implementation SPRAppDelegate {
	UIWindow* _window;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	UITabBarController* tabBarController = [[UITabBarController alloc] init];
	tabBarController.viewControllers = @[
		[[UINavigationController alloc] initWithRootViewController:[[SPRUIKitSpringViewController alloc] init]],
		[[UINavigationController alloc] initWithRootViewController:[[SPRRBBSpringViewController alloc] init]],
		[[UINavigationController alloc] initWithRootViewController:[[SPRPOPSpringViewController alloc] init]],
		[[UINavigationController alloc] initWithRootViewController:[[SPRJNWSpringViewController alloc] init]]
	];
	
	_window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	_window.rootViewController = tabBarController;
	_window.tintColor = [UIColor colorWithHue:(190.0 / 360.0) saturation:0.73 brightness:0.8 alpha:1.0];
	[_window makeKeyAndVisible];
	
	return YES;
}


@end
