//
//  WCFormRowTooltip.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCFormRow.h>
#import <WorldlineConnectSDK/WCPaymentProductField.h>

@interface WCFormRowTooltip : WCFormRow

@property (strong, nonatomic) WCPaymentProductField *paymentProductField;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *text;

@end
