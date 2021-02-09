//
//  SAMWalletTokenInfo.h
//  SamosWallet
//
//  Created by jtt on 2018/11/27.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 添加币种数据库表
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SAMWalletTokenInfo : NSObject

/// 币种钱包id
@property (nonatomic, copy) NSString *walletID;
/// 钱包名字
@property (nonatomic, copy) NSString *walletName;
/// 币种token：SAMO
@property (nonatomic, copy) NSString *token;
/// 货币余额
@property (nonatomic, assign) CGFloat balance;
/// 币时
@property (nonatomic, assign) NSInteger hours;

@end

NS_ASSUME_NONNULL_END
