//
//  SAMManageWalletBottomView.m
//  SamosWallet
//
//  Created by zys on 2018/8/30.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMManageWalletBottomView.h"

@interface SAMManageWalletBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *createBtn;
@property (weak, nonatomic) IBOutlet UIButton *importBtn;

@end


@implementation SAMManageWalletBottomView

#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubviews];
}

#pragma mark - public methods
+ (instancetype)bottomView {
    SAMManageWalletBottomView *view = [[NSBundle mainBundle] loadNibNamed:@"SAMManageWalletBottomView" owner:nil options:nil].firstObject;
    
    return view;
}

+ (CGFloat)viewHeight {
    CGFloat resultH = 0.f;
    // create btn top
    resultH += 15.f;
    // create btn h
    resultH += 50.f;
    // import btn top
    resultH += 20.f;
    // import btn h
    resultH += 50.f;
    // impot btn bottom
    resultH += 30.f;
    
    return resultH;
}

#pragma mark - event response
- (IBAction)createBtnClicked:(id)sender {
    [SAMControllerTool chooseVCWithScheme:@"samwallet://create_wallet"];
}

- (IBAction)importBtnClicked:(id)sender {
    [SAMControllerTool chooseVCWithScheme:@"samwallet://import_wallet"];
}

#pragma mark - private methods
- (void)setupSubviews {
    self.createBtn.layer.borderColor = SAM_BLUE_COLOR.CGColor;
    self.importBtn.layer.borderColor = SAM_BLUE_COLOR.CGColor;
    [self.createBtn setTitle:SAM_LOCALIZED(@"language_create_new_wallet") forState:UIControlStateNormal];
    [self.importBtn setTitle:SAM_LOCALIZED(@"language_import_a_wallet") forState:UIControlStateNormal];
}

@end
