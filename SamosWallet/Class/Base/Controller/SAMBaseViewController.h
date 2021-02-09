//
//  SAMBaseViewController.h
//  SamosWallet
//
//  Created by zys on 2018/8/18.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 项目里所有Controller基类
 */

#import <UIKit/UIKit.h>
#import "SAMNavigationBar.h"

@interface SAMBaseViewController : UIViewController

/// 是否显示导航栏
@property (nonatomic, assign) BOOL isShowNavBar;
/// 导航栏背景色（透明或者白色）
@property (nonatomic, assign) SAMNavigationBarBGColor navBGColor;
/// 导航栏
@property (nonatomic, strong, readonly) SAMNavigationBar *sam_navigationBar;

- (void)setupVariables;
- (void)setupSubviews;
- (void)showBackBtn:(BOOL)show;

@end
