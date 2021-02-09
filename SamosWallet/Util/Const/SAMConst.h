//
//  SAMConst.h
//  SamosWallet
//
//  Created by zys on 2018/8/19.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 全局宏定义
 */

#import <Foundation/Foundation.h>

@interface SAMConst : NSObject

#pragma mark - common
/// 弱引用
#define SAMWeakSelf __weak typeof(self) weakSelf = self;
/// 参数、返回值均为空的block
typedef void (^SAMVoidBlock) (void);
/// 参数为布尔值、返回值为空的block
typedef void (^SAMBOOLBlock) (BOOL flag);
/// App版本
#define SAM_APP_VERSION        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

#pragma mark - 打印
#ifdef DEBUG
#define NSLog(...)  NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

#pragma mark - Language
#define SAM_LOCALIZED(key)  [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"AppLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"SAMLanguage"]

#pragma mark - NSUserDefaults key
/// ud
#define SAM_UD [NSUserDefaults standardUserDefaults]
/// 语言key
#define SAM_UD_KEY_APP_LANGUAGE @"AppLanguage"

#pragma mark - Screen
/// 屏幕尺寸
#define SAM_SCREEN_BOUNDS ([UIScreen mainScreen].bounds)
/// 屏幕宽度
#define SAM_SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
/// 屏幕高度
#define SAM_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
/// tabBar h
#define SAM_TABBAR_HEIGHT 49.f
/// status bar h
#define SAM_STATUSBAR_HEIGHT ([UIApplication sharedApplication].statusBarHidden ? ([SAMDeviceInfo isiPhoneXSeries] ? 44.f : 20.f) : CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))
/// nav h
#define SAM_NAV_HEIGHT (SAM_STATUSBAR_HEIGHT + 44.f)
/// tableView底部距离，iPhoneX为-34，其余为0
#define SAM_TABLE_BOTTOM ([SAMDeviceInfo isiPhoneXSeries] ? -34.f : 0.f)

#pragma mark - color
#define SAM_BLUE_COLOR ([UIColor colorFromHexRGB:@"1833C7"])
#define SAM_DEFAULT_FONT_COLOR ([UIColor colorFromHexRGB:@"333333"])
#define SAM_GRAY_COLOR ([UIColor colorFromHexRGB:@"999999"])


/// haicoin协议类型
#define HAI_HOST_LOCK_WALLET @"lockWallet"
#define HAI_HOST_GO_BACK @"goBack"
// xxl 0.0.4 vote
#define HAI_HOST_VOTE @"vote"

#define HAI_PARAM_COIN_NAME @"coinname"
#define HAI_PARAM_WALLET_NAME @"walletname"
#define HAI_PARAM_AMOUNT @"amount"
#define HAI_PARAM_PERIOD_TYPE @"periodtype"

#define HAI_PARAM_RECEIVING_ADDRESS @"receivingaddress"
#define HAI_PARAM_RETURN_URL @"returnurl"

#define HAI_PARAM_CALLBACK_URL @"callbackurl"
#define HAI_PARAM_OUT_TRADE_NO @"outtradeno"



@end
