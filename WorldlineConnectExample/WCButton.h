//
//  WCButton.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 11/05/2017.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    WCButtonTypePrimary = 0,
    WCButtonTypeSecondary = 1,
    WCButtonTypeDestructive = 2
} WCButtonType;

@interface WCButton : UIButton

@property (assign, nonatomic) WCButtonType type;

@end
