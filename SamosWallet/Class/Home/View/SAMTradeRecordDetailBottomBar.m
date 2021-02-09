//
//  SAMTradeRecordDetailBottomBar.m
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

#import "SAMTradeRecordDetailBottomBar.h"

@interface SAMTradeRecordDetailBottomBar ()

@property (weak, nonatomic) IBOutlet UIButton *samCopyBtn;

@end


@implementation SAMTradeRecordDetailBottomBar

#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubviews];
}

#pragma mark - public methods
+ (instancetype)bottomBar {
    SAMTradeRecordDetailBottomBar *view = [[NSBundle mainBundle] loadNibNamed:@"SAMTradeRecordDetailBottomBar" owner:nil options:nil].firstObject;
    
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
- (IBAction)copyBtnClicked:(id)sender {
    if (self.samCopyBlock) {
        self.samCopyBlock();
    }
}

#pragma mark - private methods
- (void)setupSubviews {
    self.samCopyBtn.layer.borderColor = SAM_BLUE_COLOR.CGColor;
    [self.samCopyBtn setTitle:SAM_LOCALIZED(@"language_copy_address") forState:UIControlStateNormal];
}

@end
