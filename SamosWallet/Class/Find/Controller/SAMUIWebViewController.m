//
//  SAMUIWebViewController.m
//  XB
//
//  Created by zys on 2017/7/15.
//  Copyright © 2017年 Xiaobu. All rights reserved.
//

#import "SAMUIWebViewController.h"

@interface SAMUIWebViewController () <UIWebViewDelegate>

/// webivew
@property (nonatomic, strong) UIWebView *webView;

@end


@implementation SAMUIWebViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadH5Page];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public methods
+ (instancetype)pushFrom:(UIViewController *)fromVC withURLString:(NSString *)urlStr {
    SAMUIWebViewController *vc = [SAMUIWebViewController new];
    vc.URLString = urlStr;
    [fromVC.navigationController pushViewController:vc animated:YES];
    
    return vc;
}

- (void)hideNavbar {
    SAMWeakSelf
    self.sam_navigationBar.hidden = YES;
    [_webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsZero);
    }];
}

- (void)reloadPage {
    [self loadH5Page];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"===UIWebView开始加载...");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"===UIWebView加载完成");
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (title && title.length > 0) {
        self.sam_navigationBar.title = title;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"===UIWebView加载失败: %@", error);
}

#pragma mark - private methiods
- (void)setupVariables {
    [super setupVariables];
    self.navBGColor = SAMNavigationBarBGColorBlue;
}

- (void)setupSubviews {
    SAMWeakSelf
    [super setupSubviews];
    self.sam_navigationBar.title = @"加载中...";
    self.sam_navigationBar.backBlock = ^{
        [weakSelf normalBack];
    };
    [self.sam_navigationBar showBackBtn:NO];
}

- (void)loadH5Page {
    if (self.URLString && self.URLString.length > 0) {
        NSURL *url = [NSURL URLWithString:self.URLString];
        if (url) {
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [self.webView loadRequest:request];
        }
    }
}

/// 正常返回
- (void)normalBack {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self closeH5];
    }
}

/// 退出H5页面
- (void)closeH5 {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - getters / setters
- (UIWebView *)webView {
    if (!_webView) {
        SAMWeakSelf
        _webView = [UIWebView new];
        [self.view addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view).offset(SAM_NAV_HEIGHT);
            make.left.right.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.view);
        }];
        _webView.delegate = self;
    }
    
    return _webView;
}

@end
