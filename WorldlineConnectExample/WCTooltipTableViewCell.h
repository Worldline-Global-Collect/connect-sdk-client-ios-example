//
//  WCTooltipTableViewCell.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCTableViewCell.h>
#import "WCFormRowTooltip.h"

@interface WCTooltipTableViewCell : WCTableViewCell

+ (NSString *)reuseIdentifier;

@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) UIImage *tooltipImage;
+ (CGSize)cellSizeForWidth:(CGFloat)width forFormRow:(WCFormRowTooltip *)label;
@end
