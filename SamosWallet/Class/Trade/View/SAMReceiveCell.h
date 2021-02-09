//
//  SAMReceiveCell.h
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

/**
 转入cell
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SAMReceiveCell : UITableViewCell

/// 二维码
@property (weak, nonatomic, readonly) IBOutlet UIImageView *qrcodeImageView;

+ (void)registerWith:(UITableView *)tableView;
+ (CGFloat)cellHeight;
- (void)setCellWithAddress:(NSString *)address
                     token:(NSString *)token;

extern NSString *const SAMReceiveCellID;

@end

NS_ASSUME_NONNULL_END
