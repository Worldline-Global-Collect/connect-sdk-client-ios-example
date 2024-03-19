//
//  WCFormRowQRCode.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 14/07/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import "WCFormRowImage.h"

@interface WCFormRowQRCode : WCFormRowImage
- (instancetype)initWithString:(NSString *)base64EncodedString;
- (instancetype)initWithData:(NSData *)data;
@end
