//
//  WCParseJsonTarget.h
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 22/04/2021.
//  Copyright (c) 2021 Worldline Global Collect. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WCParseJsonTarget;


@interface WCJsonDialogViewController : UIViewController
@property (weak, nonatomic) id <WCParseJsonTarget> callback;
@end
