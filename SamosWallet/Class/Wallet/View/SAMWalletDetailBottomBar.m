//
//  SAMWalletDetailBottomBar.m
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

#import "SAMWalletDetailBottomBar.h"

@interface SAMWalletDetailBottomBar ()

@property (weak, nonatomic) IBOutlet UIButton *backupBtn;
@property (weak, nonatomic) IBOutlet UIButton *removeBtn;

@end


@implementation SAMWalletDetailBottomBar

#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubviews];
}

#pragma mark - public methods
+ (instancetype)bottomBar {
    SAMWalletDetailBottomBar *view = [[NSBundle mainBundle] loadNibNamed:@"SAMWalletDetailBottomBar" owner:nil options:nil].firstObject;
    
    return view;
}

+ (CGFloat)barHeight {
    CGFloat resultH = 0.f;
    // btn h
    resultH += 120.f;
    
    return resultH;
}

#pragma mark - event response
- (IBAction)backupBtnClicked:(id)sender {
    if (self.backupBlock) {
        self.backupBlock();
    }
}

- (IBAction)removeBtnClicked:(id)sender {
    if (self.removeBlock) {
        self.removeBlock();
    }
}

#pragma mark - private methods
- (void)setupSubviews {
    self.backupBtn.layer.borderColor = SAM_BLUE_COLOR.CGColor;
    self.removeBtn.layer.borderColor = SAM_BLUE_COLOR.CGColor;
    [self.backupBtn setTitle:SAM_LOCALIZED(@"language_backup_seed_big") forState:UIControlStateNormal];
    [self.removeBtn setTitle:SAM_LOCALIZED(@"language_remove_wallet") forState:UIControlStateNormal];
}

@end
