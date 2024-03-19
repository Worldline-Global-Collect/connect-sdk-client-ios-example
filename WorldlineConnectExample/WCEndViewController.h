//
//  WCEndViewController.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <WorldlineConnectExample/WCContinueShoppingTarget.h>
#import <WorldlineConnectExample/WCViewFactory.h>
#import <WorldlineConnectSDK/WCPreparedPaymentRequest.h>

@interface WCEndViewController : UIViewController

@property (weak, nonatomic) id <WCContinueShoppingTarget> target;
@property (strong, nonatomic) WCViewFactory *viewFactory;
@property (strong, nonatomic) WCPreparedPaymentRequest *preparedPaymentRequest;
@property (strong, nonatomic) UIButton *resultButton;
@property (strong, nonatomic) UITextView *encryptedText;

@end
