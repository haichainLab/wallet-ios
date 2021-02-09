//
//  SAMTokenUtil.m
//  SamosWallet
//
//  Created by zys on 2018/11/11.
//  Copyright © 2018 zys. All rights reserved.
//

#import "SAMTokenUtil.h"
#import "SAMNetwork.h"
#import "SAMApi.h"
#import "SAMTokenNode.h"
#import "SAMCoinRateInfo.h"

/// 超时时间设置
static NSTimeInterval kTimeoutInterval = 7.f;
/// 最大请求次数
static NSInteger kMaxRequestCount = 2;
/// 当前请求次数
static NSInteger kCurRequestCount = 0;

@implementation SAMTokenUtil

#pragma mark - public methods
+ (void)loadTokenDataCompletion:(void (^) (SAMTokenNode *token))completion {
    
    NSString *urlStr = [SAMApiBaseURLString stringByAppendingPathComponent:SAMApiGetToken];
    
    // 给请求设置超时时间，超过则重新请求
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    req.timeoutInterval = kTimeoutInterval;
    kCurRequestCount++;
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data && !connectionError) {
            // 清零请求计数
            kCurRequestCount = 0;
            NSString *encryptStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString *decryptStr = [encryptStr decrypt3DES];
            SAMTokenNode *model = [SAMTokenNode yy_modelWithJSON:decryptStr];
            // save default token
            [SAMWalletDB saveDefaultToken:model.defaultToken];
            // save coin list
            if (model.tokens.count > 0) {
                [model.tokens enumerateObjectsUsingBlock:^(SAMTokenInfo *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [SAMWalletDB saveToken:obj];
                }];
            }
            if (completion) {
                completion(model);
            }
        } else {
            // 网络出错，从本地读取
            NSArray *tokens = [SAMWalletDB fetchAllTokens];
            if (tokens.count > 0) {
                SAMTokenNode *model = [SAMTokenNode new];
                model.defaultToken = [SAMWalletDB fetchDefaultToken].token;
                model.tokens = tokens;
                if (completion) {
                    completion(model);
                }
            } else if (kCurRequestCount < kMaxRequestCount) {
                // 第一次安装，本地无数据，则再请求一次，直到达到最大请求次数
                [SAMTokenUtil loadTokenDataCompletion:^(SAMTokenNode * _Nonnull token) {
                    if (completion) {
                        completion(token);
                    }
                }];
            } else {
                if (completion) {
                    completion(nil);
                }
            }
        }
    }];
}

+ (void)loadCoinRatesCompletion:(void (^) (NSArray <SAMCoinRateInfo *> *rates))completion {
    
    [SAMNetwork GETWithURLStr:SAMApiGetPrice parameters:nil success:^(id responseObject) {
        NSArray *retArray = [NSArray yy_modelArrayWithClass:[SAMCoinRateInfo class] json:responseObject[@"data"]];
        [SAMWalletDB saveAllRates:retArray];
        if (completion) {
            completion(retArray);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        // 网络出错，从本地读取
        NSArray *retArray = [SAMWalletDB fetchAllCoinRates];
        if (completion) {
            completion(retArray);
        }
    }];
}

+ (BOOL)regiseterToken:(SAMTokenInfo *)token {
    NSError *error = nil;
    BOOL ret = MobileRegisterNewCoin(token.tokenName, token.hostApi, &error);
    if (!ret && error) {
        NSLog(@"注册币种失败：%@", error);
    }
    
    return ret;
}

+ (void)showTimeoutAlert {
    // 失败，弹alert，不再继续
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"下载配置失败，请关闭后重新启动" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        exit(0);
    }];
    if (@available(iOS 9.0, *)) {
        [confirmAction setValue:SAM_GRAY_COLOR forKey:@"titleTextColor"];
    }
    [alert addAction:confirmAction];
    [[SAMControllerTool currentVC] presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 注册所有token
+ (void)registerAllTokens {
    NSArray <SAMTokenInfo *> *tokens = [SAMWalletDB fetchAllTokens];
    [tokens enumerateObjectsUsingBlock:^(SAMTokenInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [SAMTokenUtil regiseterToken:obj];
    }];
}

/// 添加新币种
+ (void)addNewCoin:(SAMTokenInfo *)token {
    NSError *error = nil;
    NSString *pwd = [SAMWalletDB fetchPwd];
    if (token) {
        [self regiseterToken:token];
        // 当前钱包
        SAMWalletInfo *wallet = [SAMWalletDB fetchCurWallet];
        // 获取默认token
        SAMTokenInfo *defaultToken = [SAMWalletDB fetchDefaultToken];
        // 获取默认token的walletID
        NSString *defaultWalletID = [SAMWalletDB fetchWalletToken:defaultToken.token fromWallet:wallet.walletName].walletID;
        if (defaultWalletID.length > 0) {
            NSString *words = MobileGetSeed(defaultWalletID, pwd, &error);
            if (pwd.length > 0 && words.length > 0) {
                if ([SAMWalletUtil createWalletWithWalletName:wallet.walletName walletIcon:wallet.walletIcon walletSeed:words token:token]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD showSuccessWithStatus:SAM_LOCALIZED(@"language_add_success")];
                    });
                }
            } else {
                NSLog(@"MobileGetSeed error: %@", error);
            }
        }
    }
}

+ (void)removeCoin:(SAMTokenInfo *)token {
    if (token) {
        SAMWalletInfo *wallet = [SAMWalletDB fetchCurWallet];
        if (wallet) {
            SAMWalletTokenInfo *walletToken = [SAMWalletDB fetchWalletToken:token.token fromWallet:wallet.walletName];
            [SAMWalletDB removeWalletToken:walletToken.walletID];
            NSError *error = nil;
            MobileRemove(walletToken.walletID, &error);
            if (error) {
                NSLog(@"MobileRemove error: %@", error);
            }
        }
    }
}

+ (BOOL)isTokenSelected:(SAMTokenInfo *)token {
    BOOL result = NO;
    if (token) {
        SAMWalletInfo *wallet = [SAMWalletDB fetchCurWallet];
        if (wallet.walletName.length > 0) {
            SAMWalletTokenInfo *walletToken = [SAMWalletDB fetchWalletToken:token.token fromWallet:wallet.walletName];
            if (walletToken.walletID.length > 0) {
                result = YES;
            }
        }
    }
    
    return result;
}

@end
