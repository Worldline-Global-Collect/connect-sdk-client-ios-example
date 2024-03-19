//
//  WCLabelTableViewCell.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCTableViewCell.h>
#import <WorldlineConnectExample/WCLabel.h>
@class WCFormRowLabel;
@interface WCLabelTableViewCell : WCTableViewCell
@property (assign, nonatomic, getter=isBold) BOOL bold;

+ (CGSize)cellSizeForWidth:(CGFloat)width forFormRow:(WCFormRowLabel *)label;
+ (NSString *)reuseIdentifier;


- (NSString *)label;
- (void)setLabel:(NSString *)label;

@end
