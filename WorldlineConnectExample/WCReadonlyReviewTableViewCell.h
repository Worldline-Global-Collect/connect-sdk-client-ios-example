//
//  WCReadonlyReviewCell.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 30/08/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCTableViewCell.h"
@interface WCReadonlyReviewTableViewCell : WCTableViewCell
@property (nonatomic, retain) NSDictionary<NSString *, NSString *> *data;
+(NSString *)reuseIdentifier;
+(CGFloat)cellHeightForData:(NSDictionary<NSString *, NSString *> *)data inWidth:(CGFloat)width;
@end
