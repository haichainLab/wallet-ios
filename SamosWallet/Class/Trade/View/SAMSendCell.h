//
//  SAMSendCell.h
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

/**
 转出cell
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SAMSendCell : UITableViewCell

@property (weak, nonatomic, readonly) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic, readonly) IBOutlet UITextField *numTextField;

+ (void)registerWith:(UITableView *)tableView;
+ (CGFloat)cellHeight;
- (void)setCellWithAddress:(NSString *)address
                     token:(NSString *)token
                       num:(NSString *)num;

extern NSString *const SAMSendCellID;

@end

NS_ASSUME_NONNULL_END
