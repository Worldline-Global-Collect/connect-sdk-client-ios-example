//
//  WCFormRowSeparator.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 14/07/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import "WCFormRowSeparator.h"

@implementation WCFormRowSeparator
- (instancetype)initWithText:(NSString *)text
{
    self = [super init];
    if (self) {
        _text = text;
    }
    return self;
}
@end
