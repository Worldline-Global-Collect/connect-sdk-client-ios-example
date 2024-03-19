//
//  WCPaymentProductsTableRow.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCFormRow.h"

@interface WCPaymentProductsTableRow : WCFormRow

@property (strong, nonatomic) NSString *name;
@property (nonatomic) NSString *accountOnFileIdentifier;
@property (nonatomic) NSString *paymentProductIdentifier;
@property (strong, nonatomic) UIImage *logo;

@end
