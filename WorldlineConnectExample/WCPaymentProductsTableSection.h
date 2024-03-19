//
//  WCPaymentProductsTableSection.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WCPaymentType.h"

@interface WCPaymentProductsTableSection : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSMutableArray *rows;
@property (nonatomic) WCPaymentType type;

@end
