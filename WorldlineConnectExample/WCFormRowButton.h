//
//  WCFormRowButton.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCFormRow.h>
#import <WorldlineConnectExample/WCButton.h>

@interface WCFormRowButton : WCFormRow

- (instancetype _Nonnull)initWithTitle: (nonnull NSString *) title target: (nonnull id)target action: (nonnull SEL)action;

@property (strong, nonatomic) NSString * _Nonnull title;
@property (strong, nonatomic) id _Nonnull target;
@property (assign, nonatomic) WCButtonType buttonType;
@property (assign, nonatomic) SEL _Nonnull action;

@end
