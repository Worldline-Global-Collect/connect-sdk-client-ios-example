//
//  WCFormRowField.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 11/05/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCFormRowField : NSObject

@property (strong, nonatomic)  NSString * _Nonnull text;
@property (strong, nonatomic) NSString * _Nonnull placeholder;
@property (assign, nonatomic) UIKeyboardType keyboardType;
@property (assign, nonatomic) BOOL isSecure;

- (instancetype _Nonnull)initWithText: (nonnull NSString *)text placeholder: (nonnull NSString *)placeholder keyboardType: (UIKeyboardType)keyboardType isSecure: (BOOL)isSecure;

@end
