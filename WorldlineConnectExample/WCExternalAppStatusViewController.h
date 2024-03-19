//
//  WCExternalAppStatusViewController.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 14/07/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WorldlineConnectSDK/WCThirdPartyStatus.h>

@interface WCExternalAppStatusViewController : UIViewController
@property (nonatomic, assign) WCThirdPartyStatus externalAppStatus;
@end
