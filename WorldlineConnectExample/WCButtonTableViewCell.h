//
//  WCButtonTableViewCell.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCTableViewCell.h>
#import <WorldlineConnectExample/WCButton.h>

@interface WCButtonTableViewCell : WCTableViewCell

+ (NSString *)reuseIdentifier;

- (BOOL)isEnabled;
- (void)setIsEnabled:(BOOL)enabled;

- (WCButtonType)buttonType;
- (void)setButtonType:(WCButtonType)type;

- (NSString *)title;
- (void)setTitle:(NSString *)title;

- (void)setClickTarget:(id)target action:(SEL)action;

@end
