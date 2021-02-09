//
//  SAMReceiveBottomBar.m
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

#import "SAMReceiveBottomBar.h"

@interface SAMReceiveBottomBar ()

@property (weak, nonatomic) IBOutlet UIButton *samCopyBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end


@implementation SAMReceiveBottomBar

#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubviews];
}

#pragma mark - public methods
+ (instancetype)bottomBar {
    SAMReceiveBottomBar *view = [[NSBundle mainBundle] loadNibNamed:@"SAMReceiveBottomBar" owner:nil options:nil].firstObject;
    
    return view;
}

+ (CGFloat)barHeight {
    CGFloat resultH = 0.f;
    // btn h
    resultH += 120.f;
    
    return resultH;
}

#pragma mark - event response
- (IBAction)copyBtnClicked:(id)sender {
    if (self.samCopyBlock) {
        self.samCopyBlock();
    }
}

- (IBAction)saveBtnClicked:(id)sender {
    if (self.saveBlock) {
        self.saveBlock();
    }
}

#pragma mark - private methods
- (void)setupSubviews {
    self.samCopyBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.saveBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.samCopyBtn setTitle:SAM_LOCALIZED(@"language_copy_address") forState:UIControlStateNormal];
    [self.saveBtn setTitle:SAM_LOCALIZED(@"language_save_to_ablum") forState:UIControlStateNormal];
}

@end
