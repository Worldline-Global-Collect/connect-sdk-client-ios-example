//
//  WCExternalAppStatusViewController.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 14/07/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import "WCExternalAppStatusViewController.h"
#import <WCThirdPartyStatus.h>
#import "WCStatusView.h"
#import <WorldlineConnectSDK/WCSDKConstants.h>
#import "WCAppConstants.h"
@interface WCExternalAppStatusViewController ()
@property (nonatomic, strong) WCStatusView *startStatus;
@property (nonatomic, strong) WCStatusView *authorizedStatus;
@property (nonatomic, strong) WCStatusView *endStatus;
@property (nonatomic, strong) UILabel *descriptiveLabel;
@end

@implementation WCExternalAppStatusViewController
-(void)setExternalAppStatus:(WCThirdPartyStatus)thirdPartyStatus
{
    _externalAppStatus = thirdPartyStatus;
    switch (_externalAppStatus) {
        case WCThirdPartyStatusWaiting:
            [self.startStatus setStatus:WCStatusViewStatusProgress];
            [self.authorizedStatus setStatus:WCStatusViewStatusWaiting];
            [self.endStatus setStatus:WCStatusViewStatusWaiting];
            break;
        case WCThirdPartyStatusInitialized:
            [self.startStatus setStatus:WCStatusViewStatusFinished];
            [self.authorizedStatus setStatus:WCStatusViewStatusProgress];
            [self.endStatus setStatus:WCStatusViewStatusWaiting];
            break;
        case WCThirdPartyStatusAuthorized:
            [self.startStatus setStatus:WCStatusViewStatusFinished];
            [self.authorizedStatus setStatus:WCStatusViewStatusFinished];
            [self.endStatus setStatus:WCStatusViewStatusProgress];
            break;
        case WCThirdPartyStatusCompleted:
            [self.startStatus setStatus:WCStatusViewStatusFinished];
            [self.authorizedStatus setStatus:WCStatusViewStatusFinished];
            [self.endStatus setStatus:WCStatusViewStatusFinished];
            break;

        default:
            break;
    }
    
}
-(void)loadView {
    [super loadView];
    CGFloat inset = 20.0;
    
    // Label with description
    {
        self.descriptiveLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - 320/2, inset, 320, 40)];
        NSString *key = @"gc.general.paymentProducts.3012.processing";
        self.descriptiveLabel.text = NSLocalizedStringFromTableInBundle(key, kWCSDKLocalizable, [NSBundle bundleWithPath:kWCSDKBundlePath], "");
        self.descriptiveLabel.numberOfLines = 0;
        CGRect bounds = self.descriptiveLabel.frame;
        bounds.size = [self.descriptiveLabel sizeThatFits:CGSizeMake(320, CGFLOAT_MAX)];

        self.descriptiveLabel.frame = bounds;
        [self.view addSubview:self.descriptiveLabel];
    }
    
    // Initialization Status
    {
        UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - 320/2, inset + 40, 320, 40)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, containerView.frame.size.width - 40, 40)];
        NSString *key = @"gc.general.paymentProducts.3012.paymentStatus1";
        label.text = NSLocalizedStringFromTableInBundle(key, kWCSDKLocalizable, [NSBundle bundleWithPath:kWCSDKBundlePath], "");
        self.startStatus = [[WCStatusView alloc]initWithFrame:CGRectMake(0, 0, 40, 40) andStatus:WCStatusViewStatusProgress];
        [containerView addSubview: self.startStatus];
        [containerView addSubview:label];
        [self.view addSubview:containerView];
    }

    // Authorization Status
    {
        UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - 320/2, inset + 80, 320, 40)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, containerView.frame.size.width - 40, 40)];
        NSString *key = @"gc.general.paymentProducts.3012.paymentStatus2";
        label.text = NSLocalizedStringFromTableInBundle(key, kWCSDKLocalizable, [NSBundle bundleWithPath:kWCSDKBundlePath], "");
        self.authorizedStatus = [[WCStatusView alloc]initWithFrame:CGRectMake(0, 0, 40, 40) andStatus:WCStatusViewStatusWaiting];
        [containerView addSubview: self.authorizedStatus];
        [containerView addSubview:label];
        [self.view addSubview:containerView];
    }
    
    // Finishing Status
    {
        UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - 320/2, inset + 120, 320, 40)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, containerView.frame.size.width - 40, 40)];
        NSString *key = @"gc.general.paymentProducts.3012.paymentStatus3";
        label.text = NSLocalizedStringFromTableInBundle(key, kWCSDKLocalizable, [NSBundle bundleWithPath:kWCSDKBundlePath], "");
        self.endStatus = [[WCStatusView alloc]initWithFrame:CGRectMake(0, 0, 40, 40) andStatus:WCStatusViewStatusWaiting];
        [containerView addSubview: self.endStatus];
        [containerView addSubview:label];
        [self.view addSubview:containerView];
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
