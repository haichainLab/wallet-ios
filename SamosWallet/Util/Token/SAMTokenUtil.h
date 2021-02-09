//
//  SAMTokenUtil.h
//  SamosWallet
//
//  Created by zys on 2018/11/11.
//  Copyright © 2018 zys. All rights reserved.
//

/**
 token工具类
 */

#import <Foundation/Foundation.h>
@class SAMTokenNode;
@class SAMCoinRateInfo;

NS_ASSUME_NONNULL_BEGIN

@interface SAMTokenUtil : NSObject

/// 获取token数据
+ (void)loadTokenDataCompletion:(void (^) (SAMTokenNode *token))completion;
/// 获取币种兑换比率数据
+ (void)loadCoinRatesCompletion:(void (^) (NSArray <SAMCoinRateInfo *> *rates))completion;
/// 超时提示
+ (void)showTimeoutAlert;
/// 注册token
+ (void)registerAllTokens;
/// 注册一个token
+ (BOOL)regiseterToken:(SAMTokenInfo *)token;
/// 添加新币种
+ (void)addNewCoin:(SAMTokenInfo *)token;
/// 移除币种
+ (void)removeCoin:(SAMTokenInfo *)token;
/// 当前钱包是否包含token
+ (BOOL)isTokenSelected:(SAMTokenInfo *)token;

@end

NS_ASSUME_NONNULL_END
