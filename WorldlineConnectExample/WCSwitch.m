//
//  WCSwitch.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCSwitch.h>
#import <WorldlineConnectExample/WCAppConstants.h>

@implementation WCSwitch

- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.onTintColor = kWCPrimaryColor;
    return self;
}

@end
