//
//  WCCardProductViewController.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 18/05/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import "WCCardProductViewController.h"
#import "WCFormRowTextField.h"
#import "WCFormRowCoBrandsExplanation.h"
#import "WCPaymentProductsTableRow.h"
#import "WCFormRowCoBrandsSelection.h"
#import "WCPaymentProductGroup.h"
#import "WCPaymentProductInputData.h"
#import "WCIINDetail.h"
#import <WorldlineConnectSDK/WCSDKConstants.h>
#import <WorldlineConnectSDK/WCAssetManager.h>

@interface WCCardProductViewController ()
@property (nonatomic, strong) UITextPosition *cursorPositionInCreditCardNumberTextField;
@property (nonatomic, strong) WCIINDetailsResponse *iinDetailsResponse;
@property (strong, nonatomic) NSBundle *sdkBundle;
@property (strong, nonatomic) NSArray<WCIINDetail *> *cobrands;
@property (strong, nonatomic) NSString *previousEnteredCreditCardNumber;
@end

@implementation WCCardProductViewController


- (void)viewDidLoad {
    self.sdkBundle = [NSBundle bundleWithPath:kWCSDKBundlePath];
    [super viewDidLoad];
    
}

- (void)registerReuseIdentifiers {
    [super registerReuseIdentifiers];
    [self.tableView registerClass:[WCCoBrandsSelectionTableViewCell class] forCellReuseIdentifier:WCCoBrandsSelectionTableViewCell.reuseIdentifier];
    [self.tableView registerClass:[WCCOBrandsExplanationTableViewCell class] forCellReuseIdentifier:WCCOBrandsExplanationTableViewCell.reuseIdentifier];
    [self.tableView registerClass:[WCPaymentProductTableViewCell class] forCellReuseIdentifier:WCPaymentProductTableViewCell.reuseIdentifier];
}
- (void) updateTextFieldCell:(WCTextFieldTableViewCell *)cell row: (WCFormRowTextField *)row {
    [super updateTextFieldCell:cell row:row];
    if ([row.paymentProductField.identifier isEqualToString:@"cardNumber"]) {
        if([self.confirmedPaymentProducts containsObject:self.paymentItem.identifier]) {
            CGFloat productIconSize = 35.2;
            CGFloat padding = 4.4;

            UIView *outerView = [[UIView alloc]initWithFrame:CGRectMake(padding, padding, productIconSize, productIconSize)];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, productIconSize, productIconSize)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [outerView addSubview:imageView];
            outerView.contentMode = UIViewContentModeScaleAspectFit;

            imageView.image = row.logo;
            cell.rightView = outerView;
        }
        else {
            row.logo = nil;
            cell.rightView = [[UIView alloc]init];
        }
    }
}
-(WCTextFieldTableViewCell *)cellForTextField:(WCFormRowTextField *)row tableView:(UITableView *)tableView {
    WCTextFieldTableViewCell *cell = [super cellForTextField:row tableView:tableView];

    [self updateTextFieldCell:cell row:row];

    return cell;
}
- (WCCoBrandsSelectionTableViewCell *)cellForCoBrandsSelection:(WCFormRowCoBrandsSelection *)row tableView:(UITableView *)tableView {
    return [tableView dequeueReusableCellWithIdentifier:WCCoBrandsSelectionTableViewCell.reuseIdentifier];
}

- (WCCOBrandsExplanationTableViewCell *)cellForCoBrandsExplanation:(WCFormRowCoBrandsExplanation *)row tableView:(UITableView *)tableView {
    return [tableView dequeueReusableCellWithIdentifier:WCCOBrandsExplanationTableViewCell.reuseIdentifier];
}

- (WCPaymentProductTableViewCell *)cellForPaymentProduct:(WCPaymentProductsTableRow *)row tableView:(UITableView *)tableView {
    WCPaymentProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WCPaymentProductTableViewCell.reuseIdentifier];
    
    cell.name = row.name;
    cell.logo = row.logo;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.shouldHaveMaximalWidth = YES;
    cell.limitedBackgroundColor = [UIColor colorWithWhite: 0.9 alpha: 1];
    [cell setNeedsLayout];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    WCFormRow *row = [self.formRows objectAtIndex:indexPath.row];
    if ([row isKindOfClass:[WCPaymentProductsTableRow class]] && ((WCPaymentProductsTableRow *)row).paymentProductIdentifier != self.paymentItem.identifier) {
        [self switchToPaymentProduct:((WCPaymentProductsTableRow *)row).paymentProductIdentifier];
        return;
    }
    if ([row isKindOfClass:[WCFormRowCoBrandsSelection class]] || [row isKindOfClass:[WCPaymentProductsTableRow class]]) {
        for (WCFormRow *cell in self.formRows) {
            if ([cell isKindOfClass:[WCFormRowCoBrandsExplanation class]] || [cell isKindOfClass:[WCPaymentProductsTableRow class]]) {
                cell.isEnabled = !cell.isEnabled;
            }
        }
        [self updateFormRows];
    }
}

-(void)formatAndUpdateCharactersFromTextField:(UITextField *)texField cursorPosition:(NSInteger *)position indexPath:(NSIndexPath *)indexPath trimSet:(NSMutableCharacterSet *)trimSet  {
    WCFormRowTextField *row = [self.formRows objectAtIndex:indexPath.row];
    
    if ([row.paymentProductField.identifier isEqualToString:@"cardholderName"]) {
        [super formatAndUpdateCharactersFromTextField:texField cursorPosition:position indexPath:indexPath trimSet:[NSMutableCharacterSet characterSetWithCharactersInString:@"?`~!@#$%^&*()_+=[]{}|\\;:\"<>£¥•,€"]];
    } else {
        [super formatAndUpdateCharactersFromTextField:texField cursorPosition:position indexPath:indexPath trimSet:[NSMutableCharacterSet characterSetWithCharactersInString:@" /-_"]];
    }
    
    if ([row.paymentProductField.identifier isEqualToString:@"cardNumber"]) {
        NSString *unmasked = [self.inputData unmaskedValueForField:row.paymentProductField.identifier];
        if (unmasked.length >= 6 && [self oneOfFirst8DigitsChangedInText:unmasked]) {
            
            [self.session IINDetailsForPartialCreditCardNumber:unmasked context:self.context success:^(WCIINDetailsResponse *response) {
                self.iinDetailsResponse = response;
                if ([self.inputData unmaskedValueForField:row.paymentProductField.identifier].length < 6) {
                    return;
                }
                self.cobrands = response.coBrands;

                if (response.status == WCSupported) {
                    BOOL coBrandSelected = NO;
                    for (WCIINDetail *coBrand in response.coBrands) {
                        if ([coBrand.paymentProductId isEqualToString:self.paymentItem.identifier]) {
                            coBrandSelected = YES;
                        }
                    }
                    if (coBrandSelected == NO) {
                        [self switchToPaymentProduct:response.paymentProductId];
                    }
                    else {
                        [self switchToPaymentProduct:self.paymentItem.identifier];
                    }
                }
                else {
                    [self switchToPaymentProduct:self.initialPaymentProduct == nil ? nil : self.initialPaymentProduct.identifier];
                }
            } failure:^(NSError *error) {
                
            }];
        }
        _previousEnteredCreditCardNumber = unmasked;
    }
}

-(Boolean)oneOfFirst8DigitsChangedInText:(NSString *)currentEnteredCreditCardNumber {
    // Add some padding, so we are sure there are 8 characters to compare.
    NSString *currentPadded = [currentEnteredCreditCardNumber stringByAppendingString: @"xxxxxxxx"];
    NSString *previousPadded = [_previousEnteredCreditCardNumber stringByAppendingString:@"xxxxxxxx"];

    NSString *currentFirst8 = [currentPadded substringWithRange:NSMakeRange(0, 8)];
    NSString *previousFirst8 = [previousPadded substringWithRange:NSMakeRange(0, 8)];

    return ![currentFirst8 isEqualToString:previousFirst8];
}

-(void)initializeFormRows {
    [super initializeFormRows];
    NSArray<WCFormRow *> *newFormRows = [self coBrandFormsWithIINDetailsResponse:self.cobrands];
    [self.formRows insertObjects:newFormRows atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, newFormRows.count)]];
}

-(void)updateFormRows {
    if ([self switching]) {
        // We need to update the tableView to the new amount of rows. However, we cannot use tableView.reloadData(), because then
        // the current textfield losses focus. We also should not reload the cardNumber row with tableView.reloadRows([indexOfCardNumber, with: ...)
        // because that also makes the textfield lose focus.
        
        // Because the cardNumber field might move, we cannot just insert/delete the difference in rows in general, because if we
        // do, the index of the cardNumber field might change, and we cannot reload the new place.
        
        // So instead, we check the difference in rows before the cardNumber field between before the mutation and after the mutation,
        // and the difference in rows after the cardNumber field between before and after the mutations
        
        [self.tableView beginUpdates];
        NSArray<WCFormRow *> *oldFormRows = self.formRows;
        [self initializeFormRows];
        [self addExtraRows];
        
        NSInteger oldCardNumberIndex = 0;
        for (WCFormRow *fr in oldFormRows) {
            if ([fr isKindOfClass:[WCFormRowTextField class]]) {
                if ([((WCFormRowTextField *)fr).paymentProductField.identifier isEqualToString:@"cardNumber"]) {
                    break;
                }
            }
            oldCardNumberIndex += 1;
        }
        NSInteger newCardNumberIndex = 0;
        for (WCFormRow *fr in self.formRows) {
            if ([fr isKindOfClass:[WCFormRowTextField class]]) {
                if ([((WCFormRowTextField *)fr).paymentProductField.identifier isEqualToString:@"cardNumber"]) {
                    break;
                }
            }
            newCardNumberIndex += 1;
        }
        if (newCardNumberIndex >= self.formRows.count) {
            newCardNumberIndex = 0;
        }
        if (oldCardNumberIndex >= self.formRows.count) {
            oldCardNumberIndex = 0;
        }
        NSInteger diffCardNumberIndex = newCardNumberIndex - oldCardNumberIndex;
        if (diffCardNumberIndex >= 0) {
            NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:diffCardNumberIndex];
            NSMutableArray *updateIndexPaths = [NSMutableArray arrayWithCapacity:oldCardNumberIndex];
            for (NSInteger i = 0; i < diffCardNumberIndex; i+=1) {
                [insertIndexPaths addObject:[NSIndexPath indexPathForRow:oldCardNumberIndex - 1 + i inSection:0]];
            }
            for (NSInteger i = 0; i < oldCardNumberIndex; i+=1) {
                [updateIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            
            [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView reloadRowsAtIndexPaths:updateIndexPaths withRowAnimation:UITableViewRowAnimationNone];
        }
        
        if (diffCardNumberIndex < 0) {
            NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:-diffCardNumberIndex];
            NSMutableArray *updateIndexPaths = [NSMutableArray arrayWithCapacity:oldCardNumberIndex];
            for (NSInteger i = 0; i < -diffCardNumberIndex; i+=1) {
                [insertIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            for (NSInteger i = 0; i < oldCardNumberIndex + diffCardNumberIndex; i+=1) {
                [updateIndexPaths addObject:[NSIndexPath indexPathForRow:oldCardNumberIndex - i inSection:0]];
            }
            
            [self.tableView deleteRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView reloadRowsAtIndexPaths:updateIndexPaths withRowAnimation:UITableViewRowAnimationNone];
        }
        NSInteger oldAfterCardNumberCount = oldFormRows.count - oldCardNumberIndex - 1;
        NSInteger newAfterCardNumberCount = self.formRows.count - newCardNumberIndex - 1;
        
        NSInteger diffAfterCardNumberCount = newAfterCardNumberCount - oldAfterCardNumberCount;
        
        // We cannot not update the cardname field if it doesn't exist
        if (newAfterCardNumberCount < 0) {
            newAfterCardNumberCount = 0;
        }
        if (diffAfterCardNumberCount >= 0) {
            NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:diffAfterCardNumberCount];
            NSMutableArray *updateIndexPaths = [NSMutableArray arrayWithCapacity:oldAfterCardNumberCount];
            for (NSInteger i = 0; i < diffAfterCardNumberCount; i+=1) {
                [insertIndexPaths addObject:[NSIndexPath indexPathForRow:oldFormRows.count + i inSection:0]];
            }
            for (NSInteger i = 0; i < oldAfterCardNumberCount; i+=1) {
                [updateIndexPaths addObject:[NSIndexPath indexPathForRow:i + oldCardNumberIndex + 1 inSection:0]];
            }
            
            [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView reloadRowsAtIndexPaths:updateIndexPaths withRowAnimation:UITableViewRowAnimationNone];
        }
        
        if (diffAfterCardNumberCount < 0) {
            NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:-diffAfterCardNumberCount];
            NSMutableArray *updateIndexPaths = [NSMutableArray arrayWithCapacity:newAfterCardNumberCount];
            for (NSInteger i = 0; i < -diffAfterCardNumberCount; i+=1) {
                [insertIndexPaths addObject:[NSIndexPath indexPathForRow:oldFormRows.count - i - 1 inSection:0]];
            }
            for (NSInteger i = 0; i < newAfterCardNumberCount; i+=1) {
                [updateIndexPaths addObject:[NSIndexPath indexPathForRow:self.formRows.count - i - 1 - diffCardNumberIndex inSection:0]];
            }
            
            [self.tableView deleteRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView reloadRowsAtIndexPaths:updateIndexPaths withRowAnimation:UITableViewRowAnimationNone];
        }
        [self.tableView endUpdates];
    }
    [super updateFormRows];
}
-(NSArray *)coBrandFormsWithIINDetailsResponse: (NSArray<WCIINDetail *> *)inputBrands{
    NSMutableArray *coBrands = [[NSMutableArray alloc] init];
    for (WCIINDetail *coBrand in inputBrands) {
        if (coBrand.allowedInContext) {
            [coBrands addObject:coBrand.paymentProductId];
        }
    }
    NSMutableArray *formRows = [[NSMutableArray alloc] init];
    
    if (coBrands.count > 1) {
        // Add explanaton row
        WCFormRowCoBrandsExplanation *explanationRow = [[WCFormRowCoBrandsExplanation alloc]init];
        [formRows addObject:explanationRow];
        
        for (NSString *identifier in coBrands) {
            WCPaymentProductsTableRow *row = [[WCPaymentProductsTableRow alloc]init];
            row.paymentProductIdentifier = identifier;
            
            NSString *paymentProductKey = [NSString stringWithFormat:@"gc.general.paymentProducts.%@.name", identifier];
            NSString *paymentProductValue = NSLocalizedStringFromTableInBundle(paymentProductKey, kWCSDKLocalizable, [NSBundle bundleWithPath:kWCSDKBundlePath], "");
            row.name = paymentProductValue;
            
            WCAssetManager *assetManager = [[WCAssetManager alloc]init];
            UIImage *logo = [assetManager logoImageForPaymentItem:identifier];
            [row setLogo:logo];
            
            [formRows addObject:row];
        }
        WCFormRowCoBrandsSelection *toggleCoBrandRow = [[WCFormRowCoBrandsSelection alloc]init];
        [formRows addObject:toggleCoBrandRow];
    }
    
    return formRows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WCFormRow *row = [self.formRows objectAtIndex:[indexPath row]];
    if (([row isKindOfClass:[WCFormRowCoBrandsExplanation class]] || [row isKindOfClass:[WCPaymentProductsTableRow class]]) && ![row isEnabled]) {
        return 0;
    }
    else if ([row isKindOfClass:[WCFormRowCoBrandsExplanation class]]) {
        NSAttributedString *cellString = WCCOBrandsExplanationTableViewCell.cellString;
        CGRect rect = [cellString boundingRectWithSize:CGSizeMake(tableView.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        return rect.size.height + 20;
    }
    else if ([row isKindOfClass:[WCFormRowCoBrandsSelection class]]) {
        return 30;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

@end
