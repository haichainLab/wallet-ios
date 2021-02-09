//
//  SAMManageWalletCell.h
//  SamosWallet
//
//  Created by zys on 2018/8/21.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 管理钱包-钱包cell
 */

#import <UIKit/UIKit.h>

@interface SAMManageWalletCell : UITableViewCell

+ (void)registerWith:(UITableView *)tableView;
+ (CGFloat)cellHeight;
- (void)setCellWithModel:(SAMWalletInfo *)model;

extern NSString *const SAMManageWalletCellID;

@end
