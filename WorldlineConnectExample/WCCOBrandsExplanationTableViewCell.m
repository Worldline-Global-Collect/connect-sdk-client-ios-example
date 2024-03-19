//
//  WCCOBrandsExplanationTableViewCell.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCCOBrandsExplanationTableViewCell.h>
#import <WorldlineConnectSDK/WCSDKConstants.h>
@interface WCCOBrandsExplanationTableViewCell ()

@property (nonatomic, strong) UIView *limitedBackgroundView;

@end
@implementation WCCOBrandsExplanationTableViewCell

+ (NSString *)reuseIdentifier {
    return @"co-brand-explanation-cell";
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.limitedBackgroundView = [[UIView alloc]init];
        self.textLabel.attributedText = [WCCOBrandsExplanationTableViewCell cellString];
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 0;
        self.clipsToBounds = YES;
        [self.limitedBackgroundView addSubview:self.textLabel];
        self.limitedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self.contentView addSubview:self.limitedBackgroundView];
    }

    return self;
}

+ (NSAttributedString *)cellString {
    UIFont *font = [UIFont systemFontOfSize:12];
    NSDictionary *fontAttribute = @{
            NSFontAttributeName: font
    };
    NSBundle *sdkBundle = [NSBundle bundleWithPath:kWCSDKBundlePath];
    NSString *cellKey = @"gc.general.cobrands.introText";
    NSString *cellString = NSLocalizedStringFromTableInBundle(cellKey, kWCSDKLocalizable, sdkBundle, nil);
    NSAttributedString *cellStringWithFont = [[NSAttributedString alloc] initWithString:cellString
                                                                             attributes:fontAttribute];
    return cellStringWithFont;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = [super accessoryAndMarginCompatibleWidth];
    CGFloat leftMargin = [super accessoryCompatibleLeftMargin];
    self.limitedBackgroundView.frame = CGRectMake(leftMargin, 4, width, self.textLabel.frame.size.height);
    self.textLabel.frame = self.limitedBackgroundView.bounds;
}

@end
