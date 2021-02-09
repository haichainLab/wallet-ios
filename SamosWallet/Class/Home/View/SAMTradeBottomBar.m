//
//  SAMTradeBottomBar.m
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

#import "SAMTradeBottomBar.h"

@interface SAMTradeBottomBar ()

@property (weak, nonatomic) IBOutlet UIButton *outBtn;
@property (weak, nonatomic) IBOutlet UIButton *inBtn;

@end


@implementation SAMTradeBottomBar

#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubviews];
}

#pragma mark - public methods
+ (instancetype)bottomBar {
    SAMTradeBottomBar *view = [[NSBundle mainBundle] loadNibNamed:@"SAMTradeBottomBar" owner:nil options:nil].firstObject;
    
    return view;
}

+ (CGFloat)barHeight {
    CGFloat resultH = 0.f;
    // btn h
    resultH += 40.f;
    // btn bottom
    resultH += 20.f;
    
    return resultH;
}

#pragma mark - event response
- (IBAction)outBtnClicked:(id)sender {
    
    [HaiProtocolTool clearCallURLInfo];
    if (self.outBtnClickBlock) {
        self.outBtnClickBlock();
    }
}

- (IBAction)inBtnClicked:(id)sender {
    if (self.inBtnClickBlock) {
        self.inBtnClickBlock();
    }
}

#pragma mark - private methods
- (void)setupSubviews {
    self.outBtn.layer.borderColor = SAM_BLUE_COLOR.CGColor;
    self.inBtn.layer.borderColor = SAM_BLUE_COLOR.CGColor;
    [self.outBtn setTitle:SAM_LOCALIZED(@"language_trade_out_big") forState:UIControlStateNormal];
    [self.inBtn setTitle:SAM_LOCALIZED(@"language_trade_in_big") forState:UIControlStateNormal];
    
    SAMWalletInfo *curWallet = [SAMWalletDB fetchCurWallet];
    BOOL isLoked = [SAMWalletDB isTokenLocked:curWallet.walletName];
    if(!isLoked){
        self.outBtn.enabled = YES;
    }else{
        [self.outBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //self.outBtn.titleLabel.textColor = [UIColor grayColor];
        self.outBtn.enabled = NO;
    }
}

@end
