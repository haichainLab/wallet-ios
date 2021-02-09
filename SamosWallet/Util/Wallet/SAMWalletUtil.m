//
//  SAMWalletUtil.m
//  SamosWallet
//
//  Created by zys on 2018/11/24.
//  Copyright © 2018 zys. All rights reserved.
//

#import "SAMWalletUtil.h"
#import "SAMWalletAddressInfo.h"
#import "SAMCoinBalanceInfo.h"

@implementation SAMWalletUtil

#pragma mark - public methods
+ (BOOL)createWalletWithWalletName:(NSString *)walletName
                        walletIcon:(NSString *)walletIcon
                        walletSeed:(NSString *)walletSeed
                             token:(SAMTokenInfo *)token {
    if (walletName.length == 0 || walletIcon.length == 0 || walletSeed.length == 0 || token.tokenName.length == 0) {
        NSLog(@"请求参数不完整！");
        
        return nil;
    }
    BOOL resultFlag = NO;
    NSString *cointType = token.tokenName;
    NSError *error = nil;
    NSString *savedPwd = [SAMWalletDB fetchPwd];
    // 新建钱包
    if (cointType.length > 0 && savedPwd.length > 0) {
        NSString *walletID = MobileNewWallet(cointType, walletName, walletSeed, savedPwd, &error);
        if (walletID.length > 0 && !error) {
            SAMWalletInfo *info = [SAMWalletInfo new];
            info.walletName = walletName;
            info.walletIcon = walletIcon;
            // 添加钱包交易地址
            info.address = [self createAddressWithWalletID:walletID];
            // 存储钱包
            if ([SAMWalletDB saveWalletInfo:info]) {
                // 存储钱包token
                SAMWalletTokenInfo *walletToken = [SAMWalletTokenInfo new];
                walletToken.walletID = walletID;
                walletToken.walletName = walletName;
                walletToken.token = token.token;
                if ([SAMWalletDB saveWalletToken:walletToken]) {
                    resultFlag = YES;
                }
                [SAMWalletDB selectWallet:walletName];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showSuccessWithStatus:SAM_LOCALIZED(@"language_wallet_create_success")];
                });
                NSLog(@"MobileNewWallet success!");
            }
        } else {
            NSLog(@"MobileNewWallet error: %@", error);
        }
    }

    return resultFlag;
}

+ (SAMCoinBalanceInfo *)fetchWalletTokenBalanceInfoWithWalletID:(NSString *)walletID {
    SAMCoinBalanceInfo *resultObj = nil;
    SAMWalletTokenInfo *walletToken = [SAMWalletDB fetchWalletTokenWithWalletID:walletID];
    SAMTokenInfo *token = [SAMWalletDB fetchToken:walletToken.token];
    NSError *error = nil;
    NSString *balance = MobileGetWalletBalance(token.tokenName, walletID, &error);
    // 解析余额和币时
    SAMCoinBalanceInfo *ba = [SAMCoinBalanceInfo yy_modelWithJSON:balance];
    if (!error) {
        walletToken.balance = ba.balance;
        walletToken.hours = ba.hours;
    } else {
        walletToken.balance = 0.f;
        walletToken.hours = 0;
    }
    
    [SAMWalletDB saveWalletToken:walletToken];
    resultObj = ba;
    
    return resultObj;
}

//#pragma mark - private methods
/**
 添加钱包地址

 @param walletID 钱包id
 @return 添加成功返回钱包地址；失败则返回nil
 */
+ (NSString *)createAddressWithWalletID:(NSString *)walletID {
    NSString *resultAddress = nil;
    if (walletID.length > 0) {
        NSString *savedPwd = [SAMWalletDB fetchPwd];
        NSError *error = nil;
        MobileNewAddress(walletID, 1, savedPwd, &error);
        NSString *addressJsonStr = MobileGetAddresses(walletID, &error);
        if (addressJsonStr.length > 0) {
            SAMWalletAddressInfo *addNode = [SAMWalletAddressInfo yy_modelWithJSON:addressJsonStr];
            if (addNode.addresses.count > 0) {
                NSString *address0 = addNode.addresses.firstObject;
                if (address0.length > 0) {
                    resultAddress = address0;
                }
            }
        } else {
            NSLog(@"MobileNewAddress error: %@", error);
        }
    }
    
    return resultAddress;
}

+ (BOOL)removeWallet:(NSString *)walletName {
    __block BOOL flag = YES;
    // 获取钱包下所有币种，然后逐一删除
    NSArray <SAMWalletTokenInfo *> *walletTokens = [SAMWalletDB fetchAllWalletTokensWithWalletName:walletName];
    [walletTokens enumerateObjectsUsingBlock:^(SAMWalletTokenInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError *error = nil;
        BOOL ret = MobileRemove(obj.walletID, &error);
        if (!ret && error) {
            NSLog(@"MobileRemove error: %@", error);
            flag = NO;
        }
    }];
    // 从本地数据库删除
    [SAMWalletDB removeWallet:walletName];
    // wallet token 表删除相关token
    [SAMWalletDB removeAllWalletTokens:walletName];
    
    return flag;
}

+ (BOOL)changeWalletName:(NSString *)walletOldName withNewName:(NSString *)walletNewName {
    BOOL flag = NO;
    // 1.更新wallet表
    SAMWalletInfo *wallet = [SAMWalletDB fetchWallet:walletOldName];
    wallet.walletName = walletNewName;
    [SAMWalletDB updateWalletInfo:wallet withOldWalletName:walletOldName];
    // 2.更新wallet token 表
    NSArray <SAMWalletTokenInfo *> *walletTokens = [SAMWalletDB fetchAllWalletTokensWithWalletName:walletOldName];
    [walletTokens enumerateObjectsUsingBlock:^(SAMWalletTokenInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.walletName = walletNewName;
        [SAMWalletDB saveWalletToken:obj];
    }];
    flag = YES;
    
    return flag;
}

+ (NSString *)fetchWalletSeed:(NSString *)walletName {
    NSString *resultStr = @"";
    // 获取walletToken
    NSArray *walletTokens = [SAMWalletDB fetchAllWalletTokensWithWalletName:walletName];
    if (walletTokens.count > 0) {
        SAMWalletTokenInfo *walletToken = walletTokens.firstObject;
        NSString *pwd = [SAMWalletDB fetchPwd];
        NSError *error = nil;
        resultStr = MobileGetSeed(walletToken.walletID, pwd, &error);
    }
    
    return resultStr;
}

+ (BOOL)isWalletExist:(NSString *)walletName {
    __block BOOL flag = NO;
    NSArray <SAMWalletInfo *> *wallets = [SAMWalletDB fetchAllWallets];
    [wallets enumerateObjectsUsingBlock:^(SAMWalletInfo *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.walletName isEqualToString:walletName]) {
            flag = YES;
            *stop = YES;
        }
    }];
    
    return flag;
}

+ (NSDictionary *)getUrlParameterWithUrl:(NSURL *)url {
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    //传入url创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url.absoluteString];
    //回调遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //协议本身忽略大小写
        NSString * name = [obj.name lowercaseStringWithLocale:[NSLocale currentLocale]];
        [param setObject:obj.value forKey:name];
    }];
    return param;
}


@end
