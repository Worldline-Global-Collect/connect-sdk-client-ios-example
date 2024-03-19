//
//  WCPaymentProductViewController.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCAppConstants.h>
#import <WorldlineConnectSDK/WCSDKConstants.h>
#import <WorldlineConnectExample/WCPaymentProductViewController.h>
#import <WorldlineConnectExample/WCFormRowsConverter.h>
#import <WorldlineConnectExample/WCFormRow.h>
#import <WorldlineConnectExample/WCFormRowTextField.h>
#import <WorldlineConnectExample/WCFormRowCurrency.h>
#import <WorldlineConnectExample/WCFormRowSwitch.h>
#import <WorldlineConnectExample/WCFormRowList.h>
#import <WorldlineConnectExample/WCFormRowButton.h>
#import <WorldlineConnectExample/WCFormRowLabel.h>
#import <WorldlineConnectExample/WCFormRowErrorMessage.h>
#import <WorldlineConnectExample/WCFormRowTooltip.h>
#import <WorldlineConnectExample/WCTableViewCell.h>
#import <WorldlineConnectExample/WCSummaryTableHeaderView.h>
#import <WorldlineConnectExample/WCMerchantLogoImageView.h>
#import <WorldlineConnectSDK/WCPaymentAmountOfMoney.h>
#import <WorldlineConnectExample/WCFormRowCoBrandsSelection.h>
#import <WorldlineConnectSDK/WCIINDetail.h>
#import <WorldlineConnectExample/WCPaymentProductsTableRow.h>
#import <WorldlineConnectSDK/WCSDKConstants.h>
#import <WorldlineConnectExample/WCFormRowCoBrandsExplanation.h>
#import <WorldlineConnectExample/WCPaymentProductInputData.h>
#import "WCFormRowReadonlyReview.h"
#import "WCReadonlyReviewTableViewCell.h"
#import "WCDatePickerTableViewCell.h"
#import "WCFormRowDate.h"
@interface WCPaymentProductViewController () <UITextFieldDelegate, WCDatePickerTableViewCellDelegate, WCSwitchTableViewCellDelegate>

@property (strong, nonatomic) NSMutableArray *tooltipRows;
@property (nonatomic) BOOL rememberPaymentDetails;
@property (strong, nonatomic) WCSummaryTableHeaderView *header;
@property (strong, nonatomic) UITextPosition *cursorPositionInCreditCardNumberTextField;
@property (nonatomic) BOOL validation;
@property (nonatomic, strong) WCIINDetailsResponse *iinDetailsResponse;
@property (nonatomic, assign) BOOL coBrandsCollapsed;
@property (strong, nonatomic) NSBundle *sdkBundle;

@end

@implementation WCPaymentProductViewController
- (instancetype)init

{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        self.sdkBundle = [NSBundle bundleWithPath:kWCSDKBundlePath];
        self.context.forceBasicFlow = YES;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([self.tableView respondsToSelector:@selector(setDelaysContentTouches:)] == YES) {
        self.tableView.delaysContentTouches = NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = [[WCMerchantLogoImageView alloc] init];
    
    self.rememberPaymentDetails = NO;
    
    [self initializeHeader];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)] == YES) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self initializeTapRecognizer];
    self.tooltipRows = [[NSMutableArray alloc] init];
    self.validation = NO;
    self.confirmedPaymentProducts = [[NSMutableSet alloc] init];
    
    self.inputData = [WCPaymentProductInputData new];
    self.inputData.paymentItem = self.paymentItem;
    self.inputData.accountOnFile = self.accountOnFile;
    if ([self.paymentItem isKindOfClass:[WCPaymentProduct class]]) {
        WCPaymentProduct *product = (WCPaymentProduct *) self.paymentItem;
        [self.confirmedPaymentProducts addObject:product.identifier];
        self.initialPaymentProduct = product;
    }
    
    [self initializeFormRows];
    [self addExtraRows];
    
    self.switching = NO;
    self.coBrandsCollapsed = YES;
    
    [self registerReuseIdentifiers];
}

- (void)registerReuseIdentifiers {
    [self.tableView registerClass:[WCTextFieldTableViewCell class] forCellReuseIdentifier:[WCTextFieldTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[WCButtonTableViewCell class] forCellReuseIdentifier:[WCButtonTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[WCCurrencyTableViewCell class] forCellReuseIdentifier:[WCCurrencyTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[WCSwitchTableViewCell class] forCellReuseIdentifier:[WCSwitchTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[WCDatePickerTableViewCell class] forCellReuseIdentifier:[WCDatePickerTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[WCLabelTableViewCell class] forCellReuseIdentifier:[WCLabelTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[WCPickerViewTableViewCell class] forCellReuseIdentifier:[WCPickerViewTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[WCReadonlyReviewTableViewCell class] forCellReuseIdentifier:[WCReadonlyReviewTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[WCErrorMessageTableViewCell class] forCellReuseIdentifier:[WCErrorMessageTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[WCTooltipTableViewCell class] forCellReuseIdentifier:[WCTooltipTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[WCPaymentProductTableViewCell class] forCellReuseIdentifier:[WCPaymentProductTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[WCCoBrandsSelectionTableViewCell class] forCellReuseIdentifier:[WCCoBrandsSelectionTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[WCCOBrandsExplanationTableViewCell class] forCellReuseIdentifier:[WCCOBrandsExplanationTableViewCell reuseIdentifier]];
}

- (void)initializeTapRecognizer
{
    UITapGestureRecognizer *tapScrollView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapped)];
    tapScrollView.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapScrollView];
}

- (void)tableViewTapped
{
//    for (WCFormRow *element in self.formRows) {
//        if ([element class] == [WCFormRowTextField class]) {
//            WCFormRowTextField *formRowTextField = (WCFormRowTextField *)element;
//            if ([formRowTextField.textField isFirstResponder] == YES) {
//                [formRowTextField.textField resignFirstResponder];
//            }
//        } else if ([element class] == [WCFormRowCurrency class]) {
//            WCFormRowCurrency *formRowCurrency = (WCFormRowCurrency *)element;
//            if ([formRowCurrency.integerTextField isFirstResponder] == YES) {
//                [formRowCurrency.integerTextField resignFirstResponder];
//            }
//            if ([formRowCurrency.fractionalTextField isFirstResponder] == YES) {
//                [formRowCurrency.fractionalTextField resignFirstResponder];
//            }
//        }
//    }
}

- (void)initializeHeader
{
    NSBundle *sdkBundle = [NSBundle bundleWithPath:kWCSDKBundlePath];
    self.header = (WCSummaryTableHeaderView *)[self.viewFactory tableHeaderViewWithType:WCSummaryTableHeaderViewType frame:CGRectMake(0, 0, self.tableView.frame.size.width, 80)];
    self.header.summary = [NSString stringWithFormat:@"%@:", NSLocalizedStringFromTableInBundle(@"gc.app.general.shoppingCart.total", kWCSDKLocalizable, sdkBundle, @"Description of the amount header.")];
    NSNumber *amountAsNumber = [[NSNumber alloc] initWithFloat:self.amount / 100.0];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencyCode:self.context.amountOfMoney.currencyCode];
    NSString *amountAsString = [numberFormatter stringFromNumber:amountAsNumber];
    self.header.amount = amountAsString;
    self.header.securePayment = NSLocalizedStringFromTableInBundle(@"gc.app.general.securePaymentText", kWCSDKLocalizable, sdkBundle, @"Text indicating that a secure payment method is used.");
    self.tableView.tableHeaderView = self.header;
}

- (void)addExtraRows
{
    // Add remember me switch
      WCFormRowSwitch *switchFormRow = [[WCFormRowSwitch alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"gc.app.paymentProductDetails.rememberMe", kWCSDKLocalizable, self.sdkBundle, @"Explanation of the switch for remembering payment information.") isOn:self.rememberPaymentDetails target:self action: @selector(switchChanged:)];
    switchFormRow.isEnabled = false;
    [self.formRows addObject:switchFormRow];
    
    WCFormRowTooltip *switchFormRowTooltip = [WCFormRowTooltip new];
    switchFormRowTooltip.text = NSLocalizedStringFromTableInBundle(@"gc.app.paymentProductDetails.rememberMe.tooltip", kWCSDKLocalizable, self.sdkBundle, @"");
    switchFormRow.tooltip = switchFormRowTooltip;
    [self.formRows addObject:switchFormRowTooltip];
    
    // Add pay and cancel button
    NSString *payButtonTitle = NSLocalizedStringFromTableInBundle(@"gc.app.paymentProductDetails.payButton", kWCSDKLocalizable, self.sdkBundle, @"");
    WCFormRowButton *payButtonFormRow = [[WCFormRowButton alloc] initWithTitle: payButtonTitle target: self action: @selector(payButtonTapped)];
    payButtonFormRow.isEnabled = [self.paymentItem isKindOfClass:[WCPaymentProduct class]];
    [self.formRows addObject:payButtonFormRow];
    
    NSString *cancelButtonTitle = NSLocalizedStringFromTableInBundle(@"gc.app.paymentProductDetails.cancelButton", kWCSDKLocalizable, self.sdkBundle, @"");
    WCFormRowButton *cancelButtonFormRow = [[WCFormRowButton alloc] initWithTitle: cancelButtonTitle target: self action: @selector(cancelButtonTapped)];
    cancelButtonFormRow.buttonType = WCButtonTypeSecondary;
    cancelButtonFormRow.isEnabled = true;
    [self.formRows addObject:cancelButtonFormRow];
}

- (void)initializeFormRows
{
    WCFormRowsConverter *mapper = [WCFormRowsConverter new];
    NSMutableArray *formRows = [mapper formRowsFromInputData: self.inputData viewFactory: self.viewFactory confirmedPaymentProducts: self.confirmedPaymentProducts];
    
    NSMutableArray *formRowsWithTooltip = [NSMutableArray new];
    for (WCFormRow *row in formRows) {
        [formRowsWithTooltip addObject:row];
        if (row != nil && [row isKindOfClass: [WCFormRowWithInfoButton class]]) {
            WCFormRowWithInfoButton *infoButtonRow = (WCFormRowWithInfoButton *)row;
            if (infoButtonRow.tooltip != nil) {
                WCFormRowTooltip *tooltipRow = infoButtonRow.tooltip;
                [formRowsWithTooltip addObject:tooltipRow];
            }
        }
    }
    
    self.formRows = formRowsWithTooltip;
}

- (void)updateFormRowsWithValidation:(BOOL)validation tooltipRows:(NSArray *)tooltipRows confirmedPaymentProducts:(NSSet *)confirmedPaymentProducts
{
//    WCFormRowsConverter *mapper = [[WCFormRowsConverter alloc] init];
//    NSArray *rows = [mapper formRowsFromInputData:self.inputData iinDetailsResponse:self.iinDetailsResponse validation:validation viewFactory:self.viewFactory confirmedPaymentProducts:confirmedPaymentProducts];
//    NSMutableArray *formRows = [[NSMutableArray alloc] initWithArray:rows];
//    
//    if ([self.paymentItem isKindOfClass:[WCPaymentProduct class]]) {
//        NSBundle *sdkBundle = [NSBundle bundleWithPath:kWCSDKBundlePath];
//        WCPaymentProduct *product = (WCPaymentProduct *) self.paymentItem;
//        if (product.allowsTokenization == YES && product.autoTokenized == NO && self.accountOnFile == nil) {
//            WCFormRowSwitch *switchFormRow = [[WCFormRowSwitch alloc] init];
//            switchFormRow.switchControl = (WCSwitch *) [self.viewFactory switchWithType:WCSwitchType];
//            switchFormRow.text = NSLocalizedStringFromTableInBundle(@"gc.app.paymentProductDetails.rememberMe", kWCSDKLocalizable, sdkBundle, @"Explanation of the switch for remembering payment information.");
//            switchFormRow.switchControl.on = self.rememberPaymentDetails;
//            
//            
//            switchFormRow.showInfoButton = YES;
//            switchFormRow.tooltipIdentifier = @"RememberMeTooltip";
//            switchFormRow.tooltipText = NSLocalizedStringFromTableInBundle(@"gc.app.paymentProductDetails.rememberMe.tooltip", kWCSDKLocalizable, sdkBundle, nil);
//            [formRows addObject:switchFormRow];
//        }
//    }
//    
//    NSMutableArray *formRowsWithTooltip = [NSMutableArray new];
//    for (WCFormRow *row in formRows) {
//        [formRowsWithTooltip addObject:row];
//        if ([row class] == [WCFormRowTextField class]) {
//            WCFormRowTextField *textFieldRow = (WCFormRowTextField *)row;
//            
//            if ([textFieldRow.paymentProductField.identifier isEqualToString:@"cardNumber"]) {
//                textFieldRow.textField.text = [textFieldRow.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//                [self addCoBrandFormsInFormRows:formRowsWithTooltip iinDetailsResponse:self.iinDetailsResponse];
//            }
//        }
//        if ([[row class] isSubclassOfClass:[WCFormRowWithInfoButton class]]) {
//            WCFormRowWithInfoButton *infoButtonRow = (WCFormRowWithInfoButton *)row;
//            for (WCFormRowTooltip *tooltipRow in tooltipRows) {
//                if ([tooltipRow.tooltipIdentifier isEqualToString:infoButtonRow.tooltipIdentifier]) {
//                    [formRowsWithTooltip addObject:tooltipRow];
//                }
//            }
//        }
//    }
//    
//    self.formRows = formRowsWithTooltip;
//    NSBundle *sdkBundle = [NSBundle bundleWithPath:kWCSDKBundlePath];
//    
//    WCFormRowButton *payButtonFormRow = [[WCFormRowButton alloc] init];
//    NSString *payButtonTitle = NSLocalizedStringFromTableInBundle(@"gc.app.paymentProductDetails.payButton", kWCSDKLocalizable, sdkBundle, @"Title of the pay button on the payment product screen.");
//    UIButton* payButton = [self.viewFactory buttonWithType:WCPrimaryButtonType];
//    [payButton setTitle:payButtonTitle forState:UIControlStateNormal];
//    [payButton addTarget:self action:@selector(payButtonTapped) forControlEvents:UIControlEventTouchUpInside];
//    payButtonFormRow.button = payButton;
//    [self.formRows addObject:payButtonFormRow];
//    
//    WCFormRowButton *cancelButtonFormRow = [[WCFormRowButton alloc] init];
//    NSString *cancelButtonTitle = NSLocalizedStringFromTableInBundle(@"gc.app.paymentProductDetails.cancelButton", kWCSDKLocalizable, sdkBundle, @"Title of the cancel button on the payment product screen.");
//    UIButton* cancelButton = [self.viewFactory buttonWithType:WCSecondaryButtonType];
//    [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
//    [cancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
//    cancelButtonFormRow.button = cancelButton;
//    [self.formRows addObject:cancelButtonFormRow];
}

- (void)addCoBrandFormsInFormRows:(NSMutableArray *)formRows iinDetailsResponse:(WCIINDetailsResponse *)iinDetailsResponse {
    NSMutableArray *coBrands = [NSMutableArray new];
    for (WCIINDetail *coBrand in iinDetailsResponse.coBrands) {
        if (coBrand.isAllowedInContext) {
            [coBrands addObject:coBrand.paymentProductId];
        }
    }
    if (coBrands.count > 1) {
        if (!self.coBrandsCollapsed) {
            NSBundle *sdkBundle = [NSBundle bundleWithPath:kWCSDKBundlePath];
            
            //Add explanation row
            WCFormRowCoBrandsExplanation *explanationRow = [WCFormRowCoBrandsExplanation new];
            [formRows addObject:explanationRow];
            
            //Add row for selection coBrands
            for (NSString *id in coBrands) {
                WCPaymentProductsTableRow *row = [[WCPaymentProductsTableRow alloc] init];
                row.paymentProductIdentifier = id;
                
                NSString *paymentProductKey = [NSString stringWithFormat:@"gc.general.paymentProducts.%@.name", id];
                NSString *paymentProductValue = NSLocalizedStringFromTableInBundle(paymentProductKey, kWCSDKLocalizable, sdkBundle, nil);
                row.name = paymentProductValue;
                
                WCAssetManager *assetManager = [WCAssetManager new];
                UIImage *logo = [assetManager logoImageForPaymentItem:id];
                row.logo = logo;
                
                [formRows addObject:row];
            }
        }
        
        WCFormRowCoBrandsSelection *toggleCoBrandRow = [WCFormRowCoBrandsSelection new];
        [formRows addObject:toggleCoBrandRow];
    }
}

-(void)switchToPaymentProduct:(NSString *)paymentProductId {
    if (paymentProductId != nil) {
        [self.confirmedPaymentProducts addObject:paymentProductId];
    }
    if (paymentProductId == nil) {
        if ([self.confirmedPaymentProducts containsObject:self.paymentItem.identifier]) {
            [self.confirmedPaymentProducts removeObject:self.paymentItem.identifier];
        }
        [self updateFormRows];
    }
    else if ([paymentProductId isEqualToString:self.paymentItem.identifier]) {
        [self updateFormRows];
    }
    else if (self.switching == NO) {
        self.switching = YES;
        [self.session paymentProductWithId:paymentProductId context:self.context success:^(WCPaymentProduct *paymentProduct) {
            self.paymentItem = paymentProduct;
            self.inputData.paymentItem = paymentProduct;
            [self updateFormRows];
            self.switching = NO;
        } failure:^(NSError *error) {
        }];
    }
}

-(void)updateFormRows {
    [self.tableView beginUpdates];
    for (int i = 0; i < self.formRows.count; i++) {
        WCFormRow *row = self.formRows[i];
        if ([row isKindOfClass:[WCFormRowTextField class]]) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (cell != nil && [cell isKindOfClass:[WCTextFieldTableViewCell class]]) {
                [self updateTextFieldCell: (WCTextFieldTableViewCell *)cell row: (WCFormRowTextField *)row];
            }
            
        } else if ([row isKindOfClass:[WCFormRowList class]]) {
            WCPickerViewTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [self updatePickerCell:cell row:row];
        } else if ([row isKindOfClass:[WCFormRowSwitch class]]) {
            if (((WCFormRowSwitch *)row).action == @selector(switchChanged:)) {
                row.isEnabled = self.paymentItem != nil && [self.paymentItem isKindOfClass:[WCBasicPaymentProduct class]] && ((WCBasicPaymentProduct *)self.paymentItem).allowsTokenization && !((WCBasicPaymentProduct *)self.paymentItem).autoTokenized && self.accountOnFile == nil;
                continue;
            }
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (cell != nil && [cell isKindOfClass:[WCSwitchTableViewCell class]]) {
                [self updateSwitchCell:(WCSwitchTableViewCell *)cell row:(WCFormRowSwitch *)row];
            }
        } else if ([row isKindOfClass:[WCFormRowButton class]] &&  ((WCFormRowButton *)row).action == @selector(payButtonTapped)) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (cell != nil && [cell isKindOfClass:[WCButtonTableViewCell class]]) {
                row.isEnabled = [self.paymentItem isKindOfClass:[WCPaymentProduct class]];
                [self updateButtonCell: (WCButtonTableViewCell *)cell row: (WCFormRowButton *)row];
            }
        }
    }
    [self.tableView endUpdates];
    
}

- (void)updateTextFieldCell:(WCTextFieldTableViewCell *)cell row: (WCFormRowTextField *)row {
    // Add error messages for cells
    WCValidationError *error = [row.paymentProductField.errors firstObject];
    cell.delegate = self;
    cell.accessoryType = row.showInfoButton ? UITableViewCellAccessoryDetailButton : UITableViewCellAccessoryNone;
    cell.field = row.field;
    cell.readonly = !row.isEnabled;
    if (error != nil) {
        cell.error = [WCFormRowsConverter errorMessageForError: error withCurrency: row.paymentProductField.displayHints.formElement.type == WCCurrencyType];
    } else {
        cell.error = nil;
    }
}

- (void)updateSwitchCell:(WCSwitchTableViewCell *)cell row: (WCFormRowSwitch *)row {
    // Add error messages for cells
    if (row.field == nil) {
        return;
    }
    WCValidationError *error = [row.field.errors firstObject];
    if (error != nil) {
        cell.errorMessage = [WCFormRowsConverter errorMessageForError: error withCurrency: NO];
    } else {
        cell.errorMessage = nil;
    }
}

- (void)updateButtonCell:(WCButtonTableViewCell *)cell row:(WCFormRowButton *)row {
    cell.isEnabled = row.isEnabled;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.formRows.count;
}

// TODO: indexPah argument is not used, maybe replace it with tableView
- (WCTableViewCell *)formRowCellForRow:(WCFormRow *)row atIndexPath:(NSIndexPath *)indexPath {
    Class class = [row class];
    WCTableViewCell *cell = nil;
    if (class == [WCFormRowTextField class]) {
        cell = [self cellForTextField:(WCFormRowTextField *)row tableView:self.tableView];
    } else if (class == [WCFormRowCurrency class]) {
        cell = [self cellForCurrency:(WCFormRowCurrency *) row tableView:self.tableView];
    } else if (class == [WCFormRowSwitch class]) {
        cell = [self cellForSwitch:(WCFormRowSwitch *)row tableView:self.tableView];
    } else if (class == [WCFormRowList class]) {
        cell = [self cellForList:(WCFormRowList *)row tableView:self.tableView];
    } else if (class == [WCFormRowButton class]) {
        cell = [self cellForButton:(WCFormRowButton *)row tableView:self.tableView];
    } else if (class == [WCFormRowLabel class]) {
        cell = [self cellForLabel:(WCFormRowLabel *)row tableView:self.tableView];
    } else if (class == [WCFormRowDate class]) {
        cell = [self cellForDatePicker:(WCFormRowDate *)row tableView:self.tableView];
    } else if (class == [WCFormRowErrorMessage class]) {
        cell = [self cellForErrorMessage:(WCFormRowErrorMessage *)row tableView:self.tableView];
    } else if (class == [WCFormRowTooltip class]) {
        cell = [self cellForTooltip:(WCFormRowTooltip *)row tableView:self.tableView];
    } else if (class == [WCFormRowCoBrandsSelection class]) {
        cell = [self cellForCoBrandsSelection:(WCFormRowCoBrandsSelection *)row tableView:self.tableView];
    } else if (class == [WCFormRowCoBrandsExplanation class]) {
        cell = [self cellForCoBrandsExplanation:(WCFormRowCoBrandsExplanation  *)row tableView:self.tableView];
    } else if (class == [WCPaymentProductsTableRow class]) {
        cell = [self cellForPaymentProduct:(WCPaymentProductsTableRow  *)row tableView:self.tableView];
    } else if (class == [WCFormRowReadonlyReview class]) {
        cell = [self cellForReadonlyReview:(WCFormRowReadonlyReview  *)row tableView:self.tableView];
    } else {
        [NSException raise:@"Invalid form row class" format:@"Form row class %@ is invalid", class];
    }
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WCFormRow *row = self.formRows[indexPath.row];
    WCTableViewCell *cell = [self formRowCellForRow:row atIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Helper methods for data source methods

- (WCReadonlyReviewTableViewCell *)cellForReadonlyReview:(WCFormRowReadonlyReview *)row tableView:(UITableView *)tableView
{
    WCReadonlyReviewTableViewCell *cell = (WCReadonlyReviewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[WCReadonlyReviewTableViewCell reuseIdentifier]];
    
    cell.data = row.data;
    return cell;
}

- (WCTextFieldTableViewCell *)cellForTextField:(WCFormRowTextField *)row tableView:(UITableView *)tableView
{
    WCTextFieldTableViewCell *cell = (WCTextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[WCTextFieldTableViewCell reuseIdentifier]];
    
    cell.field = row.field;
    cell.delegate = self;
    cell.readonly = !row.isEnabled;
    WCValidationError *error = [row.paymentProductField.errors firstObject];
    if (error != nil && self.validation) {
        cell.error = [WCFormRowsConverter errorMessageForError: error withCurrency: row.paymentProductField.displayHints.formElement.type == WCCurrencyType];
    }
    cell.accessoryType = row.showInfoButton ? UITableViewCellAccessoryDetailButton : UITableViewCellAccessoryNone;
    
    return cell;
}
- (WCDatePickerTableViewCell *)cellForDatePicker:(WCFormRowDate *)row tableView:(UITableView *)tableView
{
    WCDatePickerTableViewCell *cell = (WCDatePickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[WCDatePickerTableViewCell reuseIdentifier]];
    
    cell.delegate = self;
    cell.readonly = !row.isEnabled;
    cell.date = row.date;
    return cell;
}

- (WCCurrencyTableViewCell *)cellForCurrency:(WCFormRowCurrency *)row tableView:(UITableView *)tableView
{
    WCCurrencyTableViewCell *cell = (WCCurrencyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[WCCurrencyTableViewCell reuseIdentifier]];
    cell.integerField = row.integerField;
    cell.delegate = self;
    cell.fractionalField = row.fractionalField;
    cell.readonly = !row.isEnabled;
    cell.accessoryType = row.showInfoButton ? UITableViewCellAccessoryDetailButton : UITableViewCellAccessoryNone;
    return cell;
}

- (WCSwitchTableViewCell *)cellForSwitch:(WCFormRowSwitch *)row tableView:(UITableView *)tableView
{
    WCSwitchTableViewCell *cell = (WCSwitchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[WCSwitchTableViewCell reuseIdentifier]];
    cell.attributedTitle = row.title;
    [cell setSwitchTarget:row.target action:row.action];
    cell.on = row.isOn;
    cell.delegate = self;
    WCValidationError *error = [row.field.errors firstObject];
    if (error != nil && self.validation) {
        cell.errorMessage = [WCFormRowsConverter errorMessageForError: error withCurrency: 0];
    }
    cell.accessoryType = row.showInfoButton ? UITableViewCellAccessoryDetailButton : UITableViewCellAccessoryNone;
    return cell;
}

- (WCPickerViewTableViewCell *)cellForList:(WCFormRowList *)row tableView:(UITableView *)tableView
{
    WCPickerViewTableViewCell *cell = (WCPickerViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[WCPickerViewTableViewCell reuseIdentifier]];
    cell.items = row.items;
    cell.delegate = self;
    cell.dataSource = self;
    cell.selectedRow = row.selectedRow;
    cell.readonly = !row.isEnabled;
    return cell;
}

- (WCButtonTableViewCell *)cellForButton:(WCFormRowButton *)row tableView:(UITableView *)tableView
{
    WCButtonTableViewCell *cell = (WCButtonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[WCButtonTableViewCell reuseIdentifier]];
    cell.buttonType = row.buttonType;
    cell.isEnabled = row.isEnabled;
    cell.title = row.title;
    [cell setClickTarget:row.target action:row.action];
    return cell;
}

- (WCLabelTableViewCell *)cellForLabel:(WCFormRowLabel *)row tableView:(UITableView *)tableView
{
    WCLabelTableViewCell *cell = (WCLabelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[WCLabelTableViewCell reuseIdentifier]];
    cell.label = row.text;
    cell.bold = row.bold;
    cell.accessoryType = row.showInfoButton ? UITableViewCellAccessoryDetailButton : UITableViewCellAccessoryNone;
    return cell;
}

- (WCErrorMessageTableViewCell *)cellForErrorMessage:(WCFormRowErrorMessage *)row tableView:(UITableView *)tableView
{
    WCErrorMessageTableViewCell *cell = (WCErrorMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[WCErrorMessageTableViewCell reuseIdentifier]];
    cell.textLabel.text = row.text;
    return cell;
}

- (WCTooltipTableViewCell *)cellForTooltip:(WCFormRowTooltip *)row tableView:(UITableView *)tableView
{
    WCTooltipTableViewCell *cell = (WCTooltipTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[WCTooltipTableViewCell reuseIdentifier]];
    cell.label = row.text;
    cell.tooltipImage = row.image;
    return cell;
}

- (WCCoBrandsSelectionTableViewCell *)cellForCoBrandsSelection:(WCFormRowCoBrandsSelection *)row tableView:(UITableView *)tableView
{
    WCCoBrandsSelectionTableViewCell *cell = (WCCoBrandsSelectionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[WCCoBrandsSelectionTableViewCell reuseIdentifier]];
    return cell;
}


- (WCCOBrandsExplanationTableViewCell *)cellForCoBrandsExplanation:(WCFormRowCoBrandsExplanation *)row tableView:(UITableView *)tableView
{
    WCCOBrandsExplanationTableViewCell *cell = (WCCOBrandsExplanationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[WCCOBrandsExplanationTableViewCell reuseIdentifier]];
    return cell;
}

- (WCPaymentProductTableViewCell *)cellForPaymentProduct:(WCPaymentProductsTableRow *)row tableView:(UITableView *)tableView
{
    WCPaymentProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[WCPaymentProductTableViewCell reuseIdentifier]];
    cell.name = row.name;
    cell.logo = row.logo;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [cell setNeedsLayout];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WCFormRow *row = self.formRows[indexPath.row];
    
    if ([row isKindOfClass:[WCFormRowList class]]) {
        return [WCPickerViewTableViewCell pickerHeight];
    }
    else if ([row isKindOfClass:[WCFormRowDate class]]) {
        return [WCDatePickerTableViewCell pickerHeight];
    }
    // Rows that you can toggle
    else if ([row isKindOfClass:[WCFormRowTooltip class]] && !row.isEnabled) {
        return 0;
    }
    else if ([row isKindOfClass:[WCFormRowSwitch class]] && ((WCFormRowSwitch *)row).action == @selector(switchChanged:) && !row.isEnabled) {
        return 0;
    }
    else if ([row isKindOfClass:[WCFormRowTooltip class]] && ((WCFormRowTooltip *)row).image != nil) {
        return 145;
    } else if ([row isKindOfClass:[WCFormRowTooltip class]]) {
        return [WCTooltipTableViewCell cellSizeForWidth:MIN(320, tableView.frame.size.width) forFormRow:(WCFormRowTooltip *)row].height;
    }
    else if ([row isKindOfClass:[WCFormRowLabel class]]) {
        CGFloat tableWidth = tableView.frame.size.width;
        CGFloat height = [WCLabelTableViewCell cellSizeForWidth:MIN(320, tableWidth) forFormRow:(WCFormRowLabel *)row].height;
        return height;
    } else if ([row isKindOfClass:[WCFormRowButton class]]) {
        return 52;
    } else if ([row isKindOfClass:[WCFormRowTextField class]]) {
        CGFloat width = tableView.bounds.size.width - 20;
        WCFormRowTextField *textfieldRow = (WCFormRowTextField *)row;
        if (textfieldRow.showInfoButton) {
            width -= 48;
        }
        CGFloat errorHeight = 0;

        if ([textfieldRow.paymentProductField.errors firstObject] && self.validation) {
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:@""];
            str = [[NSAttributedString alloc] initWithString: [WCFormRowsConverter errorMessageForError:[textfieldRow.paymentProductField.errors firstObject]   withCurrency: textfieldRow.paymentProductField.displayHints.formElement.type == WCCurrencyType]];
            errorHeight = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options: NSStringDrawingUsesLineFragmentOrigin context: nil].size.height;
        }
        
        CGFloat height =  10 + 44 + 10 + errorHeight;
        return height;
        
    } else if ([row isKindOfClass:[WCFormRowSwitch class]]) {
        CGFloat width = tableView.bounds.size.width - 20;
        WCFormRowSwitch *textfieldRow = (WCFormRowSwitch *)row;
        if (textfieldRow.showInfoButton) {
            width -= 48;
        }
        CGFloat errorHeight = 0;
        if ([textfieldRow.field.errors firstObject] && self.validation) {
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:@""];
            str = [[NSAttributedString alloc] initWithString: [WCFormRowsConverter errorMessageForError:[textfieldRow.field.errors firstObject]   withCurrency: 0]];
            errorHeight = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options: NSStringDrawingUsesLineFragmentOrigin context: nil].size.height + 10;
        }
    
        CGFloat height =  10 + 44 + 10 + errorHeight;
        return height;
    }

    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.formRows[indexPath.row] isKindOfClass:[WCFormRowCoBrandsSelection class]]) {
        self.coBrandsCollapsed = !self.coBrandsCollapsed;
        [self updateFormRowsWithValidation:self.validation tooltipRows:self.tooltipRows confirmedPaymentProducts:self.confirmedPaymentProducts];
        [self.tableView reloadData];
    } else if ([self.formRows[indexPath.row] isKindOfClass:[WCPaymentProductsTableRow class]]) {
        WCPaymentProductsTableRow *row = (WCPaymentProductsTableRow *)self.formRows[indexPath.row];
        [self switchToPaymentProduct:row.paymentProductIdentifier];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    WCFormRow *formRow = self.formRows[indexPath.row + 1];
    if ([formRow isKindOfClass:[WCFormRowTooltip class]]) {
        
        formRow.isEnabled = !formRow.isEnabled;
        
        [tableView beginUpdates];
        [tableView endUpdates];
    }
}

#pragma mark TextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL result = false;
    if ([textField class] == [WCTextField class]) {
        result = [self standardTextField:(WCTextField *)textField shouldChangeCharactersInRange:range replacementString:string];
    } else if ([textField class] == [WCIntegerTextField class]) {
        result = [self integerTextField:(WCIntegerTextField *)textField shouldChangeCharactersInRange:range replacementString:string];
    } else if ([textField class] == [WCFractionalTextField class]) {
        result = [self fractionalTextField:(WCFractionalTextField *)textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    if (self.validation) {
        [self validateData];
    }
    
    return result;
}
-(void)formatAndUpdateCharactersFromTextField:(UITextField *)textField cursorPosition:(NSInteger *)position indexPath:(NSIndexPath *)indexPath trimSet:(NSMutableCharacterSet *)trimSet {
    WCFormRowTextField *row = (WCFormRowTextField *)self.formRows[indexPath.row];

    NSString *formattedString = [[self.inputData maskedValueForField:row.paymentProductField.identifier cursorPosition:position] stringByTrimmingCharactersInSet: trimSet];
    row.field.text = formattedString;
    textField.text = formattedString;
    *position = MIN(*position, formattedString.length);
    UITextPosition *cursorPositionInTextField = [textField positionFromPosition:textField.beginningOfDocument offset:*position];
    [textField setSelectedTextRange:[textField textRangeFromPosition:cursorPositionInTextField toPosition:cursorPositionInTextField]];
}
- (BOOL)standardTextField:(WCTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![textField.superview isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)textField.superview];
    if (indexPath == nil || ![self.formRows[indexPath.row] isKindOfClass:[WCFormRowTextField class]]) {
        return NO;
    }
    WCFormRowTextField *row = (WCFormRowTextField *)self.formRows[indexPath.row];
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self.inputData setValue:newString forField:row.paymentProductField.identifier];
    row.field.text = [self.inputData maskedValueForField:row.paymentProductField.identifier];
    NSInteger cursorPosition = range.location + string.length;
    [self formatAndUpdateCharactersFromTextField:textField cursorPosition:&cursorPosition indexPath:indexPath trimSet: [NSMutableCharacterSet characterSetWithCharactersInString:@" /-_"]];
    return NO;
}

- (BOOL)integerTextField:(WCIntegerTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![textField.superview isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)textField.superview];
    if (indexPath == nil || ![self.formRows[indexPath.row] isKindOfClass:[WCFormRowCurrency class]]) {
        return NO;
    }
    WCFormRowCurrency *row = (WCFormRowCurrency *)self.formRows[indexPath.row];
    NSString *integerString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *fractionalString = row.fractionalField.text;
    
    if (integerString.length > 16) {
        return NO;
    }
    
    NSString *newValue = [self updateCurrencyValueWithIntegerString:integerString fractionalString:fractionalString paymentProductFieldIdentifier:row.paymentProductField.identifier];
    if (string.length == 0) {
        return YES;
    } else {
        [self updateRowWithCurrencyValue:newValue formRowCurrency:row];
        return NO;
    }
}

- (BOOL)fractionalTextField:(WCFractionalTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![textField.superview isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)textField.superview];
    if (indexPath == nil || ![self.formRows[indexPath.row] isKindOfClass:[WCFormRowCurrency class]]) {
        return NO;
    }
    WCFormRowCurrency *row = (WCFormRowCurrency *)self.formRows[indexPath.row];
    NSString *integerString = row.integerField.text;
    NSString *fractionalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (fractionalString.length > 2) {
        int start = (int) fractionalString.length - 2;
        int end = (int) fractionalString.length - 1;
        fractionalString = [fractionalString substringWithRange:NSMakeRange(start, end)];
    }
    
    NSString *newValue = [self updateCurrencyValueWithIntegerString:integerString fractionalString:fractionalString paymentProductFieldIdentifier:row.paymentProductField.identifier];
    if (string.length == 0) {
        return YES;
    } else {
        [self updateRowWithCurrencyValue:newValue formRowCurrency:row];
        return NO;
    }
}

- (NSString *)updateCurrencyValueWithIntegerString:(NSString *)integerString fractionalString:(NSString *)fractionalString paymentProductFieldIdentifier:(NSString *)identifier
{
    long long integerPart = [integerString longLongValue];
    int fractionalPart = [fractionalString intValue];
    long long newValue = integerPart * 100 + fractionalPart;
    NSString *newString = [NSString stringWithFormat:@"%03lld", newValue];
    [self.inputData setValue:newString forField:identifier];
    
    return newString;
}

- (void)updateRowWithCurrencyValue:(NSString *)currencyValue formRowCurrency:(WCFormRowCurrency *)formRowCurrency
{
    formRowCurrency.integerField.text = [currencyValue substringToIndex:currencyValue.length - 2];
    formRowCurrency.fractionalField.text = [currencyValue substringFromIndex:currencyValue.length - 2];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return NO;
}

- (void)validateData {
    [self.inputData validate];
    [self updateFormRows];
}

#pragma mark TextField delegate helper methods

- (void)resetCardNumberTextField
{
//    for (WCFormRow *row in self.formRows) {
//        if ([row class] == [WCFormRowTextField class]) {
//            WCFormRowTextField *textFieldRow = (WCFormRowTextField *)row;
//            if ([textFieldRow.paymentProductField.identifier isEqualToString:@"cardNumber"] == YES) {
//                textFieldRow.textField.rightView = textFieldRow.logo;
//                WCTextField *textField = textFieldRow.textField;
//                [textField setSelectedTextRange:[textField textRangeFromPosition:self.cursorPositionInCreditCardNumberTextField toPosition:self.cursorPositionInCreditCardNumberTextField]];
//                [textField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.01f];
//            }
//        }
//    }
}
#pragma mark Date picker cell delegate
-(void)datePicker:(UIDatePicker *)datePicker selectedNewDate:(NSDate *)newDate {
    WCDatePickerTableViewCell *cell = (WCDatePickerTableViewCell *)[datePicker superview];
    NSIndexPath *path = [[self tableView]indexPathForCell:cell];
    WCFormRowDate *row = self.formRows[path.row];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *dateString = [formatter stringFromDate:newDate];
    [self.inputData setValue:dateString forField:row.paymentProductField.identifier] ;
    
}
- (void)cancelButtonTapped
{
    [self.paymentRequestTarget didCancelPaymentRequest];
}


- (void)switchChanged:(WCSwitch *)sender
{
    WCSwitchTableViewCell *cell = (WCSwitchTableViewCell *)sender.superview;
    NSIndexPath *ip = [self.tableView indexPathForCell:cell];
    WCFormRowSwitch *row = self.formRows[ip.row];
    WCPaymentProductField *field = [row field];
    
    if (field == nil) {
        self.inputData.tokenize = sender.on;
    }
    else {
        [self.inputData setValue:[sender isOn] ? @"true" : @"false" forField:field.identifier];
        row.isOn = [sender isOn];
        if (self.validation) {
            [self validateData];
        }
        [self updateSwitchCell:cell row:row];
    }
}

#pragma mark Picker view delegate

- (NSInteger)numberOfComponentsInPickerView:(WCPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(WCPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerView.content.count;
}

- (NSAttributedString *)pickerView:(WCPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *item = pickerView.content[row];
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:item];
    return string;
}

- (void)pickerView:(WCPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (![pickerView.superview isKindOfClass:[WCPickerViewTableViewCell class]]) {
        return;
    }
    WCPickerViewTableViewCell *cell = (WCPickerViewTableViewCell *)pickerView.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)pickerView.superview];
    if (indexPath == nil || ![self.formRows[indexPath.row] isKindOfClass:[WCFormRowList class]]) {
        return;
    }
    WCFormRowList *element = (WCFormRowList *)self.formRows[indexPath.row];
    WCValueMappingItem *selectedItem = cell.items[row];
    
    element.selectedRow = row;
    [self.inputData setValue:selectedItem.value forField:element.paymentProductField.identifier];
}

// To be overrided by subclasses
- (void)updatePickerCell:(WCPickerViewTableViewCell *)cell row: (WCFormRowList *)list
{
    return;
}
#pragma mark Button target methods

- (void)payButtonTapped
{
    BOOL valid = NO;
    
    [self.inputData validate];
    if (self.inputData.errors.count == 0) {
        WCPaymentRequest *paymentRequest = [self.inputData paymentRequest];
        [paymentRequest validate];
        if (paymentRequest.errors.count == 0) {
            valid = YES;
            [self.paymentRequestTarget didSubmitPaymentRequest:paymentRequest];
        }
    }
    if (valid == NO) {
        self.validation = YES;
        [self updateFormRows];
    }
    
}

-(void)validateExceptFields:(NSSet *)fields {
    [self.inputData validateExceptFields:fields];
    if (self.inputData.errors.count > 0) {
        self.validation = YES;
    }
}

@end
