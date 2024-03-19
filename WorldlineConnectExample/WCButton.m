//
//  WCButton.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 11/05/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import "WCButton.h"
#import <WorldlineConnectExample/WCAppConstants.h>

@implementation WCButton

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        self.type = WCButtonTypePrimary;
        self.layer.cornerRadius = 5;
    }
    
    return self;
}


- (void)setType:(WCButtonType)type {
    _type = type;
    switch (type) {
        case WCButtonTypePrimary:
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
            self.backgroundColor = kWCPrimaryColor;
            self.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
            break;
        case WCButtonTypeSecondary:
            [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self setTitleColor:[[UIColor grayColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
            self.backgroundColor = [UIColor clearColor];
            self.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
            break;
        case WCButtonTypeDestructive:
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
            self.backgroundColor = kWCDestructiveColor;
            self.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
            break;

    }
}

- (void)setEnabled:(BOOL)enabled {
    super.enabled = enabled;
    self.alpha = enabled ? 1 : 0.3;
}

@end
