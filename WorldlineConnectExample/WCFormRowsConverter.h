//
//  WCFormRowsConverter.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WorldlineConnectSDK/WCPaymentRequest.h>
#import <WorldlineConnectExample/WCViewFactory.h>
#import <WorldlineConnectExample/WCFormRowErrorMessage.h>
#import <WorldlineConnectSDK/WCValidationError.h>

@class WCIINDetailsResponse;
@class WCPaymentProductInputData;

@interface WCFormRowsConverter : NSObject

+ (NSString *)errorMessageForError:(WCValidationError *)error withCurrency:(BOOL)forCurrency;

- (NSMutableArray *)formRowsFromInputData:(WCPaymentProductInputData *)inputData viewFactory:(WCViewFactory *)viewFactory confirmedPaymentProducts:(NSSet *)confirmedPaymentProducts;

@end
