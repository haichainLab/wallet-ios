//
//  SAMTradeRecordDetailCell.h
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SAMTradeRecordListModel;

NS_ASSUME_NONNULL_BEGIN

@interface SAMTradeRecordDetailCell : UITableViewCell

+ (void)registerWith:(UITableView *)tableView;
+ (CGFloat)cellHeight;
- (void)setCellWithModel:(id)model explorerUrl:(NSString *)explorerUrl;

extern NSString *const SAMTradeRecordDetailCellID;

@end

NS_ASSUME_NONNULL_END
