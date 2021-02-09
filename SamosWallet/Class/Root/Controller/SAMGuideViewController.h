//
//  SAMGuideViewController.h
//  SamosWallet
//
//  Created by zys on 2018/8/28.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 引导页
 */

#import "SAMBaseViewController.h"

@interface SAMGuideViewController : SAMBaseViewController

/// dismiss回调
@property (nonatomic, copy) SAMVoidBlock dismissBlock;
+ (BOOL)shouldShow;

@end
