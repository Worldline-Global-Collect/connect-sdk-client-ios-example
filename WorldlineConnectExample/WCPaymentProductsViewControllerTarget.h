//
//  WCPaymentProductSelectionDelegate.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PassKit/PassKit.h>
#import <WorldlineConnectExample/WCPaymentProductSelectionTarget.h>
#import <WorldlineConnectExample/WCPaymentRequestTarget.h>
#import <WorldlineConnectSDK/WCSession.h>
#import <WorldlineConnectSDK/WCSDKConstants.h>
#import <WorldlineConnectExample/WCAppConstants.h>
#import <WorldlineConnectExample/WCPaymentProductViewController.h>
#import <WorldlineConnectExample/WCCardProductViewController.h>
#import <WorldlineConnectExample/WCPaymentFinishedTarget.h>


@interface WCPaymentProductsViewControllerTarget : NSObject <WCPaymentProductSelectionTarget, WCPaymentRequestTarget, PKPaymentAuthorizationViewControllerDelegate>

@property (weak, nonatomic) id <WCPaymentFinishedTarget> paymentFinishedTarget;

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController session:(WCSession *)session context:(WCPaymentContext *)context viewFactory:(WCViewFactory *)viewFactory;
- (void)didSubmitPaymentRequest:(WCPaymentRequest *)paymentRequest success:(void (^)())succes failure:(void (^)())failure;

- (void)showApplePaySheetForPaymentProduct:(WCPaymentProduct *)paymentProduct withAvailableNetworks:(WCPaymentProductNetworks *)paymentProductNetworks;

@end
