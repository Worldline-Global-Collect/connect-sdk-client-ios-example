//
//  WCBancontactViewController.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 14/07/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import "WCPaymentProductViewController.h"

@interface WCBancontactProductViewController : WCPaymentProductViewController
@property (nonatomic, strong) NSDictionary<NSString *, NSObject *>* customServerJSON;
@end
