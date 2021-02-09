//
//  SAMAppConfig.h
//  SamosWallet
//
//  Created by zys on 2018/8/19.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 App配置类
 */

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SAMLanguageType) {
    SAMLanguageTypeCN = 0, // 中文
    SAMLanguageTypeEN,     // 英文
};

@interface SAMAppConfig : NSObject

/// 全局设置
+ (void)globalSettings;
/// 初始化语言
+ (void)setupAppLanguage;
/// 设置语言:en / zh-Hans
+ (void)setAppLanguage:(SAMLanguageType)languageType;
/// 获取语言类别
+ (SAMLanguageType)fetchLanguageType;
/// 初始化钱包
+ (void)walletInitCompletion:(SAMBOOLBlock)completion;

@end
