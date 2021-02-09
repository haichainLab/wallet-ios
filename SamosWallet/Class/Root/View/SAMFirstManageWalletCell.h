//
//  SAMFirstManageWalletCell.h
//  SamosWallet
//
//  Created by zys on 2018/9/8.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 第一次管理钱包cell
 */

#import <UIKit/UIKit.h>

@interface SAMFirstManageWalletCell : UITableViewCell

+ (void)registerWith:(UITableView *)tableView;
+ (CGFloat)cellHeight;
- (void)setCellWithModel:(id)model;

extern NSString *const SAMFirstManageWalletCellID;

@end
