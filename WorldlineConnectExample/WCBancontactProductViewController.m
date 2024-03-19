//
//  WCBancontactViewController.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 14/07/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import "WCBancontactProductViewController.h"
#import <WorldlineConnectSDK/WCThirdPartyStatus.h>
#import <WorldlineConnectSDK/WCThirdPartyStatusResponse.h>
#import "WCExternalAppStatusViewController.h"
#import "WCFormRowImage.h"
#import "WCImageTableViewCell.h"
#import "WCFormRowSmallLogo.h"
#import "WCLogoTableViewCell.h"
#import "WCSeparatorTableViewCell.h"
#import "WCFormRowSeparator.h"
#import "WCFormRowCoBrandsExplanation.h"
#import "WCPaymentProductsTableRow.h"
#import "WCFormRowCoBrandsSelection.h"
#import "WCFormRowQRCode.h"
#import "WCFormRowButton.h"
#import <WorldlineConnectSDK/WCPaymentItemConverter.h>
#import <WorldlineConnectSDK/WCSDKConstants.h>
#import "WCFormRowLabel.h"
@interface WCBancontactProductViewController ()
@property (nonatomic, strong, readonly) NSString *paymentId;
@property (nonatomic, strong, readonly) NSString *appRedirectURL;
@property (nonatomic, strong, readonly) NSString *qrCodeString;
@property (nonatomic, assign) WCThirdPartyStatus thirdPartyStatus;
@property (nonatomic, strong) void(^callback)();
@property (nonatomic, assign) CGFloat testTime;
@property (nonatomic, assign, getter=isPolling) BOOL polling;
@property (nonatomic, retain) WCExternalAppStatusViewController *statusViewController;
@end

@implementation WCBancontactProductViewController
- (void)registerReuseIdentifiers {
    [super registerReuseIdentifiers];
    [self.tableView registerClass:[WCImageTableViewCell class] forCellReuseIdentifier:[WCImageTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[WCSeparatorTableViewCell class] forCellReuseIdentifier:[WCSeparatorTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[WCLogoTableViewCell class] forCellReuseIdentifier:[WCLogoTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[WCCoBrandsSelectionTableViewCell class] forCellReuseIdentifier:[WCCoBrandsSelectionTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[WCCOBrandsExplanationTableViewCell class] forCellReuseIdentifier:[WCCOBrandsExplanationTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[WCPaymentProductTableViewCell class] forCellReuseIdentifier:[WCPaymentProductTableViewCell reuseIdentifier]];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.statusViewController = [[WCExternalAppStatusViewController alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self startPolling];
    }
}
- (void)startPolling {
    self.polling = YES;
    __weak __block WCBancontactProductViewController *weakSelf = self;
    self.callback = ^ {
        [weakSelf pollWithCallback:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), weakSelf.callback);
        }];
    };
    self.callback();

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

-(WCTableViewCell *)formRowCellForRow:(WCFormRow *)abstractRow atIndexPath:(NSIndexPath *)indexPath {
    WCTableViewCell *cell;
    if ([abstractRow isKindOfClass:[WCFormRowQRCode class]]) {
        WCFormRowQRCode *row = (WCFormRowQRCode *)abstractRow;
        cell = [self cellForImage:row tableView:self.tableView];
    }
    else if ([abstractRow isKindOfClass:[WCFormRowSmallLogo class]]) {
        WCFormRowSmallLogo *row = (WCFormRowSmallLogo *)abstractRow;
        cell = [self cellForLogo:row tableView:self.tableView];
    }
    else if ([abstractRow isKindOfClass:[WCFormRowSeparator class]]) {
        WCFormRowSeparator *row = (WCFormRowSeparator *)abstractRow;
        cell = [self cellForSeparator:row tableView:self.tableView];
    }
    else {
        cell = [super formRowCellForRow:abstractRow atIndexPath:indexPath];
    }
    return cell;
}
-(void)pollWithCallback:(void(^)())callback {
    void (^success)(WCThirdPartyStatusResponse *) = ^(WCThirdPartyStatusResponse *response){
        WCThirdPartyStatus status = response.thirdPartyStatus;
        
        // START: Uncomment the following code to progress the processing screen
        //self.testTime += 1.0;
        //if (self.testTime >= 10.0) {
        //    status = WCThirdPartyStatusInitialized;
        //}
        //if (self.testTime >= 20.0) {
        //    status = WCThirdPartyStatusAuthorized;
        //}
        //if (self.testTime >= 30.0) {
        //    status = WCThirdPartyStatusCompleted;
        //}
        // END
        
        
        if (self.thirdPartyStatus == status) {
            if (status != WCThirdPartyStatusCompleted) {
                callback();
            }
            return;
        }
        self.thirdPartyStatus = status;
        switch (self.thirdPartyStatus) {
            case WCThirdPartyStatusWaiting:
            {
                callback();
                break;
            }
            case WCThirdPartyStatusInitialized:
            {
                [self presentViewController:self.statusViewController animated:YES completion:^{
                    self.statusViewController.externalAppStatus = WCThirdPartyStatusInitialized;
                    callback();
                }];
                break;
            }
            case WCThirdPartyStatusAuthorized:
            {
                self.statusViewController.externalAppStatus = WCThirdPartyStatusAuthorized;
                callback();
                break;
            }
            case WCThirdPartyStatusCompleted:
            {
                self.statusViewController.externalAppStatus = WCThirdPartyStatusAuthorized;
                [self.statusViewController dismissViewControllerAnimated:YES completion:^{
                    WCPaymentRequest *request = [[WCPaymentRequest alloc] init];
                    request.paymentProduct = (WCPaymentProduct *)self.paymentItem;
                    request.accountOnFile = self.accountOnFile;
                    request.tokenize = self.inputData.tokenize;
                    [self.paymentRequestTarget didSubmitPaymentRequest:request];
                }];
                break;
            }
                
        }
    };
    [self.session thirdPartyStatusForPayment:self.paymentId success:success failure:^(NSError *error) {
        // START: Uncomment the following code to test locally
        //WCThirdPartyStatusResponse *response = [[WCThirdPartyStatusResponse alloc]init];
        //response.thirdPartyStatus = WCThirdPartyStatusWaiting;
        //success(response);
        // END

        NSLog(@"%@", [error localizedDescription]);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setCustomServerJSON:(NSDictionary<NSString *,NSObject *> *)customServerJSON
{
    _customServerJSON = customServerJSON;
    NSDictionary<NSString *, NSObject *> *paymentDict = (NSDictionary<NSString *, NSObject *> *)self.customServerJSON[@"payment"];
    _paymentId = (NSString *)paymentDict[@"id"];
    NSDictionary<NSString *, NSObject *> *merchantAction = (NSDictionary<NSString *, NSObject *> *)customServerJSON[@"merchantAction"];
    NSArray<NSDictionary<NSString *, NSObject *> *> *formFields = (NSArray<NSDictionary<NSString *, NSObject *> *> *)merchantAction[@"formFields"];
    WCPaymentItemConverter *converter = [[WCPaymentItemConverter alloc]init];
    [self.paymentItem.fields.paymentProductFields removeAllObjects];
    [converter setPaymentProductFields:self.paymentItem.fields JSON:formFields];
//    [self.paymentItem.fields.paymentProductFields removeAllObjects];
//    for (NSDictionary<NSString *, NSObject *> *fieldJSON in formFields) {
//        WCPaymentProductField *field = [[WCPaymentProductField alloc] init];
//        if (field != nil) {
//            [self.paymentItem.fields.paymentProductFields addObject:field];
//        }
//    }
    NSArray<NSDictionary<NSString *, NSString *> *> *showData = (NSArray<NSDictionary<NSString *, NSString *> *> *)merchantAction[@"showData"];
    for (NSDictionary<NSString *, NSString *> *dict in showData) {
        if ([dict[@"key"] isEqualToString:@"URLINTENT"]) {
            _appRedirectURL = dict[@"value"];
        }
    }
    for (NSDictionary<NSString *, NSString *> *dict in showData) {
        if ([dict[@"key"] isEqualToString:@"QRCODE"]) {
            _qrCodeString = dict[@"value"];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WCFormRow *abstractRow = self.formRows[indexPath.row];
    if ([abstractRow isKindOfClass: [WCFormRowSmallLogo class]]) {
        WCFormRowSmallLogo *row = (WCFormRowSmallLogo *)abstractRow;
        WCLogoTableViewCell *cell = [self cellForLogo:row tableView:tableView];
        return [cell cellSizeWithWidth:self.tableView.frame.size.width].height;
    }
    if ([abstractRow isKindOfClass: [WCFormRowImage class]]) {
        WCFormRowImage *row = (WCFormRowImage *)abstractRow;
        WCImageTableViewCell *cell = [self cellForImage:row tableView:tableView];
        CGFloat tableWidth = self.tableView.frame.size.width;
        return [cell cellSizeWithWidth:MIN(tableWidth, 320)].height;
    }
    if (([abstractRow isKindOfClass:[WCFormRowCoBrandsExplanation class]] || [abstractRow isKindOfClass:[WCPaymentProductsTableRow class]]) && ![abstractRow isEnabled]) {
        return 0;
    }
    else if ([abstractRow isKindOfClass:[WCFormRowCoBrandsExplanation class]]) {
        NSAttributedString *cellString = WCCOBrandsExplanationTableViewCell.cellString;
        CGRect rect = [cellString boundingRectWithSize:CGSizeMake(tableView.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        return rect.size.height + 20;
    }
    else if ([abstractRow isKindOfClass:[WCFormRowCoBrandsSelection class]]) {
        return 30;
    }

    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (WCLabelTableViewCell *)cellForLabel:(WCFormRowLabel *)row tableView:(UITableView *)tableView
{
    WCLabelTableViewCell *cell = (WCLabelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[WCLabelTableViewCell reuseIdentifier]];
    cell.label = row.text;
    cell.bold = row.bold;
    return cell;
}

- (WCImageTableViewCell *)cellForImage:(WCFormRowImage *)row tableView:(UITableView *)tableView {
    WCImageTableViewCell *cell = (WCImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[WCImageTableViewCell reuseIdentifier]];
    
    cell.displayImage = row.image;
    
    return cell;
}

- (WCLogoTableViewCell *)cellForLogo:(WCFormRowSmallLogo *)row tableView:(UITableView *)tableView {
    WCLogoTableViewCell *cell = (WCLogoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[WCLogoTableViewCell reuseIdentifier]];
    
    cell.displayImage = row.image;
    
    return cell;

}
- (WCSeparatorTableViewCell *)cellForSeparator:(WCFormRowSeparator *)row tableView:(UITableView *)tableView {
    WCSeparatorTableViewCell *cell = (WCSeparatorTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[WCSeparatorTableViewCell reuseIdentifier]];
    
    cell.separatorText = row.text;
    
    return cell;
    
}

-(void)insertSeparator
{
    NSString *separatorTextKey = @"gc.general.paymentProducts.3012.divider";
    NSString *separatorTextValue = NSLocalizedStringWithDefaultValue(separatorTextKey, kWCSDKLocalizable, [NSBundle bundleWithPath:kWCSDKBundlePath], @"Or", @"");
    WCFormRowSeparator *separator = [[WCFormRowSeparator alloc]init];
    separator.text = separatorTextValue;
    [self.formRows insertObject:separator atIndex:0];
}
-(void)insertButtonWithKey:(NSString *)key value:(NSString *)value selector:(SEL)selector enabled:(BOOL)enabled
{
    NSString *buttonTitle = NSLocalizedStringWithDefaultValue(key, kWCSDKLocalizable, [NSBundle bundleWithPath:kWCSDKBundlePath], value, @"");
    WCFormRowButton *button = [[WCFormRowButton alloc]init];
    button.title = buttonTitle;
    button.isEnabled = enabled;
    button.target = self;
    button.action = selector;
    [self.formRows insertObject:button atIndex:0];
}
-(void)insertLabelWithKey:(NSString *)key value:(NSString *)value isBold:(BOOL)bold
{
    NSString *labelText = NSLocalizedStringWithDefaultValue(key, kWCSDKLocalizable, [NSBundle bundleWithPath:kWCSDKBundlePath], value, @"");
    WCFormRowLabel *label = [[WCFormRowLabel alloc]init];
    label.text = labelText;
    label.bold = bold;
    [self.formRows insertObject:label atIndex:0];

}
-(void)insertQRCode
{
    WCFormRowQRCode *code  = [[WCFormRowQRCode alloc]initWithString:self.qrCodeString];
    [self.formRows insertObject:code atIndex:0];
}
-(void)insertLogo
{
    WCFormRowSmallLogo *code  = [[WCFormRowSmallLogo alloc]initWithImage:self.paymentItem.displayHints.logoImage];
    [self.formRows insertObject:code atIndex:0];
}

- (void)initializeFormRows
{
    [super initializeFormRows];
    [self insertLabelWithKey:@"gc.general.paymentProducts.3012.payWithCardLabel" value:@"Pay with your Bancontact card" isBold:YES];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self insertSeparator];
        [self insertLabelWithKey:@"gc.general.paymentProducts.3012.qrCodeLabel" value:@"Open the app on your phone, click 'Pay' and scan with a QR code." isBold:NO];
        [self insertQRCode];
        [self insertLabelWithKey:@"gc.general.paymentProducts.3012.qrCodeShortLabel" value:@"Scan a QR code" isBold:YES];
    }
    [self insertSeparator];
    [self insertButtonWithKey:@"gc.general.paymentProducts.3012.payWithAppButtonText" value:@"Open App" selector:@selector(didTapOpenAppButton) enabled:YES];
    [self insertLabelWithKey:@"gc.general.paymentProducts.3012.payWithAppButtonText" value:@"Pay with your bancontact app" isBold:NO];
    [self insertLabelWithKey:@"gc.general.paymentProducts.3012.introduction" value:@"How would you like to pay?" isBold:YES];
    [self insertLogo];

}

-(void)didTapOpenAppButton
{
    // START: Remove the following code to test locally
    NSURL *url = [NSURL URLWithString:self.appRedirectURL];
    if (url == nil) {
        return;
    }
    // END
    
    // START: Uncomment the following to test locally
    //NSURL *url = [NSURL URLWithString: @"http://www.google.com"];
    // END
    if (![UIApplication.sharedApplication canOpenURL:url]) {
        return;
    }
    if ([UIApplication.sharedApplication respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [UIApplication.sharedApplication openURL:url options:@{} completionHandler:^(BOOL success) {
            
        }];
    }
    else {
        [UIApplication.sharedApplication openURL:url];
    }
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didReturn) name:UIApplicationDidBecomeActiveNotification object:nil];

}

-(void)didReturn
{
    // START: Uncomment the following code to test locally
    //self.testTime += 10.0;
    // END
    if (!self.polling) {
        [self startPolling];
    }
    [NSNotificationCenter.defaultCenter removeObserver:self];
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
