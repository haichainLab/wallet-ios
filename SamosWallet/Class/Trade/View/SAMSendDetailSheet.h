//
//  SAMSendDetailSheet.h
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

#import "SAMActionSheet.h"

NS_ASSUME_NONNULL_BEGIN

@interface SAMSendDetailSheet : SAMActionSheet

@property (nonatomic, copy) SAMVoidBlock confirmBlock;

+ (instancetype)sheet;
- (void)setSheetWithToken:(NSString *)token
                  address:(NSString *)address
                      num:(NSString *)num;

@end

NS_ASSUME_NONNULL_END
