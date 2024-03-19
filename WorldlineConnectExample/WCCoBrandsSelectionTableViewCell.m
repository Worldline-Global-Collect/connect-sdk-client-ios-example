//
//  WCCoBrandsSelectionTableViewCell.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCCoBrandsSelectionTableViewCell.h>
#import <WorldlineConnectSDK/WCSDKConstants.h>

@implementation WCCoBrandsSelectionTableViewCell

+ (NSString *)reuseIdentifier {
    return @"co-brand-selection-cell";
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        UIFont *font = [UIFont systemFontOfSize:13];
        NSDictionary *underlineAttribute = @{
                NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                NSFontAttributeName: font
        };

        NSBundle *sdkBundle = [NSBundle bundleWithPath:kWCSDKBundlePath];
        NSString *cobrandsKey = @"gc.general.cobrands.toggleCobrands";
        NSString *cobrandsString = NSLocalizedStringFromTableInBundle(cobrandsKey, kWCSDKLocalizable, sdkBundle, nil);
        self.textLabel.attributedText = [[NSAttributedString alloc] initWithString:cobrandsString
                                                                 attributes:underlineAttribute];
        self.textLabel.textAlignment = NSTextAlignmentRight;
        
        self.clipsToBounds = YES;
    }

    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = [super accessoryAndMarginCompatibleWidth];
    CGFloat leftMargin = [super accessoryCompatibleLeftMargin];
    self.textLabel.frame = CGRectMake(leftMargin, 4, width, self.textLabel.frame.size.height);;
}

@end
