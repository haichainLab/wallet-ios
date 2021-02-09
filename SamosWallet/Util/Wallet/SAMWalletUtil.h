//
//  SAMWalletUtil.h
//  SamosWallet
//
//  Created by zys on 2018/11/24.
//  Copyright © 2018 zys. All rights reserved.
//

/**
 钱包相关操作
 */

#import <Foundation/Foundation.h>
@class SAMCoinBalanceInfo;

NS_ASSUME_NONNULL_BEGIN

@interface SAMWalletUtil : NSObject


/**
 创建新钱包

 @param walletName 钱包名字
 @param walletIcon 钱包icon（本地icon名称）
 @param walletSeed 助记词
 @param token 币种数据
 @return 成功YES；失败NO
 */
+ (BOOL)createWalletWithWalletName:(NSString *)walletName
                        walletIcon:(NSString *)walletIcon
                        walletSeed:(NSString *)walletSeed
                             token:(SAMTokenInfo *)token;

/**
 添加钱包地址
@param walletID 钱包id
@return 添加成功返回钱包地址；失败则返回nil
*/
+ (NSString *)createAddressWithWalletID:(NSString *)walletID;


/**
 删除钱包

 @param walletName 钱包名字
 @return 删除成功
 */
+ (BOOL)removeWallet:(NSString *)walletName;


/**
 修改钱包的名字

 @param walletOldName 钱包的旧名字
 @param walletNewName 钱包的新名字
 @return 修改成功
 */
+ (BOOL)changeWalletName:(NSString *)walletOldName withNewName:(NSString *)walletNewName;

/**
 获取钱包助记词

 @param walletName 钱包名
 @return 助记词
 */
+ (NSString *)fetchWalletSeed:(NSString *)walletName;


/**
 检测钱包名是否存在

 @return 存在返回YES
 */
+ (BOOL)isWalletExist:(NSString *)walletName;


/**
 根据walletID获取这个币种钱包的余额和币时

 @param walletID 钱包id
 @return 余额和币时
 */
+ (SAMCoinBalanceInfo *)fetchWalletTokenBalanceInfoWithWalletID:(NSString *)walletID;


/**
 根据URL获取协议的参数
 
 @param URL
 @return 协议参数
 */
+ (NSDictionary *)getUrlParameterWithUrl:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
