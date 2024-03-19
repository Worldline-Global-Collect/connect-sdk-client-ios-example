//
//  WCButtonTableViewCell.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCButtonTableViewCell.h>

@interface WCButtonTableViewCell ()

@property (strong, nonatomic) WCButton *button;

@end

@implementation WCButtonTableViewCell
+ (NSString *)reuseIdentifier {
    return @"button-cell";
}

- (WCButtonType)buttonType {
    return self.button.type;
}
- (void)setButtonType:(WCButtonType)type {
    self.button.type = type;
}

- (BOOL)isEnabled {
    return self.button.enabled;
}

- (void)setIsEnabled:(BOOL)enabled {
    self.button.enabled = enabled;
}

- (NSString *)title {
    return [self.button titleForState:UIControlStateNormal];
}
- (void)setTitle:(NSString *)title {
    [self.button setTitle:title forState:UIControlStateNormal];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.button = [[WCButton alloc] init];
        [self addSubview:self.button];
        self.buttonType = WCButtonTypePrimary;
        self.clipsToBounds = YES;
    }
    return self;
}


- (void)setClickTarget:(id)target action:(SEL)action {
    [self.button removeTarget: nil action: nil forControlEvents:UIControlEventAllEvents];
    [self.button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = self.contentView.frame.size.height;
    CGFloat width = [self accessoryAndMarginCompatibleWidth];
    CGFloat leftMargin = [self accessoryCompatibleLeftMargin];
    
    self.button.frame = CGRectMake(leftMargin, self.buttonType == WCButtonTypePrimary ? 12 : 6, width, height - 12);
}

- (void)prepareForReuse {
    [self.button removeTarget: nil action: nil forControlEvents:UIControlEventAllEvents];
}

@end
