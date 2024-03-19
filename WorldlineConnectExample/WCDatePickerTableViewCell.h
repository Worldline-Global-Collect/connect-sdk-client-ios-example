//
//  WCDatePickerTableViewCell.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 09/10/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCTableViewCell.h"
@protocol WCDatePickerTableViewCellDelegate
-(void)datePicker:(UIDatePicker *)datePicker selectedNewDate:(NSDate *)newDate;
@end
@interface WCDatePickerTableViewCell : WCTableViewCell {
    NSDate *_date;
}
+(NSString *)reuseIdentifier;
@property (nonatomic, weak) NSObject<WCDatePickerTableViewCellDelegate> *delegate;
+(NSUInteger)pickerHeight;
@property (nonatomic, assign) BOOL readonly;
@property (nonatomic, strong) NSDate *date;
@end
