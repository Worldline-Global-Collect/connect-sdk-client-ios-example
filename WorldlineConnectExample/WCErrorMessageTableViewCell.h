//
//  WCErrorMessageTableViewCell.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCTableViewCell.h>

@interface WCErrorMessageTableViewCell : WCTableViewCell

+ (NSString *)reuseIdentifier;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
