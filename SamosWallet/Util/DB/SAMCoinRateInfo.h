//
//  SAMCoinRateInfo.h
//  SamosWallet
//
//  Created by zys on 2018/11/18.
//  Copyright © 2018 zys. All rights reserved.
//

/**
 用户币种兑换比率数据（数据库表）
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SAMCoinRateInfo : NSObject

/// token, eg: SAMO
@property (nonatomic, copy) NSString *token;
/// 美元兑换比率(1个币=usd个美元)
@property (nonatomic, assign) CGFloat usd;
/// 人民币兑换比率(1个币=cny个人民)
@property (nonatomic, assign) CGFloat cny;
/// 比特币兑换比率(1个币=btc个比特币)
@property (nonatomic, assign) CGFloat btc;

@end

NS_ASSUME_NONNULL_END
