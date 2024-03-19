//
//  WCStartViewController.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <PassKit/PassKit.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import <WorldlineConnectExample/WCAppConstants.h>
#import <WorldlineConnectSDK/WCSDKConstants.h>
#import <WorldlineConnectSDK/WCPaymentItem.h>
#import <WorldlineConnectExample/WCStartViewController.h>
#import <WorldlineConnectExample/WCViewFactory.h>
#import <WorldlineConnectExample/WCPaymentProductsViewController.h>
#import <WorldlineConnectExample/WCPaymentProductViewController.h>
#import <WorldlineConnectExample/WCJsonDialogViewController.h>
#import <WorldlineConnectExample/WCEndViewController.h>
#import <WorldlineConnectExample/WCPaymentProductsViewControllerTarget.h>
#import <WorldlineConnectExample/WCStartPaymentParsedJsonData.h>

#import <WorldlineConnectSDK/WCPaymentAmountOfMoney.h>
#import <WorldlineConnectSDK/WCPaymentProductGroup.h>
#import <WorldlineConnectSDK/WCBasicPaymentProductGroup.h>

@interface WCStartViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *parsableFieldsContainer;

@property (strong, nonatomic) UITextView *explanation;
@property (strong, nonatomic) WCLabel *clientSessionIdLabel;
@property (strong, nonatomic) WCTextField *clientSessionIdTextField;
@property (strong, nonatomic) WCLabel *customerIdLabel;
@property (strong, nonatomic) WCTextField *customerIdTextField;
@property (strong, nonatomic) WCLabel *baseURLLabel;
@property (strong, nonatomic) WCTextField *baseURLTextField;
@property (strong, nonatomic) WCLabel *assetsBaseURLLabel;
@property (strong, nonatomic) WCTextField *assetsBaseURLTextField;
@property (strong, nonatomic) UIButton *jsonButton;
@property (strong, nonatomic) WCLabel *merchantIdLabel;
@property (strong, nonatomic) WCTextField *merchantIdTextField;
@property (strong, nonatomic) WCLabel *amountLabel;
@property (strong, nonatomic) WCTextField *amountTextField;
@property (strong, nonatomic) WCLabel *countryCodeLabel;
@property (strong, nonatomic) WCTextField *countryCodeTextField;
@property (strong, nonatomic) WCLabel *currencyCodeLabel;
@property (strong, nonatomic) WCTextField *currencyCodeTextField;
@property (strong, nonatomic) WCLabel *isRecurringLabel;
@property (strong, nonatomic) WCSwitch *isRecurringSwitch;
@property (strong, nonatomic) UIButton *payButton;
@property (strong, nonatomic) WCLabel *groupMethodsLabel;
@property (strong, nonatomic) UISwitch *groupMethodsSwitch;
@property (strong, nonatomic) WCPaymentProductsViewControllerTarget *paymentProductsViewControllerTarget;

@property (nonatomic) long amountValue;

@property (strong, nonatomic) WCViewFactory *viewFactory;
@property (strong, nonatomic) WCSession *session;
@property (strong, nonatomic) WCPaymentContext *context;

@property (strong, nonatomic) WCJsonDialogViewController *jsonDialogViewController;

@end

@implementation WCStartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeTapRecognizer];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)] == YES) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.viewFactory = [[WCViewFactory alloc] init];
    self.jsonDialogViewController = [[WCJsonDialogViewController alloc] init];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delaysContentTouches = NO;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scrollView];
    
    UIView *superContainerView = [[UIView alloc] init];
    superContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    superContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:superContainerView];
    
    self.containerView = [[UIView alloc] init];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [superContainerView addSubview:self.containerView];


    self.explanation = [[UITextView alloc] init];
    self.explanation.translatesAutoresizingMaskIntoConstraints = NO;
    self.explanation.text = NSLocalizedStringFromTable(@"SetupExplanation", kWCAppLocalizable, @"To process a payment using the services provided by the Worldline Global Collect platform, the following information must be provided by a merchant.\n\nAfter providing the information requested below, this example app can process a payment.");
    self.explanation.editable = NO;
    self.explanation.backgroundColor = [UIColor colorWithRed:0.85 green:0.94 blue:0.97 alpha:1];
    self.explanation.textColor = [UIColor colorWithRed:0 green:0.58 blue:0.82 alpha:1];
    self.explanation.layer.cornerRadius = 5.0;
    self.explanation.scrollEnabled = NO;
    [self.containerView addSubview:self.explanation];

    self.parsableFieldsContainer = [[UIView alloc] init];
    self.parsableFieldsContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.parsableFieldsContainer.layer.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2].CGColor;
    self.parsableFieldsContainer.layer.cornerRadius = 10;
    [self.containerView addSubview:self.parsableFieldsContainer];

    self.clientSessionIdLabel = [self.viewFactory labelWithType:WCLabelType];
    self.clientSessionIdLabel.text = NSLocalizedStringFromTable(@"ClientSessionIdentifier", kWCAppLocalizable, @"Client session identifier");
    self.clientSessionIdLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.clientSessionIdTextField = [self.viewFactory textFieldWithType:WCTextFieldType];
    self.clientSessionIdTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.clientSessionIdTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.clientSessionIdTextField.text = [StandardUserDefaults objectForKey:kWCClientSessionId];
    self.clientSessionIdTextField.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];

    [self.parsableFieldsContainer addSubview:self.clientSessionIdLabel];
    [self.parsableFieldsContainer addSubview:self.clientSessionIdTextField];

    self.customerIdLabel = [self.viewFactory labelWithType:WCLabelType];
    self.customerIdLabel.text = NSLocalizedStringFromTable(@"CustomerIdentifier", kWCAppLocalizable, @"Customer identifier");
    self.customerIdLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.customerIdTextField = [self.viewFactory textFieldWithType:WCTextFieldType];
    self.customerIdTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.customerIdTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.customerIdTextField.text = [StandardUserDefaults objectForKey:kWCCustomerId];
    self.customerIdTextField.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];

    [self.parsableFieldsContainer addSubview:self.customerIdLabel];
    [self.parsableFieldsContainer addSubview:self.customerIdTextField];
    
    self.baseURLLabel = [self.viewFactory labelWithType:WCLabelType];
    self.baseURLLabel.text = NSLocalizedStringFromTable(@"BaseURL", kWCAppLocalizable, @"Client session identifier");
    self.baseURLLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.baseURLTextField = [self.viewFactory textFieldWithType:WCTextFieldType];
    self.baseURLTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.baseURLTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.baseURLTextField.text = [StandardUserDefaults objectForKey:kWCBaseURL];
    self.baseURLTextField.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];

    [self.parsableFieldsContainer addSubview:self.baseURLLabel];
    [self.parsableFieldsContainer addSubview:self.baseURLTextField];
    
    self.assetsBaseURLLabel = [self.viewFactory labelWithType:WCLabelType];
    self.assetsBaseURLLabel.text = NSLocalizedStringFromTable(@"AssetsBaseURL", kWCAppLocalizable, @"Customer identifier");
    self.assetsBaseURLLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.assetsBaseURLTextField = [self.viewFactory textFieldWithType:WCTextFieldType];
    self.assetsBaseURLTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.assetsBaseURLTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.assetsBaseURLTextField.text = [StandardUserDefaults objectForKey:kWCAssetsBaseURL];
    self.assetsBaseURLTextField.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];

    [self.parsableFieldsContainer addSubview:self.assetsBaseURLLabel];
    [self.parsableFieldsContainer addSubview:self.assetsBaseURLTextField];

    self.jsonButton = [self.viewFactory buttonWithType:WCButtonTypeSecondary];
    self.jsonButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.jsonButton.backgroundColor = [UIColor lightGrayColor];
    [self.jsonButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.jsonButton setTitle:NSLocalizedStringFromTable(@"Paste", kWCAppLocalizable, nil) forState:UIControlStateNormal];
    [self.jsonButton addTarget:self action:@selector(presentJsonDialog) forControlEvents:UIControlEventTouchUpInside];
    [self.parsableFieldsContainer addSubview:self.jsonButton];


    self.merchantIdLabel = [self.viewFactory labelWithType:WCLabelType];
    self.merchantIdLabel.text = NSLocalizedStringFromTable(@"MerchantIdentifier", kWCAppLocalizable, @"Merchant identifier");
    self.merchantIdLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.merchantIdTextField = [self.viewFactory textFieldWithType:WCTextFieldType];
    self.merchantIdTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.merchantIdTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.merchantIdTextField.text = [StandardUserDefaults objectForKey:kWCMerchantId];
    [self.containerView addSubview:self.merchantIdLabel];
    [self.containerView addSubview:self.merchantIdTextField];
    
    self.amountLabel = [self.viewFactory labelWithType:WCLabelType];
    self.amountLabel.text = NSLocalizedStringFromTable(@"AmountInCents", kWCAppLocalizable, @"Amount in cents");
    self.amountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.amountTextField = [self.viewFactory textFieldWithType:WCTextFieldType];
    self.amountTextField.translatesAutoresizingMaskIntoConstraints = NO;
    NSInteger amount = [[NSUserDefaults standardUserDefaults] integerForKey:kWCPrice];
    if (amount == 0) {
        self.amountTextField.text = @"100";
    }
    else {
        self.amountTextField.text = [NSString stringWithFormat:@"%ld", (long)amount];

    }
    [self.containerView addSubview:self.amountLabel];
    [self.containerView addSubview:self.amountTextField];
    
    self.countryCodeLabel = [self.viewFactory labelWithType:WCLabelType];
    self.countryCodeLabel.text = NSLocalizedStringFromTable(@"CountryCode", kWCAppLocalizable, @"Country code");
    self.countryCodeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.countryCodeTextField = [self.viewFactory textFieldWithType:WCTextFieldType];
    self.countryCodeTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.countryCodeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.countryCodeTextField.text = [StandardUserDefaults objectForKey:kWCCountryCode];
    [self.containerView addSubview:self.countryCodeLabel];
    [self.containerView addSubview:self.countryCodeTextField];
    
    self.currencyCodeLabel = [self.viewFactory labelWithType:WCLabelType];
    self.currencyCodeLabel.text = NSLocalizedStringFromTable(@"CurrencyCode", kWCAppLocalizable, @"Currency code");
    self.currencyCodeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.currencyCodeTextField = [self.viewFactory textFieldWithType:WCTextFieldType];
    self.currencyCodeTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.currencyCodeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.currencyCodeTextField.text = [StandardUserDefaults objectForKey:kWCCurrency];
    [self.containerView addSubview:self.currencyCodeLabel];
    [self.containerView addSubview:self.currencyCodeTextField];
    
    self.isRecurringLabel = [self.viewFactory labelWithType:WCLabelType];
    self.isRecurringLabel.text = NSLocalizedStringFromTable(@"RecurringPayment", kWCAppLocalizable, @"Payment is recurring");
    self.isRecurringLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.isRecurringSwitch = [self.viewFactory switchWithType:WCSwitchType];
    self.isRecurringSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.isRecurringLabel];
    [self.containerView addSubview:self.isRecurringSwitch];
    
    self.groupMethodsLabel = [self.viewFactory labelWithType:WCLabelType];
    self.groupMethodsLabel.text = NSLocalizedStringWithDefaultValue(@"GroupMethods", kWCAppLocalizable, [NSBundle bundleWithPath:kWCSDKBundlePath], @"Group payment products", @"");
    //groupMethodsLabel.text = NSLocalizedStringFromTable(@"GroupMethods", kWCAppLocalizable, @"Display payment methods as group");
    self.groupMethodsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.groupMethodsSwitch = [self.viewFactory switchWithType:WCSwitchType];
    self.groupMethodsSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.groupMethodsLabel];
    [self.containerView addSubview:self.groupMethodsSwitch];

    self.payButton = [self.viewFactory buttonWithType:WCButtonTypePrimary];
    [self.payButton setTitle:NSLocalizedStringFromTable(@"PayNow", kWCAppLocalizable, @"Pay securely now") forState:UIControlStateNormal];
    self.payButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.payButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.payButton];

    NSDictionary *views = NSDictionaryOfVariableBindings(_explanation, _clientSessionIdLabel, _clientSessionIdTextField, _customerIdLabel, _customerIdTextField, _baseURLLabel, _baseURLTextField, _assetsBaseURLLabel, _assetsBaseURLTextField, _jsonButton, _merchantIdLabel, _merchantIdTextField, _amountLabel, _amountTextField, _countryCodeLabel, _countryCodeTextField, _currencyCodeLabel, _currencyCodeTextField, _isRecurringLabel, _isRecurringSwitch, _payButton, _groupMethodsLabel, _groupMethodsSwitch, _parsableFieldsContainer, _containerView, _scrollView, superContainerView);
    NSDictionary *metrics = @{@"fieldSeparator": @"24", @"groupSeparator": @"72"};

    // ParsableFieldsContainer Constraints
    [self.parsableFieldsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_clientSessionIdLabel]-|" options:0 metrics:nil views:views]];
    [self.parsableFieldsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_clientSessionIdTextField]-|" options:0 metrics:nil views:views]];
    [self.parsableFieldsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_customerIdLabel]-|" options:0 metrics:nil views:views]];
    [self.parsableFieldsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_customerIdTextField]-|" options:0 metrics:nil views:views]];
    [self.parsableFieldsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_baseURLLabel]-|" options:0 metrics:nil views:views]];
    [self.parsableFieldsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_baseURLTextField]-|" options:0 metrics:nil views:views]];
    [self.parsableFieldsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_assetsBaseURLLabel]-|" options:0 metrics:nil views:views]];
    [self.parsableFieldsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_assetsBaseURLTextField]-|" options:0 metrics:nil views:views]];
    [self.parsableFieldsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_jsonButton(>=120)]-|" options:0 metrics:nil views:views]];
    [self.parsableFieldsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_clientSessionIdLabel]-[_clientSessionIdTextField]-(fieldSeparator)-[_customerIdLabel]-[_customerIdTextField]-(fieldSeparator)-[_baseURLLabel]-[_baseURLTextField]-(fieldSeparator)-[_assetsBaseURLLabel]-[_assetsBaseURLTextField]-(fieldSeparator)-[_jsonButton]-|" options:0 metrics:metrics views:views]];

    // ContainerView constraints
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_explanation]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_parsableFieldsContainer]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_merchantIdLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_merchantIdTextField]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_amountLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_amountTextField]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_countryCodeLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_countryCodeTextField]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_currencyCodeLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_currencyCodeTextField]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_isRecurringLabel]-[_isRecurringSwitch]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_groupMethodsLabel]-[_groupMethodsSwitch]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_payButton]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_explanation]-(fieldSeparator)-[_parsableFieldsContainer]-(fieldSeparator)-[_merchantIdLabel]-[_merchantIdTextField]-(groupSeparator)-[_amountLabel]-[_amountTextField]-(fieldSeparator)-[_countryCodeLabel]-[_countryCodeTextField]-(fieldSeparator)-[_currencyCodeLabel]-[_currencyCodeTextField]-(fieldSeparator)-[_isRecurringSwitch]-(fieldSeparator)-[_groupMethodsSwitch]-(fieldSeparator)-[_payButton]-|" options:0 metrics:metrics views:views]];

    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:superContainerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0], [NSLayoutConstraint constraintWithItem:superContainerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[superContainerView]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[superContainerView]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]|" options:0 metrics:nil views:views]];
    [superContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_containerView]|" options:0 metrics:nil views:views]];
    [superContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:320]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

- (void)initializeTapRecognizer
{
    UITapGestureRecognizer *tapScrollView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapped)];
    tapScrollView.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapScrollView];
}

- (void)tableViewTapped
{
    for (UIView *view in self.containerView.subviews) {
        if ([view class] == [WCTextField class]) {
            WCTextField *textField = (WCTextField *)view;
            if ([textField isFirstResponder] == YES) {
                [textField resignFirstResponder];
            }
        }
    }
}

#pragma mark -
- (BOOL)checkURL:(NSString *)url
{
    NSMutableArray<NSString *> *components;
    if (@available(iOS 7.0, *)) {
        NSURLComponents *finalComponents = [NSURLComponents componentsWithString:url];
        components = [[finalComponents.path componentsSeparatedByString:@"/"] filteredArrayUsingPredicate:
                      [NSPredicate predicateWithFormat:@"length > 0"]].mutableCopy;
    }
    else {
        components = [[[NSURL URLWithString:url].path componentsSeparatedByString:@"/"] filteredArrayUsingPredicate:
                      [NSPredicate predicateWithFormat:@"length > 0"]].mutableCopy;
    }
    
    
    NSArray<NSString *> *versionComponents = [kWCAPIVersion componentsSeparatedByString:@"/"];
    switch (components.count) {
        case 0: {
            components = versionComponents.mutableCopy;
            break;
        }
        case 1: {
            if (![components[0] isEqualToString:versionComponents[0]]) {
                return NO;
            }
            [components addObject:versionComponents[1]];
            break;
        }
        case 2: {
            if (![components[0] isEqualToString:versionComponents[0]]) {
                return NO;
            }
            if (![components[1] isEqualToString:versionComponents[1]]) {
                return NO;
            }
            break;
        }
        default: {
            return NO;
            break;
        }
    }
    return YES;
}


#pragma mark -
#pragma mark Button actions

- (void)buyButtonTapped:(UIButton *)sender
{
    if (self.payButton == sender) {
        self.amountValue = (long) [self.amountTextField.text longLongValue];
    } else {
        [NSException raise:@"Invalid sender" format:@"Sender %@ is invalid", sender];
    }

    [SVProgressHUD showWithStatus:NSLocalizedStringFromTableInBundle(@"gc.app.general.loading.body", kWCSDKLocalizable, [NSBundle bundleWithPath:kWCSDKBundlePath], nil)];

    NSString *clientSessionId = self.clientSessionIdTextField.text;
    [StandardUserDefaults setObject:clientSessionId forKey:kWCClientSessionId];
    NSString *customerId = self.customerIdTextField.text;
    [StandardUserDefaults setObject:customerId forKey:kWCCustomerId];
    NSString *baseURL = self.baseURLTextField.text;
    [StandardUserDefaults setObject:baseURL forKey:kWCBaseURL];
    NSString *assetsBaseURL = self.assetsBaseURLTextField.text;
    [StandardUserDefaults setObject:assetsBaseURL forKey:kWCAssetsBaseURL];

    if (self.merchantIdTextField.text != nil) {
        NSString *merchantId = self.merchantIdTextField.text;
        [StandardUserDefaults setObject:merchantId forKey:kWCMerchantId];
    }
    [StandardUserDefaults setInteger:self.amountValue forKey:kWCPrice];
    NSString *countryCode = self.countryCodeTextField.text;
    [StandardUserDefaults setObject:countryCode forKey:kWCCountryCode];
    NSString *currencyCode = self.currencyCodeTextField.text;
    [StandardUserDefaults setObject:currencyCode forKey:kWCCurrency];
    
    // ***************************************************************************
    //
    // The Worldline Connect SDK supports processing payments with instances of the
    // WCSession class. The code below shows how such an instance chould be
    // instantiated.
    //
    // The WCSession class uses a number of supporting objects. There is an
    // initializer for this class that takes these supporting objects as
    // arguments. This should make it easy to replace these additional objects
    // without changing the implementation of the SDK. Use this initializer
    // instead of the factory method used below if you want to replace any of the
    // supporting objects.
    //
    // ***************************************************************************
    if (![self checkURL:baseURL]) {
        [SVProgressHUD dismiss];
        NSMutableArray<NSString *> *components;
        if (@available(iOS 7.0, *)) {
            NSURLComponents *finalComponents = [NSURLComponents componentsWithString:baseURL];
            components = [[finalComponents.path componentsSeparatedByString:@"/"] filteredArrayUsingPredicate:
                          [NSPredicate predicateWithFormat:@"length > 0"]].mutableCopy;
        }
        else {
            components = [[[NSURL URLWithString:baseURL].path componentsSeparatedByString:@"/"] filteredArrayUsingPredicate:
                          [NSPredicate predicateWithFormat:@"length > 0"]].mutableCopy;
        }
        NSArray<NSString *> *versionComponents = [kWCAPIVersion componentsSeparatedByString:@"/"];
        NSString *alertReason = [NSString stringWithFormat: @"This version of the connectSDK is only compatible with %@ , you supplied: '%@'",
                                 [versionComponents componentsJoinedByString: @"/"],
                                 [components componentsJoinedByString: @"/"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"InvalidBaseURLTitle", kWCAppLocalizable, @"Title of the connection error dialog.") message:NSLocalizedStringFromTable(alertReason, kWCAppLocalizable, nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    // ***************************************************************************
    //
    // You can log of requests made to the server and responses received from the server by passing the `loggingEnabled` parameter to the Session constructor.
    // In the constructor below, the logging is disabled.
    // You are also able to disable / enable logging at a later stage by calling `[session setLoggingEnabled:]`, as shown below.
    // Logging should be disabled in production.
    // To use logging in debug, but not in production, you can set `loggingEnabled` within a DEBUG flag.
    // In Objective-C the DEBUG flag is defined as a preprocessor macro. You can take a look at this app's build settings to see the setup you should apply to your own app.
    //
    // ***************************************************************************

    self.session = [WCSession sessionWithClientSessionId:clientSessionId customerId:customerId baseURL:baseURL assetBaseURL:assetsBaseURL appIdentifier:kWCApplicationIdentifier loggingEnabled:NO];

    #if DEBUG
        [self.session setLoggingEnabled:YES];
    #endif

    BOOL isRecurring = self.isRecurringSwitch.on;

    // ***************************************************************************
    //
    // To retrieve the available payment products, the information stored in the
    // following WCPaymentContext object is needed.
    //
    // After the WCSession object has retrieved the payment products that match
    // the information stored in the WCPaymentContext object, a
    // selection screen is shown. This screen itself is not part of the SDK and
    // only illustrates a possible payment product selection screen.
    //
    // ***************************************************************************
    WCPaymentAmountOfMoney *amountOfMoney = [[WCPaymentAmountOfMoney alloc] initWithTotalAmount:self.amountValue currencyCode:currencyCode];
    self.context = [[WCPaymentContext alloc] initWithAmountOfMoney:amountOfMoney isRecurring:isRecurring countryCode:countryCode];

    [self.session paymentItemsForContext:self.context groupPaymentProducts:self.groupMethodsSwitch.isOn success:^(WCPaymentItems *paymentItems) {
        [SVProgressHUD dismiss];
        [self showPaymentProductSelection:paymentItems];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"ConnectionErrorTitle", kWCAppLocalizable, @"Title of the connection error dialog.") message:NSLocalizedStringFromTable(@"PaymentProductsErrorExplanation", kWCAppLocalizable, nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

-(void)showPaymentProductSelection:(WCPaymentItems *)paymentItems
{
    self.paymentProductsViewControllerTarget = [[WCPaymentProductsViewControllerTarget alloc] initWithNavigationController:self.navigationController session:self.session context:self.context viewFactory:self.viewFactory];
    self.paymentProductsViewControllerTarget.paymentFinishedTarget = self;
    WCPaymentProductsViewController *paymentProductSelection = [[WCPaymentProductsViewController alloc] init];
    paymentProductSelection.target = self.paymentProductsViewControllerTarget;
    paymentProductSelection.paymentItems = paymentItems;
    paymentProductSelection.viewFactory = self.viewFactory;
    paymentProductSelection.amount = self.amountValue;
    paymentProductSelection.currencyCode = self.context.amountOfMoney.currencyCode;
    [self.navigationController pushViewController:paymentProductSelection animated:YES];
    [SVProgressHUD dismiss];
}

- (void)presentJsonDialog
{
    self.jsonDialogViewController.callback = self;
    [self presentViewController:self.jsonDialogViewController animated:YES completion:nil];
}

#pragma mark -
#pragma mark Continue shopping target

- (void)didSelectContinueShopping
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Payment finished target

- (void)didFinishPayment:(WCPreparedPaymentRequest *)preparedPaymentRequest {
    WCEndViewController *end = [[WCEndViewController alloc] init];
    end.target = self;
    end.viewFactory = self.viewFactory;
    end.preparedPaymentRequest = preparedPaymentRequest;
    [self.navigationController pushViewController:end animated:YES];
}

#pragma mark -
#pragma mark Parse Json target
- (void)success:(WCStartPaymentParsedJsonData *)data {
    if (data.clientApiUrl != nil) {
        self.baseURLTextField.text = data.clientApiUrl;
    }
    if (data.assetUrl != nil) {
        self.assetsBaseURLTextField.text = data.assetUrl;
    }
    if (data.clientSessionId != nil) {
        self.clientSessionIdTextField.text = data.clientSessionId;
    }
    if (data.customerId != nil) {
        self.customerIdTextField.text = data.customerId;
    }
}

#pragma mark -
@end
