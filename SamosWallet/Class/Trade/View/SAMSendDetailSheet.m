//
//  SAMSendDetailSheet.m
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

#import "SAMSendDetailSheet.h"

@interface SAMSendDetailSheet ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *typeKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *addresssKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *addresssValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *numKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *numValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeValueLabel;

@end


@implementation SAMSendDetailSheet


#pragma mark - public methods
+ (instancetype)sheet {
    SAMSendDetailSheet *sheet = [[NSBundle mainBundle] loadNibNamed:@"SAMSendDetailSheet" owner:nil options:nil].firstObject;
    sheet.orgSize = CGSizeMake(SAM_SCREEN_WIDTH, [self sheetHeight]);
    
    return sheet;
}

+ (CGFloat)sheetHeight {
    CGFloat resultH = 0.f;
    // nav h
    resultH += 44.f;
    // text top
    resultH += 10.f;
    // text h
    resultH += (10.f + 15.f) * 4.f;
    // btn top
    resultH += 20.f;
    // btn h
    resultH += 40.f;
    // btn bottom
    resultH += 25.f - SAM_TABLE_BOTTOM;
    
    return resultH;
}

- (void)setSheetWithToken:(NSString *)token
                  address:(NSString *)address
                      num:(NSString *)num {
    if (token.length > 0) {
        //xxl 0.0.0 hai to haic
        NSString * tokenName = token;
        if([tokenName isEqualToString:@"HAI"]){
            tokenName = @"HAIC";
        }
        self.typeValueLabel.text = [NSString stringWithFormat:@"%@ %@", SAM_LOCALIZED(@"language_send"),tokenName];
    }
    if (address.length > 0) {
        self.addresssValueLabel.text = address;
    }
    if (num.length > 0) {
        self.numValueLabel.text = num;
    }
}
#pragma mark - event response
- (IBAction)closeBtnClicked:(id)sender {
    [self dismiss];
}

- (IBAction)confirmBtnClicked:(id)sender {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
    [self dismiss];
}

#pragma mark - private methods
- (void)setupSubviews {
    [super setupSubviews];
    self.confirmBtn.layer.borderColor = SAM_BLUE_COLOR.CGColor;
    self.titleLabel.text = SAM_LOCALIZED(@"language_trade_out_detail");
    self.typeKeyLabel.text = SAM_LOCALIZED(@"language_trade_type");
    self.typeValueLabel.text = @"";
    self.addresssKeyLabel.text = SAM_LOCALIZED(@"language_trade_in_address");
    self.addresssValueLabel.text = @"";
    self.numKeyLabel.text = SAM_LOCALIZED(@"language_trade_num");
    self.numValueLabel.text = @"";
    self.timeKeyLabel.text = SAM_LOCALIZED(@"language_trade_time");
    self.timeValueLabel.text = [SAMTool formatTimeStamp:[[NSDate date] timeIntervalSince1970]];
    [self.confirmBtn setTitle:SAM_LOCALIZED(@"language_confirm_big") forState:UIControlStateNormal];
}

@end
