//
//  WCImageTableViewCell.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 14/07/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import "WCTableViewCell.h"

@interface WCImageTableViewCell : WCTableViewCell
@property (nonatomic, retain) UIImageView *displayImageView;
@property (nonatomic, retain) UIImage *displayImage;
+(NSString *)reuseIdentifier;

-(CGSize)sizeTransformedFrom:(CGSize)size toTargetWidth:(CGFloat)width;
    
-(CGSize)sizeTransformedFrom:(CGSize)size toTargetHeight:(CGFloat)height;

-(CGSize)cellSizeWithWidth:(CGFloat)width;
@end
