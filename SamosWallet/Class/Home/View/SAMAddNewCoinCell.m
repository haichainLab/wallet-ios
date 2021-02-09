//
//  SAMAddNewCoinCell.m
//  SamosWallet
//
//  Created by jtt on 2018/11/14.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMAddNewCoinCell.h"

@interface SAMAddNewCoinCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *statusSwitch;

@end


@implementation SAMAddNewCoinCell

NSString *const SAMAddNewCoinCellID = @"SAMAddNewCoinCell";

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
    [tableView registerNib:[UINib nibWithNibName:@"SAMAddNewCoinCell" bundle:nil] forCellReuseIdentifier:SAMAddNewCoinCellID];
}

+ (CGFloat)cellHeight {
    CGFloat resultH = 0.f;
    // icon top
    resultH += 15.f;
    // icon h
    resultH += 70.f;
    // icon bottom
    resultH += 15.f;
    
    return resultH;
}

- (void)setCellWithModel:(SAMTokenInfo *)model
            defaultToken:(NSString *)defaultToken
              isSelected:(BOOL)isSelected {
    if (model) {
        if (model.tokenIcon.length > 0) {
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.tokenIcon]];
        }
        if (model.token.length > 0) {
            self.titleLabel.text = model.token;
        }
        if (model.tokenName.length > 0) {
            self.subTitleLabel.text = model.tokenName.capitalizedString;
        }
        if ([model.token isEqualToString:defaultToken]) {
            self.statusSwitch.hidden = YES;
        } else {
            self.statusSwitch.hidden = NO;
            self.statusSwitch.on = isSelected;
        }
    }
}

#pragma mark - event response
- (IBAction)statusValueChanged:(id)sender {
    if (self.selectStatusBlock) {
        self.selectStatusBlock(self.statusSwitch.on);
    }
}

#pragma mark - private methods
- (void)setupSubviews {
    self.statusSwitch.hidden = YES;
    self.iconImageView.image = nil;
    self.titleLabel.text = @"";
    self.subTitleLabel.text = @"";
    self.statusSwitch.on = NO;
}

@end
