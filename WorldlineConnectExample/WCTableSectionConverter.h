//
//  WCTableSectionConverter.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WCPaymentProductsTableSection.h"
#import <WorldlineConnectSDK/WCBasicPaymentProducts.h>

@class WCPaymentItems;

@interface WCTableSectionConverter : NSObject

+ (WCPaymentProductsTableSection *)paymentProductsTableSectionFromAccountsOnFile:(NSArray *)accountsOnFile paymentItems:(WCPaymentItems *)paymentItems;
+ (WCPaymentProductsTableSection *)paymentProductsTableSectionFromPaymentItems:(WCPaymentItems *)paymentItems;

@end
