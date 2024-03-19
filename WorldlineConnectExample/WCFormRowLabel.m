//
//  WCFormRowLabel.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCFormRowLabel.h>

@implementation WCFormRowLabel

- (instancetype _Nonnull)initWithText:(nonnull NSString *)text {
    self = [super init];
    
    if (self) {
        self.text = text;
    }
    
    return self;
}

@end
