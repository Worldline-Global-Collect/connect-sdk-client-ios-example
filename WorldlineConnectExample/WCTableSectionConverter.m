//
//  WCTableSectionConverter.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectSDK/WCSDKConstants.h>
#import <WorldlineConnectExample/WCTableSectionConverter.h>
#import <WorldlineConnectExample/WCPaymentProductsTableRow.h>
#import <WorldlineConnectSDK/WCPaymentItems.h>
#import <WorldlineConnectSDK/WCBasicPaymentProductGroup.h>

@implementation WCTableSectionConverter

+ (WCPaymentProductsTableSection *)paymentProductsTableSectionFromAccountsOnFile:(NSArray *)accountsOnFile paymentItems:(WCPaymentItems *)paymentItems
{
    WCPaymentProductsTableSection *section = [[WCPaymentProductsTableSection alloc] init];
    section.type = WCAccountOnFileType;
    for (WCAccountOnFile *accountOnFile in accountsOnFile) {
        id<WCBasicPaymentItem> product = [paymentItems paymentItemWithIdentifier:accountOnFile.paymentProductIdentifier];
        WCPaymentProductsTableRow *row = [[WCPaymentProductsTableRow alloc] init];
        NSString *displayName = [accountOnFile label];
        row.name = displayName;
        row.accountOnFileIdentifier = accountOnFile.identifier;
        row.paymentProductIdentifier = accountOnFile.paymentProductIdentifier;
        row.logo = product.displayHints.logoImage;
        [section.rows addObject:row];
    }
    return section;
}

+ (WCPaymentProductsTableSection *)paymentProductsTableSectionFromPaymentItems:(WCPaymentItems *)paymentItems
{
    NSBundle *sdkBundle = [NSBundle bundleWithPath:kWCSDKBundlePath];
    
    WCPaymentProductsTableSection *section = [[WCPaymentProductsTableSection alloc] init];
    for (NSObject<WCPaymentItem> *paymentItem in paymentItems.paymentItems) {
        section.type = WCPaymentProductType;
        WCPaymentProductsTableRow *row = [[WCPaymentProductsTableRow alloc] init];
        NSString *paymentProductKey = [self localizationKeyWithPaymentItem:paymentItem];
        NSString *paymentProductValue = NSLocalizedStringFromTableInBundle(paymentProductKey, kWCSDKLocalizable, sdkBundle, nil);
        row.name = paymentProductValue;
        row.accountOnFileIdentifier = @"";
        row.paymentProductIdentifier = paymentItem.identifier;
        row.logo = paymentItem.displayHints.logoImage;
        [section.rows addObject:row];
    }
    return section;
}

+ (NSString *)localizationKeyWithPaymentItem:(NSObject<WCBasicPaymentItem> *)paymentItem {
    if ([paymentItem isKindOfClass:[WCBasicPaymentProduct class]]) {
        return [NSString stringWithFormat:@"gc.general.paymentProducts.%@.name", paymentItem.identifier];
    }
    else if ([paymentItem isKindOfClass:[WCBasicPaymentProductGroup class]]) {
        return [NSString stringWithFormat:@"gc.general.paymentProductGroups.%@.name", paymentItem.identifier];
    }
    else {
        return @"";
    }
}

@end
