//
//  WCViewFactory.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WorldlineConnectExample/WCViewType.h>
#import <WorldlineConnectExample/WCTableViewCell.h>
#import <WorldlineConnectExample/WCSwitch.h>
#import <WorldlineConnectExample/WCTextField.h>
#import <WorldlineConnectExample/WCPickerView.h>
#import <WorldlineConnectExample/WCLabel.h>
#import <WorldlineConnectExample/WCButton.h>

@interface WCViewFactory : NSObject

- (WCButton *)buttonWithType:(WCButtonType)type;
- (WCSwitch *)switchWithType:(WCViewType)type;
- (WCTextField *)textFieldWithType:(WCViewType)type;
- (WCPickerView *)pickerViewWithType:(WCViewType)type;
- (WCLabel *)labelWithType:(WCViewType)type;
- (UIView *)tableHeaderViewWithType:(WCViewType)type frame:(CGRect)frame;

@end
