//
//  WCFormRowLabel.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCFormRowWithInfoButton.h>
#import <WorldlineConnectExample/WCLabel.h>

@interface WCFormRowLabel : WCFormRowWithInfoButton

- (instancetype _Nonnull)initWithText:(nonnull NSString *)text;

@property (strong, nonatomic) NSString * _Nonnull text;

@property (assign, nonatomic, getter=isBold) BOOL bold;

@end
