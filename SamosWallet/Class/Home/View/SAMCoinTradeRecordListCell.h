//
//  SAMCoinTradeRecordListCell.h
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

/**
 币种交易记录列表cell
 */

#import <UIKit/UIKit.h>
@class SAMTradeRecordListModel;

NS_ASSUME_NONNULL_BEGIN

@interface SAMCoinTradeRecordListCell : UITableViewCell

+ (void)registerWith:(UITableView *)tableView;
+ (CGFloat)cellHeight;
- (void)setCellWithModel:(SAMTradeRecordListModel *)model;

extern NSString *const SAMCoinTradeRecordListCellID;

@end

NS_ASSUME_NONNULL_END
