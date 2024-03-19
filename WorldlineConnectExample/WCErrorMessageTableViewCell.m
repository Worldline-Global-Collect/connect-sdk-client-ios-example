//
//  WCErrorMessageTableViewCell.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCErrorMessageTableViewCell.h>

@implementation WCErrorMessageTableViewCell

+ (NSString *)reuseIdentifier {
    return @"error-cell";
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:12.0f];
        self.textLabel.numberOfLines = 0;
        self.textLabel.textColor = [UIColor redColor];
        self.clipsToBounds = YES;
    }
    return self;
}

@end
