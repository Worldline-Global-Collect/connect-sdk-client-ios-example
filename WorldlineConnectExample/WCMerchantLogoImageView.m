//
//  WCMerchantLogoImageView.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCMerchantLogoImageView.h>

@implementation WCMerchantLogoImageView

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, 20, 20)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *logo = [UIImage imageNamed:@"MerchantLogo"];
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.image = logo;
    }
    return self;
}

@end
