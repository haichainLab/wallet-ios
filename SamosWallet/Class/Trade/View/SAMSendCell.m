//
//  SAMSendCell.m
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

#import "SAMSendCell.h"

@interface SAMSendCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *addressKeyLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UILabel *numKeyLabel;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tokenLabel1;
@property (weak, nonatomic) IBOutlet UILabel *tokenLabel2;

@end


@implementation SAMSendCell

NSString *const SAMSendCellID = @"SAMSendCell";

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
    [tableView registerNib:[UINib nibWithNibName:@"SAMSendCell" bundle:nil] forCellReuseIdentifier:SAMSendCellID];
}

+ (CGFloat)cellHeight {
    CGFloat resultH = 0.f;
    // 转出地址top
    resultH += 25.f;
    // 转出地址 h
    resultH += 16.f;
    // text field top
    resultH += 0.f;
    // text field h
    resultH += 50.f;
    // bottom line
    resultH += .5f;
    // * 2
    resultH *= 2.f;
    
    return resultH;
}

- (void)setCellWithAddress:(NSString *)address
                     token:(NSString *)token
                       num:(NSString *)num {
    if (address && address.length > 0) {
        self.addressTextField.text = address;
    }
    if (token.length > 0) {
        self.tokenLabel1.text = token;
        self.tokenLabel2.text = token;
        //xxl 0.0.0 hai to haic
        if([token isEqualToString:@"HAI"]){
            self.tokenLabel1.text = @"HAIC";
            self.tokenLabel2.text = @"HAIC";
        }
        
        // 获取余额
        self.balanceLabel.text = [self fetchBalanceWithToken:token];

    }
    if (num && num.length > 0) {
        self.numTextField.text = num;
    }
    
    //xxl 0.0.1 if from pay set read only
    if(![[HaiProtocolTool getCallURL] isEqualToString:@""]){
        self.numTextField.enabled = NO;
    }
    
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - private methods
- (void)setupSubviews {
    self.addressKeyLabel.text = SAM_LOCALIZED(@"language_trade_out_address");
    self.addressTextField.placeholder = SAM_LOCALIZED(@"language_input_or_press_to_paste_address");
    self.addressTextField.text = @"";
    self.numKeyLabel.text = SAM_LOCALIZED(@"language_input_trade_out_num");
    self.numTextField.placeholder = SAM_LOCALIZED(@"language_input_trade_out_num");
    self.numTextField.text = @"";
    self.balanceLabel.text = @"";
    self.tokenLabel1.text = @"";
    self.tokenLabel2.text = @"";
}

/// 获取余额
- (NSString *)fetchBalanceWithToken:(NSString *)token {
    NSString *balance = @"";
    SAMWalletInfo *curWallet = [SAMWalletDB fetchCurWallet];
    SAMWalletTokenInfo *walletToken = [SAMWalletDB fetchWalletToken:token fromWallet:curWallet.walletName];
    balance = [NSString stringWithFormat:@"%.1lf", walletToken.balance];
    
    return balance;
}

@end
