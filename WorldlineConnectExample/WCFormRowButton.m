//
//  WCFormRowButton.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCFormRowButton.h>

@implementation WCFormRowButton


- (instancetype _Nonnull)initWithTitle: (nonnull NSString *) title target: (nonnull id)target action: (nonnull SEL)action {
    self = [super init];
    
    if (self) {
        self.buttonType = WCButtonTypePrimary;
        self.title = title;
        self.target = target;
        self.action = action;
    }
    
    return self;
}


@end
