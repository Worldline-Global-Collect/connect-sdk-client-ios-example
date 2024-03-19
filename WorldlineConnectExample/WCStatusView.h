//
//  WCStatusView.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 14/07/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCStatusViewStatus.h"

@interface WCStatusView : UIView
@property (nonatomic, assign) WCStatusViewStatus status;
-(instancetype)initWithFrame:(CGRect)frame andStatus:(WCStatusViewStatus)status;
@end
