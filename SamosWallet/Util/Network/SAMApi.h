//
//  SAMApi.h
//  XB
//
//  Created by Xiaobu on 2017/2/20.
//  Copyright © 2017年 XiaoBu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAMApi : NSObject

/// 主地址
extern NSString *const SAMApiBaseURLString;
/// 获取token信息（支持的货币数据）
extern NSString *const SAMApiGetToken;
/// 获取兑换比率的数据
extern NSString *const SAMApiGetPrice;
/// 获取某一币种的交易记录列表
/// http://samos.yqkkn.com/api/transaction?token=SAMO&address=2STmHA282bDmWisDHt6LNJjgTvbwezeJCct&ts=1
/// ts为时间戳，防止服务器接口缓存
extern NSString *const SAMApiGetCoinTradeRecordList;

@end
