//
//  SAMHomeMenuHeaderView.m
//  SamosWallet
//
//  Created by zys on 2018/8/21.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMHomeMenuHeaderView.h"

@implementation SAMHomeMenuHeaderView

#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - public methods
+ (instancetype)header {
    SAMHomeMenuHeaderView *view = [[NSBundle mainBundle] loadNibNamed:@"SAMHomeMenuHeaderView" owner:nil options:nil].firstObject;
    
    return view;
}

+ (CGFloat)headerHeight {
    CGFloat resultH = 0.f;
    // icon top
    resultH += 50.f;
    // icon h
    resultH += 65.f;
    // icon bottom
    resultH += 20.f;
    
    return resultH;
}

@end
