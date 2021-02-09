//
//  SAMMeHeaderView.m
//  SamosWallet
//
//  Created by zys on 2018/8/20.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMMeHeaderView.h"

@interface SAMMeHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *walletIconImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *walletIconTop;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end


@implementation SAMMeHeaderView

#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubviews];
}

#pragma mark - public methods
+ (instancetype)header {
    SAMMeHeaderView *view = [[NSBundle mainBundle] loadNibNamed:@"SAMMeHeaderView" owner:nil options:nil].firstObject;
    
    return view;
}

+ (CGFloat)headerHeight {
    CGFloat resultH = 0.f;
    // icon top
    resultH += SAM_NAV_HEIGHT + 30.f;
    // icon h
    resultH += 60.f;
    // title top
    resultH += 20.f;
    // title h
    resultH += 17.f;
    // bottom
    resultH += 30.f;
    
    return resultH;
}

#pragma mark - event response
- (IBAction)headerBtnClicked:(id)sender {
    [SAMControllerTool chooseVCWithScheme:@"samwallet://manage_wallet"];
}

#pragma mark - private methods
- (void)setupSubviews {
    self.walletIconTop.constant = SAM_NAV_HEIGHT + 30.f;
    self.titleLabel.text = [NSString stringWithFormat:@"%@ >", SAM_LOCALIZED(@"language_manage_wallet")];
}

@end
