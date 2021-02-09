//
//  SAMVersionCell.h
//  SamosWallet
//
//  Created by zys on 2018/8/21.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 关于我们-版本
 */

#import <UIKit/UIKit.h>

@interface SAMVersionCell : UITableViewCell

+ (void)registerWith:(UITableView *)tableView;
+ (CGFloat)cellHeight;

extern NSString *const SAMVersionCellID;

@end
