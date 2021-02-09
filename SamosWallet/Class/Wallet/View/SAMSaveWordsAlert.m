//
//  SAMSaveWordsAlert.m
//  SamosWallet
//
//  Created by zys on 2018/9/2.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMSaveWordsAlert.h"

@interface SAMSaveWordsAlert ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *knowBtn;
@property (weak, nonatomic) IBOutlet UIView *whiteContainerView;

@end


@implementation SAMSaveWordsAlert

#pragma mark - public methods
+ (instancetype)popView {
    SAMSaveWordsAlert *view = [[NSBundle mainBundle] loadNibNamed:@"SAMSaveWordsAlert" owner:nil options:nil].firstObject;
    view.allowAnimation = NO;
    
    return view;
}

#pragma mark - event response
- (IBAction)konwBtnClicked:(id)sender {
    [self dismiss];
}

#pragma mark - private methods
- (void)setupSubviews {
    [super setupSubviews];
    self.titleLabel.text = SAM_LOCALIZED(@"language_to_secure_asset");
    self.subTitleLabel.text = SAM_LOCALIZED(@"language_not_copy_seed");
    [self.knowBtn setTitle:SAM_LOCALIZED(@"language_got_it") forState:UIControlStateNormal];
}

- (void)placeSubviews {
    [super placeSubviews];
    SAMWeakSelf
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.containerView);
        make.width.equalTo(@200.f);
        make.bottom.equalTo(weakSelf.knowBtn);
    }];
}

@end
