//
//  SAMWalletDB.h
//  SamosWallet
//
//  Created by zys on 2018/11/10.
//  Copyright © 2018 zys. All rights reserved.
//

/**
 数据库操作类：存储钱包信息
 */

#import <Foundation/Foundation.h>
@class SAMWalletInfo;
@class SAMTokenInfo;
@class SAMCoinRateInfo;
@class SAMWalletTokenInfo;
//xxl 0.0.2 for lock the tokens
@class LockTokenInfo;

NS_ASSUME_NONNULL_BEGIN

@interface SAMWalletDB : NSObject

#pragma mark - pwd
/// 存储密码
+ (void)savePwd:(NSString *)pwd;
/// 获取密码
+ (NSString *)fetchPwd;

#pragma mark - wallet info
/// 获取所有钱包数据
+ (NSArray <SAMWalletInfo *> *)fetchAllWallets;
/// 获取当前钱包
+ (SAMWalletInfo *)fetchCurWallet;
/// 根据钱包名获取一个钱包
+ (SAMWalletInfo *)fetchWallet:(NSString *)walletName;
/// 存储一个钱包数据
+ (BOOL)saveWalletInfo:(SAMWalletInfo *)info;
/// 更新一个钱包数据
+ (BOOL)updateWalletInfo:(SAMWalletInfo *)info withOldWalletName:(NSString *)oldWalletName;
/// 选中一个钱包
+ (void)selectWallet:(NSString *)walletName;
/// 删除一个钱包
+ (BOOL)removeWallet:(NSString *)walletName;

#pragma mark - token info
/// 获取所有token数据（不包含walletID）
+ (NSArray <SAMTokenInfo *> *)fetchAllTokens;
/// 存储或更新一个币种数据（不包含walletID）
+ (BOOL)saveToken:(SAMTokenInfo *)token;
/// 获取一个token
+ (SAMTokenInfo *)fetchToken:(NSString *)token;
/// 存储默认token
+ (void)saveDefaultToken:(NSString *)token;
/// 获取默认token
+ (SAMTokenInfo *)fetchDefaultToken;

#pragma mark - wallet token info
/// 获取某一钱包下的所有token数据
+ (NSArray <SAMWalletTokenInfo *> *)fetchAllWalletTokensWithWalletName:(NSString *)walletName;
/// 获取某一个钱包下的一个特定token
+ (SAMWalletTokenInfo *)fetchWalletToken:(NSString *)token fromWallet:(NSString *)walletName;
/// 根据钱包id获取一个walletToken
+ (SAMWalletTokenInfo *)fetchWalletTokenWithWalletID:(NSString *)walletID;
/// 存储或更新一个币种数据（包含walletID和walletName）
+ (BOOL)saveWalletToken:(SAMWalletTokenInfo *)token;
/// 从钱包下移除一个币种
+ (BOOL)removeWalletToken:(NSString *)walletID;
/// 删除一个钱包下的所有币种
+ (BOOL)removeAllWalletTokens:(NSString *)walletName;

#pragma mark - 货币比率
/// 存储所有货币比率
+ (void)saveAllRates:(NSArray <SAMCoinRateInfo *> *)rates;
/// 获取所有货币比率
+ (NSArray <SAMCoinRateInfo *> *)fetchAllCoinRates;
/// 获取某一货币比率
+ (SAMCoinRateInfo *)rateForCoin:(NSString *)token;
/// 存储单一货币比率
+ (void)saveRate:(SAMCoinRateInfo *)rate;

#pragma mark - 显示单位：美元/人民币
/// 获取当前的币种单位
+ (NSString *)fetchCurCoinUnit;
/// 存储当前币种单位
+ (void)saveCurCoinUnit:(NSString *)unit;

/// 保存锁币信息
+ (BOOL)saveLockToken:(LockTokenInfo *)lockToken;

/// 判断是是否锁币
+ (BOOL)isTokenLocked:(NSString *)walletName;

@end

NS_ASSUME_NONNULL_END
