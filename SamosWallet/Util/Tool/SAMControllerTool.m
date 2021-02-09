//
//  SAMControllerTool.m
//  SamosWallet
//
//  Created by zys on 2018/8/29.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMControllerTool.h"
#import "SAMAppDelegate.h"
#import "SAMTabBarViewController.h"
#import "SAMGuideViewController.h"
#import "SAMFirstMananeWalletController.h"

@implementation SAMControllerTool

#pragma mark - public methods
+ (void)chooseRootVC {
    SAMAppDelegate *appD = (SAMAppDelegate *)[UIApplication sharedApplication].delegate;
    // 本设备是否创建过钱包
    NSArray<SAMWalletInfo *> *wallets = [SAMWalletDB fetchAllWallets];
    if (wallets.count > 0) {
        if (![SAMGuideViewController shouldShow]) {
            appD.window.rootViewController = [SAMTabBarViewController new];
        } else {
            SAMGuideViewController *guideVC = [SAMGuideViewController new];
            appD.window.rootViewController = guideVC;
            guideVC.dismissBlock = ^{
                [SAMControllerTool chooseRootVC];
            };
        }
    } else {
        appD.window.rootViewController = [[SAMNavigationController alloc] initWithRootViewController:[SAMFirstMananeWalletController new]];
    }
}

+ (void)chooseVCWithScheme:(NSString *)scheme {
    if (scheme && scheme.length > 0) {
        if ([MGJRouter canOpenURL:scheme]) {
            [MGJRouter openURL:scheme];
        }
    }
}

+ (UIViewController *)currentVC {
    UIViewController *result = nil;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [UIApplication sharedApplication].windows;
        for(UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    __block id nextResponder = nil;
    UIViewController *appRootVC = window.rootViewController;
    // 如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    } else {
        nextResponder = appRootVC;
        [window.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
                nextResponder = obj.nextResponder;
                *stop = YES;
            }
        }];
    }
    if ([nextResponder isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbar = (UITabBarController *)nextResponder;
        UINavigationController *nav = tabbar.selectedViewController;
        result = nav.childViewControllers.lastObject;
    } else if ([nextResponder isKindOfClass:[UINavigationController class]]) {
        UIViewController *nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    } else {
        result = nextResponder;
    }
    
    return result;
}

+ (void)showVC:(UIViewController *)vc {
    [SAMControllerTool showVC:vc animated:YES];
}

#pragma mark - private methods
+ (void)showVC:(UIViewController *)vc animated:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *currentVC = [SAMControllerTool currentVC];
        if (currentVC.navigationController) {
            if ([currentVC.navigationController.viewControllers containsObject:vc]) {
                [currentVC.navigationController popToViewController:vc animated:animated];
            } else {
                [currentVC.navigationController pushViewController:vc animated:animated];
            }
        } else {
            [currentVC presentViewController:vc animated:animated completion:nil];
        }
    });
}

@end
