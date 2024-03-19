//
//  WCTextFieldTableViewCell.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//
#import <UIKit/UIKit.h>

#import <WorldlineConnectExample/WCTableViewCell.h>
#import <WorldlineConnectExample/WCTextField.h>
#import <WorldlineConnectExample/WCFormRowField.h>

@interface WCTextFieldTableViewCell : WCTableViewCell

+ (NSString *)reuseIdentifier;

- (UIView *)rightView;
- (void)setRightView:(UIView *)view;

- (NSString *)error;
- (void)setError:(NSString *)error;

- (NSObject<UITextFieldDelegate> *)delegate;
- (void)setDelegate:(NSObject<UITextFieldDelegate> *)delegate;

@property (strong, nonatomic) WCFormRowField *field;
@property (assign, nonatomic) BOOL readonly;
@end
