//
//  WCParseJsonTarget.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 22/04/2021.
//  Copyright (c) 2021 Worldline Global Collect. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WCStartPaymentParsedJsonData;

@protocol WCParseJsonTarget <NSObject>
- (void)success:(WCStartPaymentParsedJsonData *) sessionData;
@end
