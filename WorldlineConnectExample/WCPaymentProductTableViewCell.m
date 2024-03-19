//
//  WCPaymentProductTableViewCell.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCPaymentProductTableViewCell.h>

@interface WCPaymentProductTableViewCell ()

@property (strong, nonatomic) UIImageView *logoContainer;
@property (strong, nonatomic) UIView *limitedContainer;
@property (strong, nonatomic) UILabel *label;
@end

@implementation WCPaymentProductTableViewCell

+ (NSString *)reuseIdentifier {
    return @"payment-product-selection-cell";
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.logoContainer = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.logoContainer.contentMode = UIViewContentModeScaleAspectFit;
        self.limitedContainer = [[UIView alloc]init];
        self.label = [[UILabel alloc]init];
        [self.contentView addSubview:self.limitedContainer];
        self.label.adjustsFontSizeToFitWidth = NO;
        self.label.lineBreakMode = NSLineBreakByTruncatingTail;
        self.clipsToBounds = YES;
        self.shouldHaveMaximalWidth = NO;
        self.limitedBackgroundColor = [UIColor whiteColor];
        [self.limitedContainer addSubview:self.logoContainer];
        [self.limitedContainer addSubview:self.label];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat width;
    CGFloat leftPadding;
    CGFloat height = self.contentView.frame.size.height;
    
    if (self.shouldHaveMaximalWidth) {
        width = [self accessoryAndMarginCompatibleWidth];
        leftPadding = [self accessoryCompatibleLeftMargin];
    }
    else {
        width = self.contentView.frame.size.width;
        leftPadding = self.contentView.layoutMargins.left;
    }
    int padding = 15;
    int logoWidth = 35;

    CGFloat rightPadding = self.contentView.layoutMargins.right;

    int textLabelX;
    if (self.logo != nil) {
        textLabelX = logoWidth + rightPadding;
        self.logoContainer.frame = CGRectMake(0, 5, logoWidth, height - 10);
    } else {
        textLabelX = leftPadding;
    }
    self.label.frame = CGRectMake(textLabelX, 0, width - textLabelX, height);
    self.limitedContainer.frame = CGRectMake(leftPadding, 0, width, height);
}
-(void)setLimitedBackgroundColor:(UIColor *)limitedBackgroundColor {
    _limitedBackgroundColor = limitedBackgroundColor;
    self.limitedContainer.backgroundColor = limitedBackgroundColor;
}
- (void)setLogo:(UIImage *)logo
{
    _logo = logo;
    [self.logoContainer setImage:logo];
}
- (void)setName:(NSString *)name
{
    _name = name;
    self.label.text = self.name;
}
-(void)prepareForReuse
{
    self.name = nil;
    self.logo = nil;
}
@end
