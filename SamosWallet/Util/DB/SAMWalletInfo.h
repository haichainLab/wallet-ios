//
//  SAMWalletInfo.h
//  SamosWallet
//
//  Created by zys on 2018/11/10.
//  Copyright © 2018 zys. All rights reserved.
//

/**
 钱包信息：存储在数据库的数据（数据库表）
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SAMWalletInfo : NSObject

/// 钱包名字
@property (nonatomic, copy) NSString *walletName;
/// 钱包icon
@property (nonatomic, copy) NSString *walletIcon;
/// 是否选中（是否是当前的钱包）
@property (nonatomic, assign) BOOL isSelected;
/// 余额（不存入数据库表）
@property (nonatomic, assign) CGFloat balance;
/// 转账地址
@property (nonatomic, copy) NSString *address;

@end

NS_ASSUME_NONNULL_END
