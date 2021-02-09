//
//  SAMManageWalletCell.m
//  SamosWallet
//
//  Created by zys on 2018/8/21.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMManageWalletCell.h"

@interface SAMManageWalletCell ()

@property (weak, nonatomic) IBOutlet UIImageView *walletIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *walletTitleLabel;

@end


@implementation SAMManageWalletCell

NSString *const SAMManageWalletCellID = @"SAMManageWalletCell";

#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubviews];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self setupSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - public methods
+ (void)registerWith:(UITableView *)tableView {
    [tableView registerNib:[UINib nibWithNibName:@"SAMManageWalletCell" bundle:nil] forCellReuseIdentifier:SAMManageWalletCellID];
}

+ (CGFloat)cellHeight {
    CGFloat resultH = 80.f;
    
    return resultH;
}

- (void)setCellWithModel:(SAMWalletInfo *)model {
    if (model) {
        if (model.walletIcon.length > 0) {
            self.walletIconImageView.image = [UIImage imageNamed:model.walletIcon];
        }
        if (model.walletName.length > 0) {
            self.walletTitleLabel.text = model.walletName;
        }
    }
}

#pragma mark - private methods
- (void)setupSubviews {
    self.walletIconImageView.image = nil;
    self.walletTitleLabel.text = @"";
}

@end
