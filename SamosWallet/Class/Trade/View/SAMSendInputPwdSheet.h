//
//  SAMSendInputPwdSheet.h
//  SamosWallet
//
//  Created by zys on 2018/12/2.
//  Copyright © 2018 zys. All rights reserved.
//

#import "SAMActionSheet.h"

typedef void(^SAMConfirmPwdBlock)(NSString *pwd);

NS_ASSUME_NONNULL_BEGIN

@interface SAMSendInputPwdSheet : SAMActionSheet

@property (nonatomic, copy) SAMConfirmPwdBlock confirmBlock;

+ (instancetype)sheet;

@end

NS_ASSUME_NONNULL_END
