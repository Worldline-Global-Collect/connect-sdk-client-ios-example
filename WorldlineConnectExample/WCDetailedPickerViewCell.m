//
//  WCDetailedPickerViewCell.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 03/08/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import "WCDetailedPickerViewCell.h"
#import <WorldlineConnectSDK/WCDisplayElement.h>
#import <UIKit/UIKit.h>
#import <WorldlineConnectSDK/WCSDKConstants.h>
@interface WCDetailedPickerViewCell ()
@property (nonatomic, strong) UITextView *labelView;
@property (nonatomic, weak) NSObject<UIPickerViewDelegate> *transitiveDelegate;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, assign) BOOL labelNeedsUpdate;
@end
@implementation WCDetailedPickerViewCell
-(NSObject<UIPickerViewDelegate> *)delegate
{
    return self.transitiveDelegate;
}
-(void)setDelegate:(NSObject<UIPickerViewDelegate> *)delegate
{
    self.transitiveDelegate = delegate;
}
-(NSString *)errorMessage {
    return self.errorLabel.text;
}
-(void)setErrorMessage:(NSString *)errorMessage {
    self.errorLabel.text = errorMessage;
    [self setNeedsLayout];
}
-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.delegate) {
        return [self.delegate pickerView:pickerView attributedTitleForRow:row forComponent:component];
    }
    return nil;
}
-(void)setSelectedRow:(NSInteger)selectedRow {
    [super setSelectedRow:selectedRow];
    
    // We need to update the label later, when the width is known
    if (!self.labelNeedsUpdate) {
        [self updateLabelWithRow:selectedRow];

    }
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [super setDelegate:self];
        self.labelView = [[UITextView alloc]init];
        self.labelView.editable = NO;
        self.labelView.scrollEnabled = NO;
        self.labelView.dataDetectorTypes = UIDataDetectorTypeLink;
        self.clipsToBounds = YES;
        
        [self addSubview:self.labelView];
        
        self.errorLabel = [[UILabel alloc]init];
        self.errorLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        self.errorLabel.numberOfLines = 0;
        self.errorLabel.textColor = [UIColor redColor];
        
        [self addSubview:self.errorLabel];
        
        // We need to populate the textView, but we need the width for it,
        // and the width is only known after -layoutSubViews is called
        self.labelNeedsUpdate = YES;
        [self setNeedsLayout];

    }
    return self;
}
-(NSAttributedString *)labelForRow:(NSInteger)row {
    if (self.items[row].displayElements.count < 2) {
        return [[NSAttributedString alloc]init];
    }
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.tabStops = @[[[NSTextTab alloc]initWithTextAlignment:NSTextAlignmentRight location:[self accessoryAndMarginCompatibleWidth] - 10  options:@{}]];
    NSMutableAttributedString *combiString = [[NSMutableAttributedString alloc]init];
    for (WCDisplayElement *el in self.items[row].displayElements) {
        NSAttributedString *attributedEl = [self attributedStringFromDisplayElement:el];
        if (combiString.length > 0) {
            [combiString appendAttributedString:[[NSAttributedString alloc]initWithString:@"\n"]];
        }
        [combiString appendAttributedString:attributedEl];
    }
    [combiString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, (combiString.length))];
    return combiString;
}

-(void)updateLabelWithRow:(NSInteger)row {
    self.labelNeedsUpdate = NO;
    NSAttributedString *combiString = [self labelForRow:row];
    self.labelView.attributedText = combiString;
    [self.labelView sizeToFit];
    [self setNeedsLayout];
}
-(NSAttributedString *)attributedStringFromDisplayElement:(WCDisplayElement *)element {
    NSMutableAttributedString *returnValue = [[NSMutableAttributedString alloc]init];
    NSAttributedString *left;
    NSAttributedString *right;
    NSString *elementKey = [NSString stringWithFormat:@"gc.general.paymentProductFields.%@.fields.%@.label",self.fieldIdentifier , element.identifier];
    NSString *elementId = NSLocalizedStringWithDefaultValue(elementKey, kWCSDKLocalizable, [NSBundle bundleWithPath:kWCSDKBundlePath], element.identifier, @"");
    switch (element.type) {
        case WCDisplayElementTypeCurrency:
            left = [[NSAttributedString alloc]initWithString:elementId];
            right = [[NSAttributedString alloc]initWithString:[self.currencyFormatter stringFromNumber:[NSNumber numberWithDouble:[element.value doubleValue]/100]]];
            break;
        case WCDisplayElementTypePercentage:
            left = [[NSAttributedString alloc]initWithString:elementId];
            right = [[NSAttributedString alloc]initWithString:[self.percentFormatter stringFromNumber:[NSNumber numberWithDouble:[element.value doubleValue]/100]]];
            break;
        case WCDisplayElementTypeString:
            left = [[NSAttributedString alloc]initWithString:elementId];
            right = [[NSAttributedString alloc]initWithString:element.value];
            break;
        case WCDisplayElementTypeURI:
            left = [[NSAttributedString alloc]initWithString:elementId attributes:@{NSLinkAttributeName: element.value}];
            right = nil;
            break;
        case WCDisplayElementTypeInteger:
            left = [[NSAttributedString alloc]initWithString:elementId];
            right = [[NSAttributedString alloc]initWithString:element.value];
            break;
    }
    [returnValue appendAttributedString:left];
    if (right != nil) {
        [returnValue appendAttributedString:[[NSAttributedString alloc]initWithString:@"\t"]];
        [returnValue appendAttributedString:right];
    }
    return returnValue;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = [self accessoryAndMarginCompatibleWidth];
    CGFloat leftMargin = [self accessoryCompatibleLeftMargin];
    self.errorLabel.frame = CGRectMake(leftMargin, [WCDetailedPickerViewCell pickerHeight] + 5, width, 500);
    self.errorLabel.preferredMaxLayoutWidth = width - 20;
    [self.errorLabel sizeToFit];

    CGRect labelFrame = CGRectMake(leftMargin, [WCDetailedPickerViewCell pickerHeight] + 20, width, [WCDetailedPickerViewCell pickerHeight] );
    labelFrame.size.height = [self.labelView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)].height;
    self.labelView.frame = labelFrame;
    
    if (self.labelNeedsUpdate) {
        [self updateLabelWithRow:self.selectedRow];
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self updateLabelWithRow: row];
    if (self.transitiveDelegate) {
        [self.transitiveDelegate pickerView:pickerView didSelectRow:row inComponent:component];
    }
}
@end
