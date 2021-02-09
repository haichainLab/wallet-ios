//
//  SAMReceiveCell.m
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

#import "SAMReceiveCell.h"

@interface SAMReceiveCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImageView;

/// address
@property (nonatomic, copy) NSString *address;
/// token
@property (nonatomic, copy) NSString *token;
/// num
@property (nonatomic, copy) NSString *num;

@end


@implementation SAMReceiveCell

NSString *const SAMReceiveCellID = @"SAMReceiveCell";
#define kImageRatio (885.f / 1133.f)

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
    [tableView registerNib:[UINib nibWithNibName:@"SAMReceiveCell" bundle:nil] forCellReuseIdentifier:SAMReceiveCellID];
}

+ (CGFloat)cellHeight {
    CGFloat resultH = 0.f;
    // image top
    resultH += 30.f;
    // image h
    resultH += SAM_SCREEN_WIDTH / kImageRatio;
    
    return resultH;
}

- (void)setCellWithAddress:(NSString *)address
                     token:(NSString *)token {
    if (address.length > 0) {
        self.address = address;
        self.addressLabel.text = address;
    }
    if (token.length > 0) {
        self.token = token;
    }
    [self genQRCode];
}

#pragma mark - event response
- (IBAction)numChanged:(id)sender {
    [self genQRCode];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - private methods
- (void)setupSubviews {
    self.addressLabel.text = @"";
    self.numTextField.text = @"";
    self.qrcodeImageView.image = nil;
    self.numTextField.placeholder = SAM_LOCALIZED(@"language_trade_in_num");
}

/// 设置参数
- (void)setupAddressAndNum {
    self.address = self.addressLabel.text;
    self.num = self.numTextField.text.length > 0 ? self.numTextField.text : @"0";
}

/// 生成二维码
- (NSString *)genQRCode {
    // "samos://pay?address=" + address + "&amount=" + amount + "&token=" + token
    [self setupAddressAndNum];
    NSString *qrcodeStr = [NSString stringWithFormat:@"samos://pay?address=%@&amount=%@&token=%@", self.address, self.num, self.token];
    UIImage *image = [SAMTool genQRCodeWithString:qrcodeStr];
    self.qrcodeImageView.image = image;
    
    return qrcodeStr;
}

@end
