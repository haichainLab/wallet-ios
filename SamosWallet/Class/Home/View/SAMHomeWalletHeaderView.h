//
//  SAMHomeWalletHeaderView.h
//  SamosWallet
//
//  Created by zys on 2018/8/20.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 首页-钱包-蓝色header
 */

#import <UIKit/UIKit.h>

@interface SAMHomeWalletHeaderView : UIView

+ (instancetype)header;
+ (CGFloat)headerHeight;
- (void)setHeaderWithModel:(SAMWalletInfo *)info;

@end
