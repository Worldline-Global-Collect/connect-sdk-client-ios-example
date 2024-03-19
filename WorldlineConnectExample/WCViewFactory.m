//
//  WCViewFactory.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCViewFactory.h>
#import <WorldlineConnectExample/WCButtonTableViewCell.h>
#import <WorldlineConnectExample/WCSwitchTableViewCell.h>
#import <WorldlineConnectExample/WCErrorMessageTableViewCell.h>
#import <WorldlineConnectExample/WCLabelTableViewCell.h>
#import <WorldlineConnectExample/WCTooltipTableViewCell.h>
#import <WorldlineConnectExample/WCPaymentProductTableViewCell.h>
#import <WorldlineConnectExample/WCTextFieldTableViewCell.h>
#import <WorldlineConnectExample/WCPickerViewTableViewCell.h>
#import <WorldlineConnectExample/WCSummaryTableHeaderView.h>
#import <WorldlineConnectExample/WCIntegerTextField.h>
#import <WorldlineConnectExample/WCFractionalTextField.h>
#import <WorldlineConnectExample/WCCurrencyTableViewCell.h>
#import <WorldlineConnectExample/WCCoBrandsSelectionTableViewCell.h>
#import <WorldlineConnectExample/WCCOBrandsExplanationTableViewCell.h>

@implementation WCViewFactory

- (WCButton *)buttonWithType:(WCButtonType)type
{
    WCButton *button = [WCButton new];
    button.type = type;
    
    return button;
}

- (WCSwitch *)switchWithType:(WCViewType)type
{
    WCSwitch *switchControl;
    switch (type) {
        case WCSwitchType:
            switchControl = [[WCSwitch alloc] init];
            break;
        default:
            [NSException raise:@"Invalid switch type" format:@"Switch type %u is invalid", type];
            break;
    }
    return switchControl;
}

- (WCTextField *)textFieldWithType:(WCViewType)type
{
    WCTextField *textField;
    switch (type) {
        case WCTextFieldType:
            textField = [[WCTextField alloc] init];
            break;
        case WCIntegerTextFieldType:
            textField = [[WCIntegerTextField alloc] init];
            break;
        case WCFractionalTextFieldType:
            textField = [[WCFractionalTextField alloc] init];
            break;
        default:
            [NSException raise:@"Invalid text field type" format:@"Text field type %u is invalid", type];
            break;
    }
    return textField;
}

- (WCPickerView *)pickerViewWithType:(WCViewType)type
{
    WCPickerView *pickerView;
    switch (type) {
        case WCPickerViewType:
            pickerView = [[WCPickerView alloc] init];
            break;
        default:
            [NSException raise:@"Invalid picker view type" format:@"Picker view type %u is invalid", type];
            break;
    }
    return pickerView;
}

- (WCLabel *)labelWithType:(WCViewType)type
{
    WCLabel *label;
    switch (type) {
        case WCLabelType:
            label = [[WCLabel alloc] init];
            break;
        default:
            [NSException raise:@"Invalid label type" format:@"Label type %u is invalid", type];
            break;
    }
    return label;
}

- (UIView *)tableHeaderViewWithType:(WCViewType)type frame:(CGRect)frame
{
    UIView *view;
    switch (type) {
        case WCSummaryTableHeaderViewType:
            view = [[WCSummaryTableHeaderView alloc] initWithFrame:frame];
            break;
        default:
            [NSException raise:@"Invalid table header view type" format:@"Table header view type %u is invalid", type];
            break;
    }
    return view;
}

@end
