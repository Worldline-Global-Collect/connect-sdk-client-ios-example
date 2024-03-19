//
//  WCPaymentProductSelectionTarget.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCPaymentType.h>
#import <WorldlineConnectSDK/WCBasicPaymentProduct.h>
#import <WorldlineConnectSDK/WCAccountOnFile.h>

@protocol WCPaymentItem;

@protocol WCPaymentProductSelectionTarget <NSObject>

- (void)didSelectPaymentItem:(NSObject <WCBasicPaymentItem> *)paymentItem accountOnFile:(WCAccountOnFile *)accountOnFile;

@end
