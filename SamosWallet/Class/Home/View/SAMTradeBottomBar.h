//
//  SAMTradeBottomBar.h
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

/**
 转入、转出bar
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SAMTradeBottomBar : UIView

@property (nonatomic, copy) SAMVoidBlock outBtnClickBlock;
@property (nonatomic, copy) SAMVoidBlock inBtnClickBlock;

+ (instancetype)bottomBar;
+ (CGFloat)barHeight;

@end

NS_ASSUME_NONNULL_END
