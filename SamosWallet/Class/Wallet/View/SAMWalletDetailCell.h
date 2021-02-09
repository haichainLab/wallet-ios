//
//  SAMWalletDetailCell.h
//  SamosWallet
//
//  Created by zys on 2018/12/2.
//  Copyright © 2018 zys. All rights reserved.
//

/**
 钱包详情页cell
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SAMWalletDetailCell : UITableViewCell

@property (weak, nonatomic, readonly) IBOutlet UITextField *walletNameTextField;
@property (weak, nonatomic, readonly) IBOutlet UITextField *pwdTipTextField;

+ (void)registerWith:(UITableView *)tableView;
+ (CGFloat)cellHeight;
- (void)setCellWithModel:(SAMWalletInfo *)model;

extern NSString *const SAMWalletDetailCellID;

@end

NS_ASSUME_NONNULL_END
