//
//  SAMBackupWordsCell.h
//  SamosWallet
//
//  Created by zys on 2018/9/2.
//  Copyright © 2018年 zys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAMBackupWordsCell : UITableViewCell

@property (weak, nonatomic, readonly) IBOutlet UIButton *recreateBtn;
@property (weak, nonatomic, readonly) IBOutlet UILabel *btnTitleLabel;
/// 重新生成words
@property (nonatomic, copy) SAMVoidBlock recreateBlock;

+ (void)registerWith:(UITableView *)tableView;
+ (CGFloat)cellHeightWithWord:(NSString *)word;
- (void)setCellWithWords:(NSString *)word;

extern NSString *const SAMBackupWordsCellID;

@end
