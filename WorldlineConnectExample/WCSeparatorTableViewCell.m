//
//  WCSeparatorTableViewCell.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 14/07/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import "WCSeparatorTableViewCell.h"
#import "WCSeparatorView.h"
@implementation WCSeparatorTableViewCell
+ (NSString *)reuseIdentifier
{
    return @"separator-cell";
}

- (void)setSeparatorText:(NSString *)text {
    self.view.separatorString = text;
}
- (NSString *)separatorText {
    return self.view.separatorString;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.view = [[WCSeparatorView alloc] init];
        [self addSubview:self.view];
        [self.view setOpaque:NO];
        self.clipsToBounds = YES;
        [self.view setContentMode:UIViewContentModeCenter];
        
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = [self accessoryAndMarginCompatibleWidth];
    CGFloat leftMargin = [self accessoryCompatibleLeftMargin];
    CGFloat newHeight = self.contentView.frame.size.height;
    self.view.frame = CGRectMake(leftMargin, 0, width, newHeight);
}
-(void)prepareForReuse {
    self.separatorText = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
