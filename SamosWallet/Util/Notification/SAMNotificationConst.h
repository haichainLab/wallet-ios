//
//  SAMNotificationConst.h
//  SamosWallet
//
//  Created by jtt on 2018/11/19.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 存储通知常量
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SAMNotificationConst : NSObject

/// 初始化成功通知
extern NSString *const SAMNotificationInitSuccess;
/// 刷新tabbBaf首页
extern NSString *const SAMNotificationRefreshTabBarHome;
/// 刷新交易列表页
extern NSString *const SAMNotificationRefreshTradeRecordList;
/// 刷新管理钱包页
extern NSString *const SAMNotificationRefreshManageWalletPage;

@end

NS_ASSUME_NONNULL_END
