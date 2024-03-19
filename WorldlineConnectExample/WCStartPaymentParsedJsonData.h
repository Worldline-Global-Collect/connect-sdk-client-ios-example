//
//  WCStartPaymentParsedJsonData.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 22/04/2021.
//  Copyright (c) 2021 Worldline Global Collect. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WCStartPaymentParsedJsonData : NSObject

@property NSString *customerId;
@property NSString *clientSessionId;
@property NSString *clientApiUrl;
@property NSString *assetUrl;
@property NSArray *invalidTokens;
@property NSString *region;

- (instancetype)initWithJSONString:(NSString *)JSONString;

@end
