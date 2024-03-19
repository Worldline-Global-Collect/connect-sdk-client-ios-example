//
//  WCCurrencyTableViewCell.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCTableViewCell.h>
#import <WorldlineConnectExample/WCIntegerTextField.h>
#import <WorldlineConnectExample/WCFractionalTextField.h>
#import "WCFormRowField.h"
@interface WCCurrencyTableViewCell : WCTableViewCell {
    BOOL _readonly;
}

+ (NSString *)reuseIdentifier;

@property (strong, nonatomic) WCFormRowField * integerField;
@property (strong, nonatomic) WCFormRowField * fractionalField;
@property (strong, nonatomic) NSString * currencyCode;
@property (assign, nonatomic) BOOL readonly;
@property(nonatomic,weak) id<UITextFieldDelegate> delegate;
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setIntegerField:(WCFormRowField *)integerField;
- (void)setFractionalField:(WCFormRowField *)fractionalField;
@end
