//
//  SAMVerifyWordsCell.h
//  SamosWallet
//
//  Created by zys on 2018/9/2.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 验证助记词
 */

#import <UIKit/UIKit.h>

@interface SAMVerifyWordsCell : UITableViewCell

/// 验证助记词
@property (nonatomic, copy) NSString *words;

+ (void)registerWith:(UITableView *)tableView;
+ (CGFloat)cellHeight;

extern NSString *const SAMVerifyWordsCellID;

@end
