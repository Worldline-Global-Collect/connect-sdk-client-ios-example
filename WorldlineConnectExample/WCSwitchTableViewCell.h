//
//  WCSwitchTableViewCell.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCTableViewCell.h>
@class WCSwitchTableViewCell;
@class WCSwitch;
@protocol WCSwitchTableViewCellDelegate
-(void)switchChanged:(WCSwitch *)aSwitch;
@end
@interface WCSwitchTableViewCell : WCTableViewCell 
@property (weak, nonatomic) NSObject<WCSwitchTableViewCellDelegate> *delegate;
@property (strong, nonatomic) NSString *errorMessage;
@property (assign, nonatomic, getter=isOn) BOOL on;
@property (assign, nonatomic) BOOL readonly;
+ (NSString *)reuseIdentifier;

- (NSAttributedString *)attributedTitle;
- (void)setAttributedTitle:(NSAttributedString *)attributedTitle;

- (void)setSwitchTarget:(id)target action:(SEL)action;


@end
