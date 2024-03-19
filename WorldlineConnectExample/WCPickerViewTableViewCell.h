//
//  WCPickerViewTableViewCell.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCTableViewCell.h>
#import <WorldlineConnectExample/WCPickerView.h>
#import <WorldlineConnectSDK/WCValueMappingItem.h>
#import <WorldlineConnectSDK/WCPaymentProductField.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIPickerView.h>

@interface WCPickerViewTableViewCell : WCTableViewCell {
    BOOL _readonly;
}

+ (NSString *)reuseIdentifier;

@property (strong, nonatomic) NSArray<WCValueMappingItem *> *items;
@property (strong, nonatomic) NSObject<UIPickerViewDelegate> *delegate;
@property (strong, nonatomic) NSObject<UIPickerViewDataSource> *dataSource;
@property (assign, nonatomic) NSInteger selectedRow;
@property (assign, nonatomic) BOOL readonly;
+(NSUInteger)pickerHeight;
@end
