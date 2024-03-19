//
//  WCPaymentProductInputData.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WCPaymentItem;
@class WCAccountOnFile;
@class WCPaymentRequest;

@interface WCPaymentProductInputData : NSObject

@property (strong, nonatomic) NSObject<WCPaymentItem> *paymentItem;
@property (strong, nonatomic) WCAccountOnFile *accountOnFile;
@property (nonatomic) BOOL tokenize;
@property (nonatomic, readonly, strong) NSArray *fields;
@property (strong, nonatomic) NSMutableArray *errors;

- (WCPaymentRequest *)paymentRequest;

- (BOOL)fieldIsPartOfAccountOnFile:(NSString *)paymentProductFieldId;
- (BOOL)fieldIsReadOnly:(NSString *)paymentProductFieldId;

- (void)setValue:(NSString *)value forField:(NSString *)paymentProductFieldId;
- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId;
- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId cursorPosition:(NSInteger *)cursorPosition;
- (NSString *)unmaskedValueForField:(NSString *)paymentProductFieldId;
- (void)validate;
- (void)validateExceptFields:(NSSet *)exceptionFields;
- (void)removeAllFieldValues;
@end
