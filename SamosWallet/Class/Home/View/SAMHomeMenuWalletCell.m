//
//  SAMHomeMenuWalletCell.m
//  SamosWallet
//
//  Created by zys on 2018/8/21.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMHomeMenuWalletCell.h"

@interface SAMHomeMenuWalletCell ()

@property (weak, nonatomic) IBOutlet UIImageView *walletIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *walletTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *selectBGView;

@end


@implementation SAMHomeMenuWalletCell

NSString *const SAMHomeMenuWalletCellID = @"SAMHomeMenuWalletCell";

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
    [tableView registerNib:[UINib nibWithNibName:@"SAMHomeMenuWalletCell" bundle:nil] forCellReuseIdentifier:SAMHomeMenuWalletCellID];
}

+ (CGFloat)cellHeight {
    CGFloat resultH = 60.f;
    
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
        self.selectBGView.hidden = !(model.isSelected);
    }
}

#pragma mark - private methods
- (void)setupSubviews {
    self.selectBGView.hidden = YES;
    self.walletIconImageView.image = nil;
    self.walletTitleLabel.text = @"";
}

@end
