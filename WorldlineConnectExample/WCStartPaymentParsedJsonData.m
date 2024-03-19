//
//  WCStartPaymentParsedJsonData.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 22/04/2021.
//  Copyright (c) 2021 Worldline Global Collect. All rights reserved.
//

#import "WCStartPaymentParsedJsonData.h"


@implementation WCStartPaymentParsedJsonData
- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (instancetype)initWithJSONString:(NSString *)JSONString {
    self = [super init];
    if (self) {
        NSError *error = nil;
        NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *JSONDictionary = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];

        if (!error && JSONDictionary) {
            [self setValuesForKeysWithDictionary:JSONDictionary];
        }
    }
    return self;
}
@end
