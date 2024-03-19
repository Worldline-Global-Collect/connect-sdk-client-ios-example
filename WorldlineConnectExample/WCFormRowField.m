//
//  WCFormRowField.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 11/05/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import "WCFormRowField.h"

@implementation WCFormRowField

- (instancetype _Nonnull)initWithText: (nonnull NSString *)text placeholder: (nonnull NSString *)placeholder keyboardType: (UIKeyboardType)keyboardType isSecure: (BOOL)isSecure {
    self = [super init];
    
    if (self) {
        self.text = text;
        self.placeholder = placeholder;
        self.keyboardType = keyboardType;
        self.isSecure = isSecure;
    }
    
    return self;
}

@end
