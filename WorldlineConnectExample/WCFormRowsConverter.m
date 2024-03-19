//
//  WCFormRowsConverter.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectSDK/WCSDKConstants.h>
#import <WorldlineConnectSDK/WCValidator.h>
#import <WorldlineConnectExample/WCFormRowsConverter.h>
#import <WorldlineConnectExample/WCFormRowList.h>
#import <WorldlineConnectExample/WCFormRowTextField.h>
#import <WorldlineConnectExample/WCFormRowSwitch.h>
#import <WorldlineConnectExample/WCPaymentProductInputData.h>
#import <WorldlineConnectExample/WCFormRowCurrency.h>
#import <WorldlineConnectSDK/WCIINDetailsResponse.h>
#import <WorldlineConnectExample/WCFormRowLabel.h>
#import <WorldlineConnectSDK/WCValidationErrorLength.h>
#import <WorldlineConnectSDK/WCValidationErrorIBAN.h>
#import <WorldlineConnectSDK/WCValidationErrorRange.h>
#import <WorldlineConnectSDK/WCValidationErrorExpirationDate.h>
#import <WorldlineConnectSDK/WCValidationErrorFixedList.h>
#import <WorldlineConnectSDK/WCValidationErrorLuhn.h>
#import <WorldlineConnectSDK/WCValidationErrorRegularExpression.h>
#import <WorldlineConnectSDK/WCValidationErrorIsRequired.h>
#import <WorldlineConnectSDK/WCValueMappingItem.h>
#import <WorldlineConnectSDK/WCValidationErrorAllowed.h>
#import <WorldlineConnectSDK/WCValidationErrorEmailAddress.h>
#import <WorldlineConnectSDK/WCValidationErrorTermsAndConditions.h>
#import <WorldlineConnectSDK/WCResidentIdNumberError.h>

#import "WCFormRowDate.h"
@interface WCFormRowsConverter ()

+ (NSBundle *)sdkBundle;

@end

@implementation WCFormRowsConverter

static NSBundle * _sdkBundle;
+ (NSBundle *)sdkBundle {
    if (_sdkBundle == nil) {
        _sdkBundle = [NSBundle bundleWithPath:kWCSDKBundlePath];
    }
    return _sdkBundle;
}

- (instancetype)init
{
    self = [super init];
    
    return self;
}

- (NSMutableArray *)formRowsFromInputData:(WCPaymentProductInputData *)inputData viewFactory:(WCViewFactory *)viewFactory confirmedPaymentProducts:(NSSet *)confirmedPaymentProducts {
    NSMutableArray *rows = [[NSMutableArray alloc] init];
    for (WCPaymentProductField* field in inputData.paymentItem.fields.paymentProductFields) {
        WCFormRow *row;
        BOOL isPartOfAccountOnFile = [inputData fieldIsPartOfAccountOnFile:field.identifier];
        NSString *value;
        BOOL isEnabled;
        if (isPartOfAccountOnFile == YES) {
            NSString *mask = field.displayHints.mask;
            value = [inputData.accountOnFile maskedValueForField:field.identifier mask:mask];
            isEnabled = [inputData fieldIsReadOnly:field.identifier] == NO;
        } else {
            value = [inputData maskedValueForField:field.identifier];
            isEnabled = YES;
        }
        row = [self labelFormRowFromField:field paymentProduct:inputData.paymentItem.identifier viewFactory:viewFactory];
        [rows addObject:row];
        switch (field.displayHints.formElement.type) {
            case WCListType: {
                row = [self listFormRowFromField:field value:value isEnabled:isEnabled viewFactory:viewFactory];
                break;
            }
            case WCTextType: {
                row = [self textFieldFormRowFromField:field paymentItem:inputData.paymentItem value:value isEnabled:isEnabled confirmedPaymentProducts:confirmedPaymentProducts viewFactory:viewFactory];
                break;
            }
            case WCBoolType: {
                [rows removeLastObject]; // Label is integrated into switch field
                row = [self switchFormRowFromField: field paymentItem: inputData.paymentItem value: value isEnabled: isEnabled viewFactory: viewFactory];
                break;
            }
            case WCDateType: {
                row = [self dateFormRowFromField: field paymentItem: inputData.paymentItem value: value isEnabled: isEnabled viewFactory: viewFactory];
                break;

            }
            case WCCurrencyType: {
                row = [self currencyFormRowFromField:field paymentItem:inputData.paymentItem value:value isEnabled:isEnabled viewFactory:viewFactory];
                break;
            }
            default: {
                [NSException raise:@"Invalid form element type" format:@"Form element type %d is invalid", field.displayHints.formElement.type];
                break;
            }
        }
        [rows addObject:row];
//        if (validation == YES) {
//            if (field.errors.count > 0) {
//                row = [self errorFormRowWithError:field.errors.firstObject forCurrency:field.displayHints.formElement.type == WCCurrencyType];
//                [rows addObject:row];
//            } else if (iinDetailsResponse != nil && [field.identifier isEqualToString:@"cardNumber"]) {
//                WCValidationError *iinLookupError = [self errorWithIINDetails:iinDetailsResponse];
//                if (iinLookupError != nil) {
//                    row = [self errorFormRowWithError:iinLookupError forCurrency:field.displayHints.formElement.type == WCCurrencyType];
//                    [rows addObject:row];
//                }
//            }
//        }
    }
    return rows;
}

- (WCValidationError *)errorWithIINDetails:(WCIINDetailsResponse *)iinDetailsResponse {
    //Validation error
    if (iinDetailsResponse.status == WCExistingButNotAllowed) {
        return [WCValidationErrorAllowed new];
    } else if (iinDetailsResponse.status == WCUnknown) {
        return [WCValidationErrorLuhn new];
    }
    return nil;
}

+ (NSString *)errorMessageForError:(WCValidationError *)error withCurrency:(BOOL)forCurrency
{
    Class errorClass = [error class];
    NSString *errorMessageFormat = @"gc.general.paymentProductFields.validationErrors.%@.label";
    NSString *errorMessageKey;
    NSString *errorMessageValue;
    NSString *errorMessage;
    if (errorClass == [WCValidationErrorLength class]) {
        WCValidationErrorLength *lengthError = (WCValidationErrorLength *)error;
        if (lengthError.minLength == lengthError.maxLength) {
            errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"length.exact"];
        } else if (lengthError.minLength == 0 && lengthError.maxLength > 0) {
            errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"length.max"];
        } else if (lengthError.minLength > 0 && lengthError.maxLength > 0) {
            errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"length.between"];
        }
        NSString *errorMessageValueWithPlaceholders = NSLocalizedStringFromTableInBundle(errorMessageKey, kWCSDKLocalizable, self.sdkBundle, nil);
        NSString *errorMessageValueWithPlaceholder = [errorMessageValueWithPlaceholders stringByReplacingOccurrencesOfString:@"{maxLength}" withString:[NSString stringWithFormat:@"%ld", lengthError.maxLength]];
        errorMessage = [errorMessageValueWithPlaceholder stringByReplacingOccurrencesOfString:@"{minLength}" withString:[NSString stringWithFormat:@"%ld", lengthError.minLength]];
    } else if (errorClass == [WCValidationErrorRange class]) {
        WCValidationErrorRange *rangeError = (WCValidationErrorRange *)error;
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"length.between"];
        NSString *errorMessageValueWithPlaceholders = NSLocalizedStringFromTableInBundle(errorMessageKey, kWCSDKLocalizable, self.sdkBundle, nil);
        NSString *minString;
        NSString *maxString;
        if (forCurrency == YES) {
            minString = [NSString stringWithFormat:@"%.2f", (double)rangeError.minValue / 100];
            maxString = [NSString stringWithFormat:@"%.2f", (double)rangeError.maxValue / 100];
        } else {
            minString = [NSString stringWithFormat:@"%ld", (long)rangeError.minValue];
            maxString = [NSString stringWithFormat:@"%ld", (long)rangeError.maxValue];
        }
        NSString *errorMessageValueWithPlaceholder = [errorMessageValueWithPlaceholders stringByReplacingOccurrencesOfString:@"{minValue}" withString:minString];
        errorMessageValue = [errorMessageValueWithPlaceholder stringByReplacingOccurrencesOfString:@"{maxValue}" withString:maxString];
    } else if (errorClass == [WCValidationErrorExpirationDate class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"expirationDate"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kWCSDKLocalizable, [WCFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [WCValidationErrorFixedList class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"fixedList"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kWCSDKLocalizable, [WCFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [WCValidationErrorLuhn class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"luhn"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kWCSDKLocalizable, [WCFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [WCValidationErrorAllowed class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"allowedInContext"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kWCSDKLocalizable, [WCFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [WCValidationErrorEmailAddress class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"emailAddress"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kWCSDKLocalizable, [WCFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [WCValidationErrorIBAN class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"regularExpression"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kWCSDKLocalizable, [WCFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [WCValidationErrorRegularExpression class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"regularExpression"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kWCSDKLocalizable, [WCFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [WCValidationErrorTermsAndConditions class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"termsAndConditions"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kWCSDKLocalizable, [WCFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [WCValidationErrorIsRequired class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"required"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kWCSDKLocalizable, [WCFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [WCResidentIdNumberError class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"residentIdNumber"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kWCSDKLocalizable, [WCFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    }  else {
        [NSException raise:@"Invalid validation error" format:@"Validation error %@ is invalid", error];
    }
    return errorMessage;
}
- (WCFormRowTextField *)textFieldFormRowFromField:(WCPaymentProductField *)field paymentItem:(NSObject<WCPaymentItem> *)paymentItem value:(NSString *)value isEnabled:(BOOL)isEnabled confirmedPaymentProducts:(NSSet *)confirmedPaymentProducts viewFactory:(WCViewFactory *)viewFactory
{
    NSString *placeholderKey = [NSString stringWithFormat:@"gc.general.paymentProducts.%@.paymentProductFields.%@.placeholder", paymentItem.identifier, field.identifier];
    NSString *placeholderValue = NSLocalizedStringFromTableInBundle(placeholderKey, kWCSDKLocalizable, [WCFormRowsConverter sdkBundle], nil);
    if ([placeholderKey isEqualToString:placeholderValue] == YES) {
        placeholderKey = [NSString stringWithFormat:@"gc.general.paymentProductFields.%@.placeholder", field.identifier];
        placeholderValue = NSLocalizedStringFromTableInBundle(placeholderKey, kWCSDKLocalizable, [WCFormRowsConverter sdkBundle], nil);
    }
    
    UIKeyboardType keyboardType = UIKeyboardTypeDefault;
    if (field.displayHints.preferredInputType == WCIntegerKeyboard) {
        keyboardType = UIKeyboardTypeNumberPad;
    } else if (field.displayHints.preferredInputType == WCEmailAddressKeyboard) {
        keyboardType = UIKeyboardTypeEmailAddress;
    } else if (field.displayHints.preferredInputType == WCPhoneNumberKeyboard) {
        keyboardType = UIKeyboardTypePhonePad;
    }
    
    WCFormRowField *formField = [[WCFormRowField alloc] initWithText:value placeholder:placeholderValue keyboardType:keyboardType isSecure:field.displayHints.obfuscate];
    WCFormRowTextField *row = [[WCFormRowTextField alloc] initWithPaymentProductField:field field:formField];
    row.isEnabled = isEnabled;
    
    if ([field.identifier isEqualToString:@"cardNumber"] == YES) {
        if ([confirmedPaymentProducts member:paymentItem.identifier] != nil) {
            row.logo = paymentItem.displayHints.logoImage;
        }
        else {
            row.logo = nil;
        }
    }
    
    [self setTooltipForFormRow:row withField:field paymentItem:paymentItem];
    
    return row;
}

- (WCFormRowSwitch *)switchFormRowFromField:(WCPaymentProductField *)field paymentItem:(NSObject<WCPaymentItem> *)paymentItem value:(NSString *)value isEnabled:(BOOL)isEnabled viewFactory:(WCViewFactory *)viewFactory
{
    NSString *descriptionKey = [NSString stringWithFormat: @"gc.general.paymentProducts.%@.paymentProductFields.%@.label", paymentItem.identifier, field.identifier];
    NSString *descriptionValue = NSLocalizedStringWithDefaultValue(descriptionKey, kWCSDKLocalizable, [WCFormRowsConverter sdkBundle], nil, @"Accept {link}");
    NSString *labelKey = [NSString stringWithFormat: @"gc.general.paymentProducts.%@.paymentProductFields.%@.link.label", paymentItem.identifier, field.identifier];
    NSString *labelValue = NSLocalizedStringWithDefaultValue(labelKey, kWCSDKLocalizable, [WCFormRowsConverter sdkBundle], nil, @"");
    NSRange range = [descriptionValue rangeOfString:@"{link}"];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:descriptionValue];
    NSAttributedString *linkString = [[NSAttributedString alloc]initWithString:labelValue attributes:@{NSLinkAttributeName:field.displayHints.link.absoluteString}];
    [attrString replaceCharactersInRange:range withAttributedString:linkString];
    //NSString *labelString = [field.displayHints.label stringByReplacingOccurrencesOfString:@"{link}" withString:]]

    WCFormRowSwitch *row = [[WCFormRowSwitch alloc] initWithAttributedTitle:attrString isOn:[value isEqualToString:@"true"] target:nil action:NULL paymentProductField:field];
    row.isEnabled = isEnabled;

    return row;
}
- (WCFormRowDate *)dateFormRowFromField:(WCPaymentProductField *)field paymentItem:(NSObject<WCPaymentItem> *)paymentItem value:(NSString *)value isEnabled:(BOOL)isEnabled viewFactory:(WCViewFactory *)viewFactory
{
    WCFormRowDate *row = [[WCFormRowDate alloc] init];
    row.paymentProductField = field;
    row.isEnabled = isEnabled;
    row.value = value;
    return row;
}


- (WCFormRowCurrency *)currencyFormRowFromField:(WCPaymentProductField *)field paymentItem:(NSObject<WCPaymentItem> *)paymentItem value:(NSString *)value isEnabled:(BOOL)isEnabled viewFactory:(WCViewFactory *)viewFactory
{
    NSString *placeholderKey = [NSString stringWithFormat:@"gc.general.paymentProducts.%@.paymentProductFields.%@.placeholder", paymentItem.identifier, field.identifier];
    NSString *placeholderValue = NSLocalizedStringFromTableInBundle(placeholderKey, kWCSDKLocalizable, [WCFormRowsConverter sdkBundle], nil);
    if ([placeholderKey isEqualToString:placeholderValue] == YES) {
        placeholderKey = [NSString stringWithFormat:@"gc.general.paymentProductFields.%@.placeholder", field.identifier];
        placeholderValue = NSLocalizedStringFromTableInBundle(placeholderKey, kWCSDKLocalizable, [WCFormRowsConverter sdkBundle], nil);
    }
    
    WCFormRowCurrency *row = [[WCFormRowCurrency alloc] init];
    row.integerField = [[WCFormRowField alloc] init];
    row.fractionalField = [[WCFormRowField alloc] init];
    
    row.integerField.placeholder = placeholderValue;
    if (field.displayHints.preferredInputType == WCIntegerKeyboard) {
        row.integerField.keyboardType = UIKeyboardTypeNumberPad;
        row.fractionalField.keyboardType = UIKeyboardTypeNumberPad;
    } else if (field.displayHints.preferredInputType == WCEmailAddressKeyboard) {
        row.integerField.keyboardType = UIKeyboardTypeEmailAddress;
        row.fractionalField.keyboardType = UIKeyboardTypeEmailAddress;
    } else if (field.displayHints.preferredInputType == WCPhoneNumberKeyboard) {
        row.integerField.keyboardType = UIKeyboardTypePhonePad;
        row.fractionalField.keyboardType = UIKeyboardTypePhonePad;
    }
    
    long long integerPart = [value longLongValue] / 100;
    int fractionalPart = (int) llabs([value longLongValue] % 100);
    row.integerField.isSecure = field.displayHints.obfuscate;
    row.integerField.text = [NSString stringWithFormat:@"%lld", integerPart];
    row.fractionalField.isSecure = field.displayHints.obfuscate;
    row.fractionalField.text = [NSString stringWithFormat:@"%02d", fractionalPart];
    row.paymentProductField = field;

    row.isEnabled = isEnabled;
    [self setTooltipForFormRow:row withField:field paymentItem:paymentItem];
    
    return row;
}

- (void)setTooltipForFormRow:(WCFormRowWithInfoButton *)row withField:(WCPaymentProductField *)field paymentItem:(NSObject<WCPaymentItem> *)paymentItem
{
    if (field.displayHints.tooltip.imagePath != nil) {
        WCFormRowTooltip *tooltip = [WCFormRowTooltip new];
        NSString *tooltipTextKey = [NSString stringWithFormat:@"gc.general.paymentProducts.%@.paymentProductFields.%@.tooltipText", paymentItem.identifier, field.identifier];
        NSString *tooltipTextValue = NSLocalizedStringFromTableInBundle(tooltipTextKey, kWCSDKLocalizable, [WCFormRowsConverter sdkBundle], nil);
        if ([tooltipTextKey isEqualToString:tooltipTextValue] == YES) {
            tooltipTextKey = [NSString stringWithFormat:@"gc.general.paymentProductFields.%@.tooltipText", field.identifier];
            tooltipTextValue = NSLocalizedStringFromTableInBundle(tooltipTextKey, kWCSDKLocalizable, [WCFormRowsConverter sdkBundle], nil);
        }
        tooltip.text = tooltipTextValue;
        tooltip.image = field.displayHints.tooltip.image;
        row.tooltip = tooltip;
    }
}

- (WCFormRowList *)listFormRowFromField:(WCPaymentProductField *)field value:(NSString *)value isEnabled:(BOOL)isEnabled viewFactory:(WCViewFactory *)viewFactory
{
    WCFormRowList *row = [[WCFormRowList alloc] initWithPaymentProductField:field];
    
    NSInteger rowIndex = 0;
    NSInteger selectedRow = 0;
    for (WCValueMappingItem *item in field.displayHints.formElement.valueMapping) {
        if (item.value != nil) {
            if ([item.value isEqualToString:value]) {
                selectedRow = rowIndex;
            }
            [row.items addObject:item];
        }
        ++rowIndex;
    }

    row.selectedRow = selectedRow;
    row.isEnabled = isEnabled;
    return row;
}
- (NSString *)labelStringFormRowFromField:(WCPaymentProductField *)field paymentProduct:(NSString *)paymentProductId {
    NSString *labelKey = [NSString stringWithFormat:@"gc.general.paymentProducts.%@.paymentProductFields.%@.label", paymentProductId, field.identifier];
    NSString *labelValue = NSLocalizedStringFromTableInBundle(labelKey, kWCSDKLocalizable, [WCFormRowsConverter sdkBundle], nil);
    if ([labelKey isEqualToString:labelValue] == YES) {
        labelKey = [NSString stringWithFormat:@"gc.general.paymentProductFields.%@.label", field.identifier];
        labelValue = NSLocalizedStringFromTableInBundle(labelKey, kWCSDKLocalizable, [WCFormRowsConverter sdkBundle], nil);
    }
    return labelValue;
}
- (WCFormRowLabel *)labelFormRowFromField:(WCPaymentProductField *)field paymentProduct:(NSString *)paymentProductId viewFactory:(WCViewFactory *)viewFactory
{
    WCFormRowLabel *row = [[WCFormRowLabel alloc] init];
    NSString *labelValue = [self labelStringFormRowFromField:field paymentProduct:paymentProductId];
    row.text = labelValue;
    
    return row;
}

@end
