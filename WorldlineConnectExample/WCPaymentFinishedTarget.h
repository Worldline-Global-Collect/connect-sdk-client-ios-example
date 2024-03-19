//
//  WCPaymentFinishedTarget.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//
#import <WorldlineConnectSDK/WCPreparedPaymentRequest.h>

#ifndef WCPaymentFinishedTarget_h
#define WCPaymentFinishedTarget_h

@protocol WCPaymentFinishedTarget <NSObject>

- (void)didFinishPayment:(WCPreparedPaymentRequest *)preparedPaymentRequest;

@end

#endif /* WCPaymentFinishedTarget_h */
