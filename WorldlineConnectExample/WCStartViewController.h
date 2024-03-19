//
//  WCStartViewController.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <PassKit/PassKit.h>
#import <UIKit/UIKit.h>

#import <WorldlineConnectExample/WCPaymentProductSelectionTarget.h>
#import <WorldlineConnectExample/WCPaymentRequestTarget.h>
#import <WorldlineConnectExample/WCContinueShoppingTarget.h>
#import <WorldlineConnectExample/WCPaymentFinishedTarget.h>
#import <WorldlineConnectExample/WCParseJsonTarget.h>

@interface WCStartViewController : UIViewController <WCContinueShoppingTarget, WCPaymentFinishedTarget, WCParseJsonTarget>

@end
