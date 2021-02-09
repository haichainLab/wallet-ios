//
//  SAMTradeRecordListModel.h
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

/**
 交易列表数据
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SAMTradeRecordListModel : NSObject

/// 状态: true/false
@property (nonatomic, assign) BOOL status;
/// 交易时间戳
@property (nonatomic, assign) NSInteger time;
/// 交易id
@property (nonatomic, copy) NSString *txid;
/// 交易数量: +100.0
@property (nonatomic, copy) NSString *delta;
/// 接受方地址
@property (nonatomic, copy) NSString *inputs;
/// 发送方地址
@property (nonatomic, copy) NSString *outputs;
/// token
@property (nonatomic, copy) NSString *token;

@end

NS_ASSUME_NONNULL_END
