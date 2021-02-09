//
//  SAMCoinDetailHeader.h
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SAMCoinDetailHeader : UIView

+ (instancetype)header;
+ (CGFloat)headerHeight;
- (void)setHeaderWithModel:(SAMWalletTokenInfo *)model;

@end

NS_ASSUME_NONNULL_END
