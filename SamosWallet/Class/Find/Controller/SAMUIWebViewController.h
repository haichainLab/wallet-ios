//
//  SAMUIWebViewController.h
//  SAM
//
//  Created by zys on 2017/7/15.
//  Copyright © 2017年 Xiaobu. All rights reserved.
//

/**
 封装UIWebview，调用H5
 */

#import "SAMBaseViewController.h"

@interface SAMUIWebViewController : SAMBaseViewController

/// webivew
@property (nonatomic, strong, readonly) UIWebView *webView;
@property (nonatomic, copy) NSString *URLString;

+ (instancetype)pushFrom:(UIViewController *)fromVC
           withURLString:(NSString *)urlStr;
- (void)hideNavbar;
- (void)reloadPage;

@end
