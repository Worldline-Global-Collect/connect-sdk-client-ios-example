//
//  WCFormRowDate.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 09/10/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCFormRow.h"
#import <WorldlineConnectSDK/WCPaymentProductField.h>
@interface WCFormRowDate : WCFormRow
@property (strong, nonatomic) WCPaymentProductField * _Nonnull paymentProductField;
@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) NSDate *date;
@end
