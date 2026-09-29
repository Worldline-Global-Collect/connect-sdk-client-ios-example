//
//  WCSceneDelegate.m
//  WorldlineConnectExample
// 
//  Created for Worldline Global Collect on 29/09/2026.
//  Copyright © 2026 Worldline Global Collect. All rights reserved.
//


#import "WCSceneDelegate.h"
#import <WorldlineConnectExample/WCStartViewController.h>

@implementation WCSceneDelegate

- (void)scene:(UIScene *)scene
willConnectToSession:(UISceneSession *)session
      options:(UISceneConnectionOptions *)connectionOptions {
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];

    WCStartViewController *shop = [[WCStartViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:shop];

    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

@end
