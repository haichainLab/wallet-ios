//
//  SAMWalletDetailCell.m
//  SamosWallet
//
//  Created by zys on 2018/12/2.
//  Copyright © 2018 zys. All rights reserved.
//

#import "SAMWalletDetailCell.h"

@interface SAMWalletDetailCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *walletIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *walletNameKeyLabel;
@property (weak, nonatomic) IBOutlet UITextField *walletNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *pwdTipKeyLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdTipTextField;

@end


@implementation SAMWalletDetailCell

NSString *const SAMWalletDetailCellID = @"SAMWalletDetailCell";

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
    [tableView registerNib:[UINib nibWithNibName:@"SAMWalletDetailCell" bundle:nil] forCellReuseIdentifier:SAMWalletDetailCellID];
}

+ (CGFloat)cellHeight {
    CGFloat resultH = 0.f;
    // header h
    resultH += 130.f;
    // name top
    resultH += 20.f;
    // name h
    resultH += 17.f;
    // name tf top
    resultH += 10.f;
    // name tf h
    resultH += 30.f;
    // pwd top
    resultH += 20.f;
    // pwd h
    resultH += 17.f;
    // pwd tf top
    resultH += 10.f;
    // pwd tf h
    resultH += 30.f;
    // line
    resultH += 1.f;
    
    return resultH;
}

- (void)setCellWithModel:(SAMWalletInfo *)model {
    if (model) {
        if (model.walletIcon.length > 0) {
            self.walletIconImageView.image = [UIImage imageNamed:model.walletIcon];
        }
        if (model.walletName.length > 0) {
            self.walletNameTextField.placeholder = model.walletName;
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - private methods
- (void)setupSubviews {
    self.walletNameKeyLabel.text = SAM_LOCALIZED(@"language_wallet_name");
    self.walletNameTextField.placeholder = SAM_LOCALIZED(@"language_input_wallet_name");
    self.pwdTipKeyLabel.text = SAM_LOCALIZED(@"language_pwd_prompt");
    self.pwdTipTextField.placeholder = SAM_LOCALIZED(@"language_input_pwd_prompt");

}

@end
