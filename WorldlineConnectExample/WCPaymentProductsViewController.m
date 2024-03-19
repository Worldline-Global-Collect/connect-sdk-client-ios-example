//
//  WCPaymentProductsViewController.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCAppConstants.h>
#import <WorldlineConnectSDK/WCSDKConstants.h>
#import <WorldlineConnectExample/WCPaymentProductsViewController.h>
#import <WorldlineConnectExample/WCPaymentProductTableViewCell.h>
#import <WorldlineConnectExample/WCPaymentProductsTableSection.h>
#import <WorldlineConnectExample/WCPaymentProductsTableRow.h>
#import <WorldlineConnectExample/WCTableSectionConverter.h>
#import <WorldlineConnectExample/WCSummaryTableHeaderView.h>
#import <WorldlineConnectSDK/WCPaymentItems.h>
#import <WorldlineConnectExample/WCMerchantLogoImageView.h>

@interface WCPaymentProductsViewController ()

@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) WCSummaryTableHeaderView *header;
@property (strong, nonatomic) NSBundle *sdkBundle;

@end

@implementation WCPaymentProductsViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sdkBundle = [NSBundle bundleWithPath:kWCSDKBundlePath];

    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.titleView = [[WCMerchantLogoImageView alloc] init];

    [self initializeHeader];
    
    self.sections = [[NSMutableArray alloc] init];
    //TODO: Accounts on file
    if ([self.paymentItems hasAccountsOnFile] == YES) {
        WCPaymentProductsTableSection *accountsSection =
        [WCTableSectionConverter paymentProductsTableSectionFromAccountsOnFile:[self.paymentItems accountsOnFile] paymentItems:self.paymentItems];
        accountsSection.title = NSLocalizedStringFromTableInBundle(@"gc.app.paymentProductSelection.accountsOnFileTitle", kWCSDKLocalizable, self.sdkBundle, @"Title of the section that displays stored payment products.");
        [self.sections addObject:accountsSection];
    }
    WCPaymentProductsTableSection *productsSection = [WCTableSectionConverter paymentProductsTableSectionFromPaymentItems:self.paymentItems];
    productsSection.title = NSLocalizedStringFromTableInBundle(@"gc.app.paymentProductSelection.pageTitle", kWCSDKLocalizable, self.sdkBundle, @"Title of the section that shows all available payment products.");
    [self.sections addObject:productsSection];
    
    [self.tableView registerClass:[WCPaymentProductTableViewCell class] forCellReuseIdentifier:[WCPaymentProductTableViewCell reuseIdentifier]];
}

- (void)initializeHeader
{
    self.header = (WCSummaryTableHeaderView *)[self.viewFactory tableHeaderViewWithType:WCSummaryTableHeaderViewType frame:CGRectMake(0, 0, self.tableView.frame.size.width, 70)];
    self.header.summary = [NSString stringWithFormat:@"%@:", NSLocalizedStringFromTableInBundle(@"gc.app.general.shoppingCart.total", kWCSDKLocalizable, self.sdkBundle, @"Description of the amount header.")];
    NSNumber *amountAsNumber = [[NSNumber alloc] initWithFloat:self.amount / 100.0];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencyCode:self.currencyCode];
    NSString *amountAsString = [numberFormatter stringFromNumber:amountAsNumber];
    self.header.amount = amountAsString;
    self.header.securePayment = NSLocalizedStringFromTableInBundle(@"gc.app.general.securePaymentText", kWCSDKLocalizable, self.sdkBundle, @"Text indicating that a secure payment method is used.");
    self.tableView.tableHeaderView = self.header;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    WCPaymentProductsTableSection *tableSection = self.sections[section];
    return tableSection.rows.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    WCPaymentProductsTableSection *tableSection = self.sections[section];
    return tableSection.title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WCPaymentProductTableViewCell *cell = (WCPaymentProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[WCPaymentProductTableViewCell reuseIdentifier]];
    
    WCPaymentProductsTableSection *section = self.sections[indexPath.section];
    WCPaymentProductsTableRow *row = section.rows[indexPath.row];
    cell.name = row.name;
    cell.logo = row.logo;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WCPaymentProductsTableSection *section = self.sections[indexPath.section];
    WCPaymentProductsTableRow *row = section.rows[indexPath.row];
    NSObject<WCBasicPaymentItem> *paymentItem = [self.paymentItems paymentItemWithIdentifier:row.paymentProductIdentifier];
    if (section.type == WCAccountOnFileType) {
        WCBasicPaymentProduct *product = (WCBasicPaymentProduct *) paymentItem;
        WCAccountOnFile *accountOnFile = [product accountOnFileWithIdentifier:row.accountOnFileIdentifier];
        [self.target didSelectPaymentItem:product accountOnFile:accountOnFile];
    }
    else {
        [self.target didSelectPaymentItem:paymentItem accountOnFile:nil];
    }
}

@end
