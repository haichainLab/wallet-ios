//
//  SAMAboutUsHeaderView.m
//  SamosWallet
//
//  Created by zys on 2018/8/20.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMAboutUsHeaderView.h"

@interface SAMAboutUsHeaderView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTop;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end


@implementation SAMAboutUsHeaderView

#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubviews];
}

#pragma mark - public methods
+ (instancetype)header {
    SAMAboutUsHeaderView *view = [[NSBundle mainBundle] loadNibNamed:@"SAMAboutUsHeaderView" owner:nil options:nil].firstObject;
    
    return view;
}

+ (CGFloat)headerHeight {
    CGFloat resultH = 0.f;
    // icon top
    resultH += SAM_NAV_HEIGHT + 30.f;
    // icon h
    resultH += 90.f;
    // title top
    resultH += 30.f;
    // title h
    resultH += 17.f;
    // bottom
    resultH += 60.f;
    
    return resultH;
}

#pragma mark - private methods
- (void)setupSubviews {
    self.logoTop.constant = SAM_NAV_HEIGHT + 50.f;
    self.titleLabel.text = SAM_LOCALIZED(@"language_about_us_desc");
}

@end
