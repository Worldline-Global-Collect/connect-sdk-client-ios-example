//
//  WCFormRowList.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCFormRow.h>
#import <WorldlineConnectExample/WCPickerView.h>
#import <WorldlineConnectSDK/WCValueMappingItem.h>
#import <WorldlineConnectSDK/WCPaymentProductField.h>

@interface WCFormRowList : WCFormRow

- (instancetype _Nonnull)initWithPaymentProductField: (nonnull WCPaymentProductField *)paymentProductField;

@property (strong, nonatomic) NSMutableArray<WCValueMappingItem *> * _Nonnull items;
@property (nonatomic) NSInteger selectedRow;
@property (strong, nonatomic) WCPaymentProductField * _Nonnull paymentProductField;
@end
