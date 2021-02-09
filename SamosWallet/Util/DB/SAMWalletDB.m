//
//  SAMWalletDB.m
//  SamosWallet
//
//  Created by zys on 2018/11/10.
//  Copyright © 2018 zys. All rights reserved.
//

#import <BGFMDB/BGFMDB.h>
#import "SAMWalletDB.h"
#import "SAMDBConst.h"

@implementation SAMWalletDB

#pragma mark - life cycle
+ (void)load {
    [self setupDB];
}

#pragma mark - pwd
+ (void)savePwd:(NSString *)pwd {
    if (pwd.length > 0) {
        // 加密保存
        NSString *encryptedPwd = [pwd encrypt3DES];
        [SAM_UD setObject:encryptedPwd forKey:SAM_PWD_KEY];
        [SAM_UD synchronize];
    }
}

+ (NSString *)fetchPwd {
    NSString *encryptedPwd = [SAM_UD objectForKey:SAM_PWD_KEY];
    NSString *decryptedPwd = [encryptedPwd decrypt3DES];
    
    return decryptedPwd;
}

#pragma mark - wallet info
+ (NSArray <SAMWalletInfo *> *)fetchAllWallets {
    NSArray *resultArray = [SAMWalletInfo bg_findAll:SAM_DB_WALLET_TABLE];
    
    return resultArray;
}

+ (SAMWalletInfo *)fetchCurWallet {
    SAMWalletInfo *resultWallet = nil;
    NSString *where = [NSString stringWithFormat:@"where %@=%@",  bg_sqlKey(@"isSelected"), bg_sqlValue(@1)];
    resultWallet = [SAMWalletInfo bg_find:SAM_DB_WALLET_TABLE where:where].firstObject;
    
    return resultWallet;
}

+ (SAMWalletInfo *)fetchWallet:(NSString *)walletName {
    SAMWalletInfo *resultWallet = nil;
    NSString *where = [NSString stringWithFormat:@"where %@=%@",  bg_sqlKey(@"walletName"), bg_sqlValue(walletName)];
    resultWallet = [SAMWalletInfo bg_find:SAM_DB_WALLET_TABLE where:where].firstObject;
    
    return resultWallet;
}

+ (BOOL)saveWalletInfo:(SAMWalletInfo *)info {
    info.bg_tableName = SAM_DB_WALLET_TABLE;
    
    return [info bg_saveOrUpdate];
}

+ (BOOL)updateWalletInfo:(SAMWalletInfo *)info withOldWalletName:(NSString *)oldWalletName {
    info.bg_tableName = SAM_DB_WALLET_TABLE;
    NSString *where = [NSString stringWithFormat:@"where %@=%@", bg_sqlKey(@"walletName"), bg_sqlValue(oldWalletName)];
    
    return [info bg_updateWhere:where];
}

+ (void)selectWallet:(NSString *)walletName {
    NSArray *wallets = [SAMWalletDB fetchAllWallets];
    [wallets enumerateObjectsUsingBlock:^(SAMWalletInfo *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.walletName isEqualToString:walletName]) {
            obj.isSelected = YES;
        } else {
            obj.isSelected = NO;
        }
        [SAMWalletDB saveWalletInfo:obj];
    }];
}

+ (BOOL)removeWallet:(NSString *)walletName {
    BOOL flag = NO;
    NSString *where = [NSString stringWithFormat:@"where %@=%@",  bg_sqlKey(@"walletName"), bg_sqlValue(walletName)];
    flag = [SAMWalletInfo bg_delete:SAM_DB_WALLET_TABLE where:where];
    
    return flag;
}

#pragma mark - token info
+ (NSArray <SAMTokenInfo *> *)fetchAllTokens {
    NSArray <SAMTokenInfo *> *tokens = [SAMTokenInfo bg_findAll:SAM_DB_TOKEN_TABLE];
    
    return tokens;
}

+ (BOOL)saveToken:(SAMTokenInfo *)token {
    BOOL retFlag = NO;
    if (token) {
        token.bg_tableName = SAM_DB_TOKEN_TABLE;
        retFlag = [token bg_saveOrUpdate];
    }
    
    return retFlag;
}

+ (SAMTokenInfo *)fetchToken:(NSString *)token {
    SAMTokenInfo *resultToken = nil;
    NSString *where = [NSString stringWithFormat:@"where %@=%@",  bg_sqlKey(@"token"), bg_sqlValue(token)];
    NSArray *retArray = [SAMTokenInfo bg_find:SAM_DB_TOKEN_TABLE where:where];
    if (retArray.count > 0) {
        resultToken = retArray.firstObject;
    }
    
    return resultToken;
}

+ (void)saveDefaultToken:(NSString *)token {
    if (token.length > 0) {
        [SAM_UD setObject:token forKey:SAM_DEFAULT_TOKEN_KEY];
        [SAM_UD synchronize];
    }
}

+ (SAMTokenInfo *)fetchDefaultToken {
    __block SAMTokenInfo *resultToken = nil;
    NSString *token = [SAM_UD objectForKey:SAM_DEFAULT_TOKEN_KEY];
    if (!token || token.length == 0) {
        token = @"SAMO";
    }
    
    resultToken = [SAMWalletDB fetchToken:token];
    
    return resultToken;
}

#pragma mark - wallet token info
+ (NSArray <SAMWalletTokenInfo *> *)fetchAllWalletTokensWithWalletName:(NSString *)walletName {
    NSArray *resultArray = @[];
    if (walletName.length > 0) {
        NSString *where = [NSString stringWithFormat:@"where %@=%@",  bg_sqlKey(@"walletName"), bg_sqlValue(walletName)];
        resultArray = [SAMWalletTokenInfo bg_find:SAM_DB_WALLET_TOKEN_TABLE where:where];
    }
    
    return resultArray;
}

+ (SAMWalletTokenInfo *)fetchWalletToken:(NSString *)token fromWallet:(NSString *)walletName {
    SAMWalletTokenInfo *resultToken = nil;
    if (token.length > 0 && walletName.length > 0) {
        NSString *where = [NSString stringWithFormat:@"where %@=%@ and %@=%@",  bg_sqlKey(@"token"), bg_sqlValue(token), bg_sqlKey(@"walletName"), bg_sqlValue(walletName)];
        NSArray *retArray = [SAMWalletTokenInfo bg_find:SAM_DB_WALLET_TOKEN_TABLE where:where];
        if (retArray.count > 0) {
            resultToken = retArray.firstObject;
        }
    }
    
    return resultToken;
}

+ (SAMWalletTokenInfo *)fetchWalletTokenWithWalletID:(NSString *)walletID {
    SAMWalletTokenInfo *resultToken = nil;
    if (walletID.length > 0) {
        NSString *where = [NSString stringWithFormat:@"where %@=%@",  bg_sqlKey(@"walletID"), bg_sqlValue(walletID)];
        NSArray *retArray = [SAMWalletTokenInfo bg_find:SAM_DB_WALLET_TOKEN_TABLE where:where];
        if (retArray.count > 0) {
            resultToken = retArray.firstObject;
        }
    }
    
    return resultToken;
}

+ (BOOL)saveWalletToken:(SAMWalletTokenInfo *)token {
    BOOL retFlag = NO;
    if (token) {
        token.bg_tableName = SAM_DB_WALLET_TOKEN_TABLE;
        retFlag = [token bg_saveOrUpdate];
    }
    
    return retFlag;
}

+ (BOOL)removeWalletToken:(NSString *)walletID {
    BOOL retFlag = NO;
    if (walletID.length > 0) {
        NSString *where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"walletID"),bg_sqlValue(walletID)];
        retFlag = [SAMWalletTokenInfo bg_delete:SAM_DB_WALLET_TOKEN_TABLE where:where];
    }
    
    return retFlag;
}

+ (BOOL)removeAllWalletTokens:(NSString *)walletName {
    BOOL retFlag = NO;
    if (walletName.length > 0) {
        NSString *where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"walletName"),bg_sqlValue(walletName)];
        retFlag = [SAMWalletTokenInfo bg_delete:SAM_DB_WALLET_TOKEN_TABLE where:where];
    }
    
    return retFlag;
}

#pragma mark - 货币比率
/// 存储所有货币比率
+ (void)saveAllRates:(NSArray <SAMCoinRateInfo *> *)rates {
    if (rates.count > 0) {
        [rates enumerateObjectsUsingBlock:^(SAMCoinRateInfo *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [SAMWalletDB saveRate:obj];
        }];
    }
}

+ (NSArray <SAMCoinRateInfo *> *)fetchAllCoinRates {
    NSArray <SAMCoinRateInfo *> *rates = [SAMCoinRateInfo bg_findAll:SAM_DB_RATE_TABLE];
    
    return rates;
}

+ (SAMCoinRateInfo *)rateForCoin:(NSString *)token {
    __block SAMCoinRateInfo *resultRate = nil;
    NSArray <SAMCoinRateInfo *> *rates = [SAMWalletDB fetchAllCoinRates];
    if (rates.count > 0) {
        [rates enumerateObjectsUsingBlock:^(SAMCoinRateInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.token isEqualToString:token]) {
                resultRate = obj;
                *stop = YES;
            }
        }];
    }
    
    return resultRate;
}

+ (void)saveRate:(SAMCoinRateInfo *)rate {
    if (rate) {
        rate.bg_tableName = SAM_DB_RATE_TABLE;
        [rate bg_saveOrUpdate];
    }
}

#pragma mark - 显示单位：美元/人民币(USD/CNY)
+ (NSString *)fetchCurCoinUnit {
    NSString *unit = [SAM_UD objectForKey:SAM_CUR_COIN_UNIT_KEY];
    if (!unit || unit.length == 0) {
        // 默认币种单位
        unit = @"CNY";
        [SAMWalletDB saveCurCoinUnit:unit];
    }
    
    return unit;
}

+ (void)saveCurCoinUnit:(NSString *)unit {
    if (unit.length > 0) {
        [SAM_UD setObject:unit forKey:SAM_CUR_COIN_UNIT_KEY];
        [SAM_UD synchronize];
    }
}

//xxl 0.0.2 for the lock coin
+ (BOOL)saveLockToken:(LockTokenInfo *)lockToken {
    BOOL retFlag = NO;
    if (lockToken) {
    
        lockToken.bg_tableName = SAM_DB_LOCK_TABLE;
        retFlag = [lockToken bg_saveOrUpdate];
    }
    
    return retFlag;
}

+ (BOOL)isTokenLocked:(NSString *)walletName {
    
    BOOL retFlag = NO;
    if (![walletName isEqualToString:@""]) {
        
        NSString *where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"walletName"),bg_sqlValue(walletName)];
        NSArray *retArray = [LockTokenInfo bg_find:SAM_DB_LOCK_TABLE where:where];
    
        if (retArray.count > 0) {
            retFlag = YES;
        }
        
    }
    
    return retFlag;
}




#pragma mark - private methods
/// 初始化数据库
+ (void)setupDB {
#ifdef DEBUG
    bg_setDebug(YES);
#else
    bg_setDebug(NO);
#endif
    bg_setSqliteName(SAM_DB_NAME);
}

@end
