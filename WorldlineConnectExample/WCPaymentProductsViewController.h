//
//  WCPaymentProductsViewController.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <WorldlineConnectExample/WCPaymentProductSelectionTarget.h>
#import <WorldlineConnectExample/WCViewFactory.h>
#import <WorldlineConnectSDK/WCBasicPaymentProducts.h>

@class WCPaymentItems;

@interface WCPaymentProductsViewController : UITableViewController

@property (strong, nonatomic) WCViewFactory *viewFactory;
@property (weak, nonatomic) id <WCPaymentProductSelectionTarget> target;
@property (strong, nonatomic) WCPaymentItems *paymentItems;
@property (nonatomic) NSInteger amount;
@property (strong, nonatomic) NSString *currencyCode;

@end
