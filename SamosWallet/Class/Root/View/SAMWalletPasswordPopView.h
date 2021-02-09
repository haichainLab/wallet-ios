//
//  SAMWalletPasswordPopView.h
//  SamosWallet
//
//  Created by zys on 2018/9/8.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 钱包密码弹窗
 */

#import "SAMPopupView.h"

typedef void(^SAMPwdConfirmBlock)(NSString *pwd, NSString *pwdTip);

@interface SAMWalletPasswordPopView : SAMPopupView

/// 确定按钮回调
@property (nonatomic, copy) SAMPwdConfirmBlock confirmBlock;
/// 是否应该弹窗
+ (BOOL)shouldShow;
/// 保存密码
+ (void)savePwd:(NSString *)pwd;

@end
