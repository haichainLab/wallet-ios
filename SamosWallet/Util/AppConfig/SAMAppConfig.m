//
//  SAMAppConfig.m
//  SamosWallet
//
//  Created by zys on 2018/8/19.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMAppConfig.h"
#import "SAMTokenUtil.h"

@implementation SAMAppConfig

#pragma mark - public methods
+ (void)globalSettings {
    // 设置toast背景色
    [SVProgressHUD setBackgroundColor:[UIColor colorFromHexRGB:@"EFEFEF"]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.f];
    [UITabBar appearance].translucent = NO;
}

+ (void)setupAppLanguage {
    if (![SAM_UD objectForKey:SAM_UD_KEY_APP_LANGUAGE]) {
        NSArray *languages = NSLocale.preferredLanguages;
        NSString *language = languages.firstObject;
        if ([language hasPrefix:@"zh-Hans"]) {
            [SAM_UD setObject:@"zh-Hans" forKey:SAM_UD_KEY_APP_LANGUAGE];
        } else {
            [SAM_UD setObject:@"en" forKey:SAM_UD_KEY_APP_LANGUAGE];
        }
        [SAM_UD synchronize];
    }
}

+ (void)setAppLanguage:(SAMLanguageType)languageType {
    NSString *language = [self fetchLanguageWithType:languageType];
    [SAM_UD setObject:language forKey:SAM_UD_KEY_APP_LANGUAGE];
    [SAM_UD synchronize];
}

+ (SAMLanguageType)fetchLanguageType {    
    NSString *savedLang = [SAM_UD objectForKey:SAM_UD_KEY_APP_LANGUAGE];
    if ([savedLang isEqualToString:@"zh-Hans"]) {
        return SAMLanguageTypeCN;
    } else {
        return SAMLanguageTypeEN;
    }
}

+ (void)walletInitCompletion:(SAMBOOLBlock)completion {
    // 1.请求所有token，并更新存储到本地
    [SAMTokenUtil loadTokenDataCompletion:^(SAMTokenNode * _Nonnull token) {
        if (token) {
            // 2.请求所有汇率数据，并更新存储到本地
            [SAMTokenUtil loadCoinRatesCompletion:^(NSArray<SAMCoinRateInfo *> * _Nonnull rates) {
                if (rates && rates.count > 0) {
                    // 3.注册所有币种
                    [SAMTokenUtil registerAllTokens];
                    // 4.初始化钱包数据
                    NSString *pwd = [SAMWalletDB fetchPwd];
                    if (pwd.length > 0) {
                        NSError *error = nil;
                        BOOL ret = MobileInit([SAMPathManager walletDirectory], pwd, &error);
                        if (ret && !error) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:SAMNotificationInitSuccess object:nil];
                            NSLog(@"设备初始化成功！");
                            if (completion) {
                                completion(YES);
                            }
                        } else {
                            NSLog(@"设备初始化失败！");
                            if (completion) {
                                completion(NO);
                            }
                        }
                    } else {
                        NSLog(@"首次启动，未设置密码！");
                        if (completion) {
                            completion(YES);
                        }
                    }
                } else {
                    if (completion) {
                        completion(NO);
                    }
                }
            }];
        } else {
            if (completion) {
                completion(NO);
            }
        }
    }];
}

#pragma mark - private methods
+ (NSString *)fetchLanguageWithType:(SAMLanguageType)languageType {
    NSArray *languages = @[@"zh-Hans",
                           @"en"];
    if (languageType < languages.count) {
        return languages[languageType];
    }
    
    return languages.firstObject;
}

@end
