//
//  Header.h
//  WorldlineConnectExample
// 
//  Created for Worldline Global Collect on 15/09/2026.
//  Copyright © 2026 Worldline Global Collect. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Lightweight native replacement for SVProgressHUD.
/// Mirrors the subset of the SVProgressHUD API used in this example app.
@interface WCProgressView : NSObject

+ (void)showWithStatus:(nullable NSString *)status;
+ (void)dismiss;

@end

NS_ASSUME_NONNULL_END
