//
//  WCProgressView.m
//  WorldlineConnectExample
// 
//  Created for Worldline Global Collect on 15/09/2026.
//  Copyright © 2026 Worldline Global Collect. All rights reserved.
//
#import "WCProgressView.h"

@interface WCProgressView ()

@property (nonatomic, strong, nullable) UIView *dimmingView;
@property (nonatomic, strong, nullable) UIView *hudView;

@end

@implementation WCProgressView

#pragma mark - Singleton

+ (instancetype)sharedInstance {
    static WCProgressView *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WCProgressView alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Public class methods

+ (void)showWithStatus:(nullable NSString *)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[WCProgressView sharedInstance] _showWithStatus:status];
    });
}

+ (void)dismiss {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[WCProgressView sharedInstance] _dismiss];
    });
}

#pragma mark - Private

- (void)_showWithStatus:(nullable NSString *)status {
    UIWindow *window = [self _keyWindow];
    if (!window) return;

    // Tear down any existing HUD instantly before showing a new one
    [self _tearDownViews];

    // Dimming overlay
    UIView *dimmingView = [[UIView alloc] init];
    dimmingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.35];
    dimmingView.translatesAutoresizingMaskIntoConstraints = NO;

    // HUD card
    UIView *hudView = [[UIView alloc] init];
    hudView.layer.cornerRadius = 14.0;
    hudView.clipsToBounds = YES;
    hudView.translatesAutoresizingMaskIntoConstraints = NO;

    // Blur background (mirrors SVProgressHUDStyleDark)
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    blurView.translatesAutoresizingMaskIntoConstraints = NO;

    // Spinner
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    spinner.color = UIColor.whiteColor;
    spinner.translatesAutoresizingMaskIntoConstraints = NO;
    [spinner startAnimating];

    // Vertical stack: spinner + optional label
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 12.0;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [stackView addArrangedSubview:spinner];

    if (status.length > 0) {
        UILabel *statusLabel = [[UILabel alloc] init];
        statusLabel.text = status;
        statusLabel.textColor = UIColor.whiteColor;
        statusLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.numberOfLines = 0;
        statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [stackView addArrangedSubview:statusLabel];
    }

    [hudView addSubview:blurView];
    [hudView addSubview:stackView];
    [window addSubview:dimmingView];
    [window addSubview:hudView];

    [NSLayoutConstraint activateConstraints:@[
        // Dimming overlay fills window
        [dimmingView.topAnchor constraintEqualToAnchor:window.topAnchor],
        [dimmingView.bottomAnchor constraintEqualToAnchor:window.bottomAnchor],
        [dimmingView.leadingAnchor constraintEqualToAnchor:window.leadingAnchor],
        [dimmingView.trailingAnchor constraintEqualToAnchor:window.trailingAnchor],

        // HUD centred, minimum width, max 60% of window width
        [hudView.centerXAnchor constraintEqualToAnchor:window.centerXAnchor],
        [hudView.centerYAnchor constraintEqualToAnchor:window.centerYAnchor],
        [hudView.widthAnchor constraintGreaterThanOrEqualToConstant:120.0],
        [hudView.widthAnchor constraintLessThanOrEqualToAnchor:window.widthAnchor multiplier:0.6],

        // Blur fills HUD card
        [blurView.topAnchor constraintEqualToAnchor:hudView.topAnchor],
        [blurView.bottomAnchor constraintEqualToAnchor:hudView.bottomAnchor],
        [blurView.leadingAnchor constraintEqualToAnchor:hudView.leadingAnchor],
        [blurView.trailingAnchor constraintEqualToAnchor:hudView.trailingAnchor],

        // Stack inset inside HUD card
        [stackView.topAnchor constraintEqualToAnchor:hudView.topAnchor constant:24.0],
        [stackView.bottomAnchor constraintEqualToAnchor:hudView.bottomAnchor constant:-24.0],
        [stackView.leadingAnchor constraintEqualToAnchor:hudView.leadingAnchor constant:24.0],
        [stackView.trailingAnchor constraintEqualToAnchor:hudView.trailingAnchor constant:-24.0],
    ]];

    self.dimmingView = dimmingView;
    self.hudView = hudView;

    // Fade in
    dimmingView.alpha = 0.0;
    hudView.alpha = 0.0;
    [UIView animateWithDuration:0.2 animations:^{
        dimmingView.alpha = 1.0;
        hudView.alpha = 1.0;
    }];
}

- (void)_dismiss {
    UIView *dimmingView = self.dimmingView;
    UIView *hudView = self.hudView;

    // Nil out immediately to guard against overlapping dismiss calls
    self.dimmingView = nil;
    self.hudView = nil;

    [UIView animateWithDuration:0.2 animations:^{
        dimmingView.alpha = 0.0;
        hudView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [dimmingView removeFromSuperview];
        [hudView removeFromSuperview];
    }];
}

- (void)_tearDownViews {
    [self.dimmingView removeFromSuperview];
    [self.hudView removeFromSuperview];
    self.dimmingView = nil;
    self.hudView = nil;
}

- (nullable UIWindow *)_keyWindow {
    for (UIWindowScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (scene.activationState == UISceneActivationStateForegroundActive) {
            for (UIWindow *window in ((UIWindowScene *)scene).windows) {
                if (window.isKeyWindow) return window;
            }
        }
    }
    return nil;
}

@end
