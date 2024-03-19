//
//  WCPaymentProductTableViewCell.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCTableViewCell.h>

@interface WCPaymentProductTableViewCell : WCTableViewCell

+ (NSString *)reuseIdentifier;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIImage *logo;
@property (assign, nonatomic) BOOL shouldHaveMaximalWidth;
@property (strong, nonatomic) UIColor *limitedBackgroundColor;

@end
