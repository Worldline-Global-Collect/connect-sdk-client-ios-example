//
//  WCTableViewCell.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCTableViewCell.h>

@implementation WCTableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
    }
    [self.contentView setUserInteractionEnabled: YES];
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [self initWithReuseIdentifier:reuseIdentifier];
    [self.contentView setUserInteractionEnabled: YES];
    return self;
}

- (CGFloat)accessoryAndMarginCompatibleWidth {
    if (self.accessoryType != UITableViewCellAccessoryNone) {
        if (self.contentView.frame.size.width > CGRectGetMidX(self.frame) - 320/2 + 320)
        {
            return 320;
        }
        else {
            return self.contentView.frame.size.width - 16;
        }
    }
    else {
        if(self.contentView.frame.size.width > CGRectGetMidX(self.frame) - 320/2 + 320 + 16 + 22 + 16) {
            return 320;
        }
        else {
            return self.contentView.frame.size.width - 16 - 16;
        }
    }
}

- (CGFloat)accessoryCompatibleLeftMargin {
    if (self.accessoryType != UITableViewCellAccessoryNone) {
        if (self.contentView.frame.size.width > CGRectGetMidX(self.frame) - 320/2 + 320)
        {
            return CGRectGetMidX(self.frame) - 320/2;
        }
        else {
            return 16;
        }
    }
    else {
        if (self.contentView.frame.size.width > CGRectGetMidX(self.frame) - 320/2 + 320 + 16 + 22 + 16) {
            return CGRectGetMidX(self.frame) - 320/2;
        }
        else {
            return 16;
        }
    }
}

@end
