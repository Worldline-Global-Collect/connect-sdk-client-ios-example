//
//  WCFormRowTextField.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCFormRowTextField.h>

@implementation WCFormRowTextField

- (instancetype _Nonnull)initWithPaymentProductField: (nonnull WCPaymentProductField *)paymentProductField field: (nonnull WCFormRowField*)field {
    self = [super init];
    
    if (self) {
        self.paymentProductField = paymentProductField;
        self.field = field;
    }
    
    return self;
}


@end
