//
//  WCFormRowCurrency.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCFormRowCurrency.h>

@implementation WCFormRowCurrency
- (instancetype)initWithPaymentProductField:(WCPaymentProductField *)paymentProductField andIntegerField:(WCFormRowField *)integerField andFractionalField:(WCFormRowField *)fractionalField
{
    self = [super init];
    if (self) {
        self.paymentProductField = paymentProductField;
        self.integerField = integerField;
        self.fractionalField = fractionalField;
    }
    return self;
}
@end
