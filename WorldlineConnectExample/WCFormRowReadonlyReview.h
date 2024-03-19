//
//  WCFormRowReadonlyReview.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 03/08/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WCFormRow.h"

@interface WCFormRowReadonlyReview : WCFormRow
@property (strong, nonatomic) NSDictionary<NSString *, NSString *> *data;
@end
