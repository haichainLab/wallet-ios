//
//  SAMTradeRecordDetailController.h
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

/**
 交易记录详情页
 */

#import "SAMBaseTableViewController.h"
@class SAMTradeRecordListModel;

NS_ASSUME_NONNULL_BEGIN

@interface SAMTradeRecordDetailController : SAMBaseTableViewController

+ (instancetype)pushFrom:(UIViewController *)fromVC
               tradeInfo:(SAMTradeRecordListModel *)tradeInfo
             explorerUrl:(NSString *)explorerUrl;

@end

NS_ASSUME_NONNULL_END
