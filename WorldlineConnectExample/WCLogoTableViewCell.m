//
//  WCLogoTableViewCell.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 14/07/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import "WCLogoTableViewCell.h"
static CGFloat kWCLogoTableViewCellWidth = 140;
@implementation WCLogoTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
    }
    return self;
}
+(NSString *)reuseIdentifier {
    return @"logo-cell";
}
-(CGSize)cellSizeWithWidth:(CGFloat)width {
    return CGSizeMake(kWCLogoTableViewCellWidth, [self sizeTransformedFrom:self.displayImageView.image.size toTargetWidth:kWCLogoTableViewCellWidth].height);
}
-(void)layoutSubviews {
    CGFloat newWidth = kWCLogoTableViewCellWidth;
    CGFloat newHeigh = [self sizeTransformedFrom:self.displayImage.size toTargetWidth:kWCLogoTableViewCellWidth].height;
    
    self.displayImageView.frame = CGRectMake(CGRectGetMidX(self.frame) - newWidth/2, 0, newWidth, newHeigh);
}
@end
