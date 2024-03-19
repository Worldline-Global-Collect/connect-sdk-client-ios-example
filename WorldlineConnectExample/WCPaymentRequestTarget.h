//
//  WCPaymentRequestTarget.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WorldlineConnectSDK/WCPaymentRequest.h>

@protocol WCPaymentRequestTarget <NSObject>

- (void)didSubmitPaymentRequest:(WCPaymentRequest *)paymentRequest;
- (void)didCancelPaymentRequest;

@end
