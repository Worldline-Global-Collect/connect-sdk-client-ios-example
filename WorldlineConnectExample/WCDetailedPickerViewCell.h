//
//  WCDetailedPickerViewCell.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 03/08/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCPickerViewTableViewCell.h"
@interface WCDetailedPickerViewCell : WCPickerViewTableViewCell <UIPickerViewDelegate>
@property (nonatomic, strong) NSNumberFormatter *currencyFormatter;
@property (nonatomic, strong) NSNumberFormatter *percentFormatter;
@property (nonatomic, strong) NSString *fieldIdentifier;
@property (nonatomic, strong) NSString *errorMessage;
@end
