//
//  WCPaymentProductViewController.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <WorldlineConnectExample/WCViewFactory.h>
#import <WorldlineConnectSDK/WCPaymentProduct.h>
#import <WorldlineConnectSDK/WCAccountOnFile.h>
#import <WorldlineConnectExample/WCPaymentRequestTarget.h>
#import <WorldlineConnectSDK/WCSession.h>
#import <WorldlineConnectExample/WCCoBrandsSelectionTableViewCell.h>
#import "WCFormRowTextField.h"
#import "WCPaymentProductInputData.h"
#import "WCFormRowSwitch.h"
#import "WCFormRowList.h"
@interface WCPaymentProductViewController : UITableViewController <WCSwitchTableViewCellDelegate>

@property (weak, nonatomic) id <WCPaymentRequestTarget> paymentRequestTarget;
@property (strong, nonatomic) WCViewFactory *viewFactory;
@property (nonatomic) NSObject<WCPaymentItem> *paymentItem;
@property (strong, nonatomic) WCPaymentProduct *initialPaymentProduct;
@property (strong, nonatomic) WCAccountOnFile *accountOnFile;
@property (strong, nonatomic) WCPaymentContext *context;
@property (nonatomic) NSUInteger amount;
@property (strong, nonatomic) WCSession *session;
@property (strong, nonatomic) NSMutableSet *confirmedPaymentProducts;
@property (strong, nonatomic) NSMutableArray *formRows;
@property (strong, nonatomic) WCPaymentProductInputData *inputData;
@property (nonatomic, readonly) BOOL validation;
@property (nonatomic) BOOL switching;
- (void) addExtraRows;
- (void) registerReuseIdentifiers;
- (void)updatePickerCell:(WCPickerViewTableViewCell *)cell row: (WCFormRowList *)list;
- (void) updateTextFieldCell:(WCTextFieldTableViewCell *)cell row: (WCFormRowTextField *)row;
- (void)updateSwitchCell:(WCSwitchTableViewCell *)cell row: (WCFormRowSwitch *)row;
- (WCTextFieldTableViewCell *)cellForTextField:(WCFormRowTextField *)row tableView:(UITableView *)tableView;
- (WCTableViewCell *)formRowCellForRow:(WCFormRow *)row atIndexPath:(NSIndexPath *)indexPath;
-(void)switchToPaymentProduct:(NSString *)paymentProductId;
-(void)updateFormRows;
-(void)formatAndUpdateCharactersFromTextField:(UITextField *)texField cursorPosition:(NSInteger *)position indexPath:(NSIndexPath *)indexPath trimSet:(NSMutableCharacterSet *)trimSet;
- (void)initializeFormRows;
-(void)validateExceptFields:(NSSet *)fields;
- (void)pickerView:(WCPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
@end
