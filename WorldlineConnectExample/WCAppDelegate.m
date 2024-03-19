//
//  WCAppDelegate.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import "SVProgressHUD.h"

#import "WCNetworkingActivityLogger.h"
#import <WorldlineConnectExample/WCAppDelegate.h>
#import <WorldlineConnectExample/WCStartViewController.h>

@implementation WCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Uncomment the following two statement to enable logging of requests and responses
    // [[WCNetworkingActivityLogger sharedLogger] startLogging];
    // [[WCNetworkingActivityLogger sharedLogger] setLogLevel: WCLoggerLevelDebug];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];

    WCStartViewController *shop = [[WCStartViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:shop];

    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}

@end
