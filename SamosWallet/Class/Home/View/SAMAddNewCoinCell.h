//
//  SAMAddNewCoinCell.h
//  SamosWallet
//
//  Created by jtt on 2018/11/14.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 添加新资产cell
 */

#import <UIKit/UIKit.h>
@class SAMTokenInfo;

typedef void(^SAMCoinSelectStatusChanged)(BOOL isSelected);

NS_ASSUME_NONNULL_BEGIN

@interface SAMAddNewCoinCell : UITableViewCell

/// 开关变化
@property (nonatomic, copy) SAMCoinSelectStatusChanged selectStatusBlock;

+ (void)registerWith:(UITableView *)tableView;
+ (CGFloat)cellHeight;
- (void)setCellWithModel:(SAMTokenInfo *)model
            defaultToken:(NSString *)defaultToken
              isSelected:(BOOL)isSelected;

extern NSString *const SAMAddNewCoinCellID;

@end

NS_ASSUME_NONNULL_END
