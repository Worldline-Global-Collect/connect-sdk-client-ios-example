//
//  WCFormRowSwitch.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCFormRow.h>
#import <WorldlineConnectExample/WCSwitch.h>
#import <WorldlineConnectExample/WCFormRowWithInfoButton.h>

@interface WCFormRowSwitch : WCFormRowWithInfoButton

- (instancetype _Nonnull)initWithTitle: (nonnull NSString *) title isOn: (BOOL)isOn target: (nonnull id)target action: (nonnull SEL)action;
- (instancetype _Nonnull )initWithAttributedTitle: (nonnull NSAttributedString*) title isOn: (BOOL)isOn target: (nullable id)target action: (nullable SEL)action paymentProductField:(nullable WCPaymentProductField *)field;
@property (nonatomic, assign) BOOL isOn;
@property (strong, nonatomic) NSAttributedString * _Nonnull title;
@property (strong, nonatomic) id _Nullable target;
@property (assign, nonatomic) SEL _Nullable action;
@property (strong, nonatomic) WCPaymentProductField * _Nullable field;
@end
