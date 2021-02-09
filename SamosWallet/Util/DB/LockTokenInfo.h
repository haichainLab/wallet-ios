//
//  LockCoinInfo.h
//  SamosWallet
//
//  Created by xu xinlai on 2019/11/9.
//  Copyright © 2019年 Samos. All rights reserved.
//
/**
 添加锁币数据库表
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LockTokenInfo : NSObject

/// 钱包名字
@property (nonatomic, copy) NSString *walletName;
/// 锁币类型
@property (nonatomic, assign) NSInteger periodType;
/// 开始时间
@property (nonatomic, assign) NSInteger startTimestamp;
/// 结束时间
@property (nonatomic, assign) NSInteger endTimestamp;

@end

NS_ASSUME_NONNULL_END
