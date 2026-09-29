//
//  WCAppDelegate.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import "WCNetworkingActivityLogger.h"
#import <WorldlineConnectExample/WCAppDelegate.h>
#import <WorldlineConnectExample/WCStartViewController.h>

@implementation WCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Uncomment the following two statement to enable logging of requests and responses
    // [[WCNetworkingActivityLogger sharedLogger] startLogging];
    // [[WCNetworkingActivityLogger sharedLogger] setLogLevel: WCLoggerLevelDebug];
    return YES;
}

- (UISceneConfiguration *)application:(UIApplication *)application
configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession
                               options:(UISceneConnectionOptions *)options {
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration"
                                          sessionRole:connectingSceneSession.role];
}

- (void)application:(UIApplication *)application
didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
}

@end
