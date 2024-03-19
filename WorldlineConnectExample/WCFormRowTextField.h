//
//  WCFormRowTextField.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCFormRowWithInfoButton.h>
#import <WorldlineConnectExample/WCTextField.h>
#import <WorldlineConnectSDK/WCPaymentProductField.h>
#import <WorldlineConnectExample/WCFormRowField.h>

@interface WCFormRowTextField : WCFormRowWithInfoButton

- (instancetype _Nonnull)initWithPaymentProductField: (nonnull WCPaymentProductField *)paymentProductField field: (nonnull WCFormRowField*)field;

@property (strong, nonatomic) WCPaymentProductField * _Nonnull paymentProductField;
@property (strong, nonatomic) UIImage * _Nullable logo;
@property (strong, nonatomic) WCFormRowField * _Nonnull field;

@end
