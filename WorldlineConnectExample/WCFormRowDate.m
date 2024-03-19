//
//  WCFormRowDate.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 09/10/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import "WCFormRowDate.h"
@interface WCFormRowDate()
@end
@implementation WCFormRowDate
-(void)setValue:(NSString *)value {
    if ([value length] > 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyyMMdd";
        self.date = [formatter dateFromString:value];
        if (self.date == NULL) {
            self.date = [NSDate date];
        }
    }
    else {
        self.date = [NSDate date];
    }
}
@end
