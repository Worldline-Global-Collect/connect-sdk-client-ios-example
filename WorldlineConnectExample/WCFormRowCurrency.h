//
//  WCFormRowCurrency.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCFormRowWithInfoButton.h>
#import <WorldlineConnectExample/WCIntegerTextField.h>
#import <WorldlineConnectExample/WCFractionalTextField.h>
#import <WorldlineConnectSDK/WCPaymentProductField.h>
#import "WCFormRowField.h"
@interface WCFormRowCurrency : WCFormRowWithInfoButton

@property (strong, nonatomic) WCFormRowField *integerField;
@property (strong, nonatomic) WCFormRowField *fractionalField;
@property (strong, nonatomic) WCPaymentProductField *paymentProductField;
- (instancetype)initWithPaymentProductField:(WCPaymentProductField *)paymentProductField andIntegerField:(WCFormRowField *)integerField andFractionalField:(WCFormRowField *)fractionalField;
@end
