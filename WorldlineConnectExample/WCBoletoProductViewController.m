//
//  WCBoletoProductViewController.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 01/06/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import "WCBoletoProductViewController.h"
#import "WCFormRowLabel.h"
#import <WCValidatorBoletoBancarioRequiredness.h>
typedef enum {
    WCFiscalNumberTypePersonal,
    WCFiscalNumberTypeCompany
} WCFiscalNumberType;

@interface WCBoletoProductViewController ()
@property WCFiscalNumberType fiscalNumberType;
@property NSUInteger switchLength;
-(WCValidatorBoletoBancarioRequiredness *)firstBoletoBancarioRequirednessValidatorForFieldRow:(WCFormRowTextField *)row;
@end

@implementation WCBoletoProductViewController
-(instancetype)init
{
    if ((self = [super init]))
    {
        self.fiscalNumberType = WCFiscalNumberTypePersonal;
        self.switchLength = 14;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (WCFormRow *row in self.formRows) {
        if ([row isKindOfClass:[WCFormRowTextField class]]) {
            WCFormRowTextField *fieldRow = (WCFormRowTextField *)row;
            WCValidatorBoletoBancarioRequiredness *validator = [self firstBoletoBancarioRequirednessValidatorForFieldRow:fieldRow];
            if (validator != nil) {
                if (validator.fiscalNumberLength < self.switchLength) {
                    row.isEnabled = self.fiscalNumberType == WCFiscalNumberTypePersonal;
                }
                else {
                    row.isEnabled = self.fiscalNumberType == WCFiscalNumberTypeCompany;
                }
            }

        }
    }
}
-(WCValidatorBoletoBancarioRequiredness *)firstBoletoBancarioRequirednessValidatorForFieldRow:(WCFormRowTextField *)row {
    return [row.paymentProductField.dataRestrictions.validators.validators filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id<NSObject>  _Nullable validator, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [validator isKindOfClass:[WCValidatorBoletoBancarioRequiredness class]];
    }]].firstObject;
}
-(void)formatAndUpdateCharactersFromTextField:(UITextField *)textField cursorPosition:(NSInteger *)position indexPath:(NSIndexPath *)indexPath trimSet:(NSMutableCharacterSet *)trimSet
{
    [super formatAndUpdateCharactersFromTextField:textField cursorPosition:position indexPath:indexPath trimSet:[NSMutableCharacterSet characterSetWithCharactersInString:@" /-_"]];
    WCFormRow *row = [self.formRows objectAtIndex:indexPath.row];
    if ([row isKindOfClass:[WCFormRowTextField class]]) {
        WCFormRowTextField *textRow = (WCFormRowTextField *)row;
        if ([[[textRow paymentProductField] identifier]isEqualToString:@"fiscalNumber"])
        {
            switch (self.fiscalNumberType) {
                case WCFiscalNumberTypePersonal:
                    if (textRow.field.text.length >= self.switchLength) {
                        self.fiscalNumberType = WCFiscalNumberTypeCompany;
                        [self updateFormRows];
                    }
                    break;
                case WCFiscalNumberTypeCompany:
                    if (textRow.field.text.length < self.switchLength) {
                        self.fiscalNumberType = WCFiscalNumberTypePersonal;
                        [self updateFormRows];
                    }

                default:
                    break;
            }
        }
    }
}

-(void)updateTextFieldCell:(WCTextFieldTableViewCell *)cell row:(WCFormRowTextField *)row {
    [super updateTextFieldCell:cell row:row];
    WCValidatorBoletoBancarioRequiredness *validator = [self firstBoletoBancarioRequirednessValidatorForFieldRow: row];
    if (validator != nil) {
        if (validator.fiscalNumberLength < self.switchLength) {
            row.isEnabled = self.fiscalNumberType == WCFiscalNumberTypePersonal;
            cell.readonly = !row.isEnabled;
        } else {
            row.isEnabled = self.fiscalNumberType == WCFiscalNumberTypeCompany;
            cell.readonly = !row.isEnabled;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WCFormRow *row = [self.formRows objectAtIndex:indexPath.row];
    BOOL isTextField = [row isKindOfClass:[WCFormRowTextField class]];
    BOOL isLabel = [row isKindOfClass:[WCFormRowLabel class]];
    BOOL indexPathExists = indexPath.row + 1 < self.formRows.count;
    BOOL hasValidatorAbove = NO;
    BOOL isTextFieldAbove = NO;
    BOOL aboveNotEnabled = NO;
    if (indexPathExists)
    {
        isTextFieldAbove = [[self.formRows objectAtIndex:indexPath.row  + 1] isKindOfClass:[WCFormRowTextField class]];
        if (isTextFieldAbove) {
            hasValidatorAbove = [self firstBoletoBancarioRequirednessValidatorForFieldRow:[self.formRows objectAtIndex:indexPath.row + 1]] != nil;
        }
        aboveNotEnabled = ![[self.formRows objectAtIndex:indexPath.row  + 1] isEnabled];

    }
    BOOL hasValidator = false;
    if (isTextField){
        hasValidator = [self firstBoletoBancarioRequirednessValidatorForFieldRow:(WCFormRowTextField *)row] != nil;
    }
    BOOL notEnabled = ![row isEnabled];
    if (isTextField && hasValidator && notEnabled) {
        return 0;
    }
    else if (isLabel && indexPathExists && isTextFieldAbove && hasValidatorAbove && aboveNotEnabled) {
        return 0;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
