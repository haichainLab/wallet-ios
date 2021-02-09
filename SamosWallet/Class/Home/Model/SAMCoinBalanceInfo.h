//
//  SAMCoinBalanceInfo.h
//  SamosWallet
//
//  Created by jtt on 2018/11/19.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 币种余额数据：包括余额和币时
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SAMCoinBalanceInfo : NSObject

/// 余额
@property (nonatomic, assign) CGFloat balance;
/// 币时
@property (nonatomic, assign) NSInteger hours;

@end

NS_ASSUME_NONNULL_END
