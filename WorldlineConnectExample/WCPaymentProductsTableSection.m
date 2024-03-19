//
//  WCPaymentProductsTableSection.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCPaymentProductsTableSection.h>

@implementation WCPaymentProductsTableSection

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.rows = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
