//
//  SAMSystemSettingCell.h
//  SamosWallet
//
//  Created by zys on 2018/8/21.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 我的-交易记录、系统设置、关于我们
 */

#import <UIKit/UIKit.h>

@interface SAMSystemSettingCell : UITableViewCell

+ (void)registerWith:(UITableView *)tableView;
+ (CGFloat)cellHeight;
- (void)setCellWithTitle:(NSString *)title
                   value:(NSString *)value;

extern NSString *const SAMSystemSettingCellID;

@end
