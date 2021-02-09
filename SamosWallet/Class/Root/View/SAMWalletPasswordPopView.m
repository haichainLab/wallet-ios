//
//  SAMWalletPasswordPopView.m
//  SamosWallet
//
//  Created by zys on 2018/9/8.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMWalletPasswordPopView.h"

@interface SAMWalletPasswordPopView () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwdKeyLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UILabel *pwdAgainKeyLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdAgainTextField;
@property (weak, nonatomic) IBOutlet UILabel *pwdTipKeyLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdTipTextField;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;

@end


@implementation SAMWalletPasswordPopView

#pragma mark - public methods
+ (instancetype)popView {
    SAMWalletPasswordPopView *view = [[NSBundle mainBundle] loadNibNamed:@"SAMWalletPasswordPopView" owner:nil options:nil].firstObject;
    view.allowAnimation = NO;
    view.allowTapGesture = NO;
    
    return view;
}

+ (BOOL)shouldShow {
    BOOL resultFlag = NO;
    NSString *savedPwd = [SAMWalletDB fetchPwd];
    if (!savedPwd || savedPwd.length == 0) {
        resultFlag = YES;
    }
    
    return resultFlag;
}

+ (void)savePwd:(NSString *)pwd {
    if (pwd.length > 0) {
        [SAMWalletDB savePwd:pwd];
    }
}

#pragma mark - event response
- (IBAction)confirmBtnClicked:(id)sender {
    if ([self checkPwd]) {
        if (self.confirmBlock) {
            self.confirmBlock(self.pwdTextField.text, self.pwdTipTextField.text);
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
    [super setupSubviews];
    self.titleLabel.text = SAM_LOCALIZED(@"language_wallet_pwd");
    self.subTitleLabel.text =  SAM_LOCALIZED(@"language_pwd_func");
    self.pwdKeyLabel.text = SAM_LOCALIZED(@"language_pwd");
    self.pwdTextField.placeholder = SAM_LOCALIZED(@"language_input_pwd");
    self.pwdAgainKeyLabel.text = SAM_LOCALIZED(@"language_input_pwd_again");
    self.pwdAgainTextField.placeholder = SAM_LOCALIZED(@"language_input_pwd_again");
    self.pwdTipKeyLabel.text = SAM_LOCALIZED(@"language_pwd_prompt");
    self.pwdTipTextField.placeholder = SAM_LOCALIZED(@"language_input_pwd_prompt");
    self.descLabel.text = SAM_LOCALIZED(@"language_pwd_prompt_info");
}

- (void)placeSubviews {
    [super placeSubviews];
    SAMWeakSelf
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.containerView);
        make.left.equalTo(weakSelf.containerView).offset(50.f);
        make.right.equalTo(weakSelf.containerView).offset(-50.f);
        make.bottom.equalTo(weakSelf.descLabel).offset(100.f);
    }];
}

/// 检测输入密码
- (BOOL)checkPwd {
    /// 判断两次密码是否一致
    if (self.pwdTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:SAM_LOCALIZED(@"language_input_pwd")];
        
        return NO;
    }
    if (self.pwdAgainTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:SAM_LOCALIZED(@"language_input_pwd_again")];
        
        return NO;
    }
    if (![self.pwdTextField.text isEqualToString:self.pwdAgainTextField.text]) {
        [SVProgressHUD showInfoWithStatus:SAM_LOCALIZED(@"language_pwd_is_different")];
        
        return NO;
    }
    
    return YES;
}

@end
