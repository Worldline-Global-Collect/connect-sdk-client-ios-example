//
//  WCFormRowQRCode.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 14/07/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import "WCFormRowQRCode.h"
#import <CoreImage/CIFilter.h>
#import <WCBase64.h>
@implementation WCFormRowQRCode
- (instancetype)initWithString:(NSString *)base64EncodedString
{
    WCBase64 *converter = [[WCBase64 alloc]init];
    NSData *data = [converter decode:base64EncodedString];
    return [self initWithData:data];
}

- (instancetype)initWithData:(NSData *)data
{
    return [super initWithImage:[UIImage imageWithData:data]];
}
@end
