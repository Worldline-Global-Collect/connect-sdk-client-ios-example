//
//  WCFormRowList.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCFormRowList.h>

@implementation WCFormRowList


- (instancetype _Nonnull)initWithPaymentProductField: (nonnull WCPaymentProductField *)paymentProductField {
    self = [super init];
    
    if (self) {
        self.items = [[NSMutableArray alloc]init];
        self.paymentProductField = paymentProductField;
    }
    
    return self;
}

@end
