//
//  SAMSelectLanuageCell.h
//  SamosWallet
//
//  Created by zys on 2018/8/21.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 选择语言cell
 */

#import <UIKit/UIKit.h>

@interface SAMSelectLanuageCell : UITableViewCell

+ (void)registerWith:(UITableView *)tableView;
+ (CGFloat)cellHeight;
- (void)setCellWithLanguageName:(NSString *)name
                       selected:(BOOL)selected;

extern NSString *const SAMSelectLanuageCellID;

@end
