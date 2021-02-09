//
//  SAMHomeWalletHeaderView.m
//  SamosWallet
//
//  Created by zys on 2018/8/20.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMHomeWalletHeaderView.h"

@interface SAMHomeWalletHeaderView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *walletIconTop;
@property (weak, nonatomic) IBOutlet UIImageView *walletIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;

@end


@implementation SAMHomeWalletHeaderView

#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubviews];
}

#pragma mark - public methods
+ (instancetype)header {
    SAMHomeWalletHeaderView *view = [[NSBundle mainBundle] loadNibNamed:@"SAMHomeWalletHeaderView" owner:nil options:nil].firstObject;
    
    return view;
}

+ (CGFloat)headerHeight {
    CGFloat resultH = 0.f;
    // icon top
    resultH += (SAM_NAV_HEIGHT + 10.f);
    // icon h
    resultH += 80.f;
    // balance top
    resultH += 15.f;
    // balance h
    resultH += 22.f;
    // unit top
    resultH += 20.f;
    // unit h
    resultH += 15.f;
    // unit botton
    resultH += 15.f;
    // add h
    resultH += 50.f;
    
    return resultH;
}

- (void)setHeaderWithModel:(SAMWalletInfo *)info {
    if (info) {
        if (info.walletIcon.length > 0) {
            self.walletIconImageView.image = [UIImage imageNamed:info.walletIcon];
            if (info.balance > 0.f) {
                self.balanceLabel.text = [NSString stringWithFormat:@"%.3lf", info.balance];
            } else {
                self.balanceLabel.text = @"0.000";
            }
        }
        NSString *curUnit = [SAMWalletDB fetchCurCoinUnit];
        if ([curUnit isEqualToString:@"CNY"]) {
            self.unitLabel.text = [NSString stringWithFormat:@"%@(¥)", SAM_LOCALIZED(@"language_total_assets")];
        } else {
            self.unitLabel.text = [NSString stringWithFormat:@"%@($)", SAM_LOCALIZED(@"language_total_assets")];
        }
    }
}

#pragma mark - event response
- (IBAction)addBtnClicked:(id)sender {
    [SAMControllerTool chooseVCWithScheme:@"samwallet://add_coin"];
}

#pragma mark - private methods
- (void)setupSubviews {
    self.walletIconTop.constant = SAM_NAV_HEIGHT + 10.f;
    self.walletIconImageView.image = nil;
    self.balanceLabel.text = @"0.00";
    self.unitLabel.text = @"总资产(¥)";
    self.addLabel.text = SAM_LOCALIZED(@"language_add");
}

@end
