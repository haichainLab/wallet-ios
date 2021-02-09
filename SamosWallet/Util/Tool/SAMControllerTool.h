//
//  SAMControllerTool.h
//  SamosWallet
//
//  Created by zys on 2018/8/29.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 项目Controller相关的方法
 */

#import <Foundation/Foundation.h>

@interface SAMControllerTool : NSObject

/**
 设置root vc：
    1.第一次安装，显示蓝色管理钱包页（设置钱包密码弹窗）
    2.创建或导入钱包后，第一次显示引导页
    3.设置了密码，创建或导入钱包后，显示tabvc
 */
+ (void)chooseRootVC;

/**
 通过scheme跳转

 @param scheme 跳转地址
 */
+ (void)chooseVCWithScheme:(NSString *)scheme;

/**
 获取当前vc

 @return 当前显示的vc
 */
+ (UIViewController *)currentVC;


/**
 显示vc

 @param vc 要显示的vc
 */
+ (void)showVC:(UIViewController *)vc;

@end
