//
//  WCSeparatorTableViewCell.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 14/07/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import "WCTableViewCell.h"
@class WCSeparatorView;
@interface WCSeparatorTableViewCell : WCTableViewCell
+ (NSString *)reuseIdentifier;
@property (nonatomic, strong) NSString *separatorText;
@property (nonatomic, strong) WCSeparatorView *view;
@end
