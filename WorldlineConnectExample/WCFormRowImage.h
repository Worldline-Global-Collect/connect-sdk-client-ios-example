//
//  WCFormRowImage.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 14/07/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCFormRow.h"
@interface WCFormRowImage : WCFormRow
@property (nonatomic, retain) UIImage *image;
-(instancetype)initWithImage:(UIImage *)image;
@end
