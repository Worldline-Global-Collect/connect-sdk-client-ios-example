//
//  WCTableViewCell.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCTableViewCell : UITableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (CGFloat)accessoryAndMarginCompatibleWidth;
- (CGFloat)accessoryCompatibleLeftMargin;
@end

#import <WorldlineConnectExample/WCTooltipTableViewCell.h>
#import <WorldlineConnectExample/WCPaymentProductTableViewCell.h>
#import <WorldlineConnectExample/WCPickerViewTableViewCell.h>
#import <WorldlineConnectExample/WCSwitchTableViewCell.h>
#import <WorldlineConnectExample/WCTextFieldTableViewCell.h>
#import <WorldlineConnectExample/WCButtonTableViewCell.h>
#import <WorldlineConnectExample/WCErrorMessageTableViewCell.h>
#import <WorldlineConnectExample/WCLabelTableViewCell.h>
#import <WorldlineConnectExample/WCCurrencyTableViewCell.h>
#import <WorldlineConnectExample/WCCoBrandsSelectionTableViewCell.h>
#import <WorldlineConnectExample/WCCOBrandsExplanationTableViewCell.h>
