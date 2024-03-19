//
//  WCFormRowWithInfoButton.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCFormRow.h>
#import <WorldlineConnectExample/WCFormRowTooltip.h>

@interface WCFormRowWithInfoButton : WCFormRow

- (BOOL)showInfoButton;
@property (nonatomic, strong) WCFormRowTooltip *tooltip;

@end
