//
//  HaiExplorer.m
//  SamosWallet
//
//  Created by xu xinlai on 2019/10/26.
//  Copyright © 2019年 Samos. All rights reserved.
//
#import "HaiExplorerController.h"
#import "SAMNetwork.h"

typedef enum{
    loadWebURLString = 0,
    loadWebHTMLString,
    POSTWebURLString,
}wkWebLoadType;

static void *WkwebBrowserContext = &WkwebBrowserContext;

@interface HaiExplorerController()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UINavigationControllerDelegate,UINavigationBarDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;
//设置加载进度条
@property (nonatomic,strong) UIProgressView *progressView;
//仅当第一次的时候加载本地JS
@property(nonatomic,assign) BOOL needLoadJSPOST;
//网页加载的类型
@property(nonatomic,assign) wkWebLoadType loadType;
//保存的网址链接
@property (nonatomic, copy) NSString *URLString;
//保存POST请求体
@property (nonatomic, copy) NSString *postData;
//保存请求链接
@property (nonatomic)NSMutableArray* snapShotsArray;
////返回按钮
@property (nonatomic)UIBarButtonItem* customBackBarItem;

////返回按钮
@property (nonatomic)UIButton* customBackBarBtn;
//关闭按钮
@property (nonatomic)UIBarButtonItem* closeButtonItem;

@end

@implementation HaiExplorerController

#pragma mark - life cycle
+ (void)load {
    [MGJRouter registerURLPattern:@"samwallet://hai_explorer" toHandler:^(NSDictionary *routerParameters) {
        HaiExplorerController *vc = [HaiExplorerController new];
        vc.URLString = routerParameters[@"url"];
        [SAMControllerTool showVC:vc];
    }];
}

- (void)viewDidLoad {
    
    //self.navigationController.navigationBar.title = @"Haichain分红投票";
    //self.tabBarItem.title = @"Haichain分红投票";
    //xxl 0.0.5 bindaddress
    self.sam_navigationBar.title = @"Haichain地址绑定";
    [super viewDidLoad];
    //加载web页面
    [self webViewloadURLType];
    
    //添加到主控制器上
    [self.view addSubview:self.wkWebView];
    
    //添加进度条
    [self.view addSubview:self.progressView];
    
    //添加右边刷新按钮
    UIBarButtonItem *roadLoad = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(roadLoadClicked)];
    self.navigationItem.rightBarButtonItem = roadLoad;

    [self.sam_navigationBar addSubview:self.customBackBarBtn];
    [self.sam_navigationBar showBackBtn:NO];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_isNavHidden == YES) {
        self.navigationController.navigationBarHidden = YES;
        //创建一个高20的假状态栏
        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
        //设置成绿色
        statusBarView.backgroundColor=[UIColor whiteColor];
        // 添加到 navigationBar 上
        [self.view addSubview:statusBarView];
    }else{
        self.navigationController.navigationBarHidden = NO;
    }
}


- (void)roadLoadClicked{
    [self.wkWebView reload];
}


#pragma mark - event response
- (void)customBackItemClicked:(UIBarButtonItem *)btn {
    if (self.wkWebView.goBack) {
        [self.wkWebView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)closeItemClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ================ 加载方式 ================
- (void)webViewloadURLType{
    switch (self.loadType) {
        case loadWebURLString:{
            //创建一个NSURLRequest 的对象
            NSURLRequest * Request_zsj = [NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            //加载网页
            [self.wkWebView loadRequest:Request_zsj];
            break;
        }
        case loadWebHTMLString:{
            [self loadHostPathURL:self.URLString];
            break;
        }
        case POSTWebURLString:{
            // JS发送POST的Flag，为真的时候会调用JS的POST方法
            self.needLoadJSPOST = YES;
            //POST使用预先加载本地JS方法的html实现，请确认WKJSPOST存在
            [self loadHostPathURL:@"WKJSPOST"];
            break;
        }
    }
}

- (void)loadHostPathURL:(NSString *)url{
    //获取JS所在的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:url ofType:@"html"];
    //获得html内容
    NSString *html = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //加载js
    [self.wkWebView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
}

// 调用JS发送POST请求
- (void)postRequestWithJS {
    // 拼装成调用JavaScript的字符串
    NSString *jscript = [NSString stringWithFormat:@"post('%@',{%@});", self.URLString, self.postData];
    // 调用JS代码
    [self.wkWebView evaluateJavaScript:jscript completionHandler:^(id object, NSError * _Nullable error) {
    }];
}

- (void)loadWebURLSring:(NSString *)string{
    self.URLString = string;
    self.loadType = loadWebURLString;
}

- (void)loadWebHTMLSring:(NSString *)string{
    self.URLString = string;
    self.loadType = loadWebHTMLString;
}

- (void)POSTWebURLSring:(NSString *)string postData:(NSString *)postData{
    self.URLString = string;
    self.postData = postData;
    self.loadType = POSTWebURLString;
}

//#pragma mark   ============== URL pay 开始支付 ==============
//
//- (void)payWithUrlOrder:(NSString*)urlOrder
//{
//    if (urlOrder.length > 0) {
//        __weak XFWkwebView* wself = self;
//        [[AlipaySDK defaultService] payUrlOrder:urlOrder fromScheme:@"giftcardios" callback:^(NSDictionary* result) {
//            // 处理支付结果
//            NSLog(@"===============%@", result);
//            // isProcessUrlPay 代表 支付宝已经处理该URL
//            if ([result[@"isProcessUrlPay"] boolValue]) {
//                // returnUrl 代表 第三方App需要跳转的成功页URL
//                NSString* urlStr = result[@"returnUrl"];
//                [wself loadWithUrlStr:urlStr];
//            }
//        }];
//    }
//}
//
//- (void)WXPayWithParam:(NSDictionary *)WXparam{
//
//}
////url支付成功回调地址
//- (void)loadWithUrlStr:(NSString*)urlStr
//{
//    if (urlStr.length > 0) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSURLRequest *webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReturnCacheDataElseLoad
//                                                    timeoutInterval:15];
//            [self.wkWebView loadRequest:webRequest];
//        });
//    }
//}

#pragma mark ================ 自定义返回/关闭按钮 ================

-(void)updateNavigationItems{
//    if (self.wkWebView.canGoBack) {
//        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        spaceButtonItem.width = -6.5;
//
//        [self.navigationItem setLeftBarButtonItems:@[spaceButtonItem,self.customBackBarItem,self.closeButtonItem] animated:NO];
//    }else{
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//        [self.navigationItem setLeftBarButtonItems:@[self.customBackBarItem]];
        
        
//
//        self.navigationController.view.layer.borderWidth = 2;
//        self.navigationController.view.layer.borderColor = UIColor.blueColor.CGColor;
//        //self.sam_navigationBar.hidesBackButton=YES;
//
//
//        UIImage *buttonImage = [UIImage imageNamed:@"sam_close"];
//        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [aButton setImage:buttonImage forState:UIControlStateNormal];
//        aButton.frame = CGRectMake(0.0,0.0,buttonImage.size.width,buttonImage.size.height);
//        [aButton addTarget:self action:@selector(customBackItemClicked) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:aButton];
//        self.navigationItem.leftBarButtonItem = backButton;
        
        //self.navigationItem.leftBarButtonItem = self.customBackBarItem;
        //[self.navigationItem setLeftBarButtonItems:@[self.customBackBarItem]];
        
        //self.navigationController?.navigationBar.topItem.leftBarButtonItem = self.customBackBarItem;
//    }
}

//请求链接处理
-(void)pushCurrentSnapshotViewWithRequest:(NSURLRequest*)request{
    //    NSLog(@"push with request %@",request);
    NSURLRequest* lastRequest = (NSURLRequest*)[[self.snapShotsArray lastObject] objectForKey:@"request"];
    
    //如果url是很奇怪的就不push
    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
        //        NSLog(@"about blank!! return");
        return;
    }
    //如果url一样就不进行push
    if ([lastRequest.URL.absoluteString isEqualToString:request.URL.absoluteString]) {
        return;
    }
    UIView* currentSnapShotView = [self.wkWebView snapshotViewAfterScreenUpdates:YES];
    [self.snapShotsArray addObject:
     @{@"request":request,@"snapShotView":currentSnapShotView}];
}

#pragma mark ================ WKNavigationDelegate ================

//这个是网页加载完成，导航的变化
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    /*
     主意：这个方法是当网页的内容全部显示（网页内的所有图片必须都正常显示）的时候调用（不是出现的时候就调用），，否则不显示，或则部分显示时这个方法就不调用。
     */
    // 判断是否需要加载（仅在第一次加载）
    if (self.needLoadJSPOST) {
        // 调用使用JS发送POST请求的方法
        [self postRequestWithJS];
        // 将Flag置为NO（后面就不需要加载了）
        self.needLoadJSPOST = NO;
    }
    // 获取加载网页的标题
    self.title = self.wkWebView.title;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateNavigationItems];
}

//开始加载
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //开始加载的时候，让加载进度条显示
    self.progressView.hidden = NO;
}

//内容返回时调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{}

//服务器请求跳转的时候调用
-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{}

//服务器开始请求的时候调用
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSLog(@"1-------在发送请求之前，决定是否跳转  -->%@",navigationAction.request);
    NSURL *url = navigationAction.request.URL;
    if([url.scheme isEqualToString:@"haichain"]){
        
        //跳转到支付页面
        NSString * host = [url host];
        //xxl 0.0.2 add for lock wallet
        if ([host isEqualToString: HAI_HOST_LOCK_WALLET]) {
            
            //获得其他参数
            NSDictionary *params = [SAMWalletUtil getUrlParameterWithUrl:url];

            //转账主钱包的钱包
            SAMWalletInfo *orgWallet = [SAMWalletDB fetchCurWallet];
            //检查wallet名是否重复
            SAMWalletInfo * newWallet = [SAMWalletDB fetchWallet : params[HAI_PARAM_WALLET_NAME]];

            if(newWallet != nil){
                 //[SVProgressHUD showErrorWithStatus:SAM_LOCALIZED(@"language_wallet_name_duplicate")];
                [self sendCoin:orgWallet.walletName :params[HAI_PARAM_COIN_NAME] :newWallet.address :params[HAI_PARAM_AMOUNT] :@"HAI"];
            }else{
                //获得seed
                NSString * seed= MobileNewSeed();
                //获得token
                NSString* tokenName = params[HAI_PARAM_COIN_NAME];
                if([tokenName isEqualToString:@"HAIC"]){
                    tokenName = @"HAI";
                }
                
                SAMTokenInfo *lockTokenInfo = [SAMWalletDB fetchToken:tokenName];
                //创建钱包
                BOOL flag = [self createWalletWithWalletName:params[HAI_PARAM_WALLET_NAME]
                                                           walletIcon:@"sam_wallet_icon_1"
                                                           walletSeed:seed
                                                           token:lockTokenInfo];
                
                newWallet = [SAMWalletDB fetchWallet : params[HAI_PARAM_WALLET_NAME]];
                
                if(flag){
                    //转账
                    //获得新钱包的地址
                    [self sendCoin:orgWallet.walletName :params[HAI_PARAM_COIN_NAME] :newWallet.address :params[HAI_PARAM_AMOUNT] :@"HAI"];
                    
                }
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:SAM_LOCALIZED(@"language_lock_wallet_success")];
            });
            NSLog(@"come to haichain");
            // Add the lock to DB
            LockTokenInfo *_Nonnull lockTokenObj = [LockTokenInfo new];
            lockTokenObj.walletName = params[HAI_PARAM_WALLET_NAME];
            [SAMWalletDB saveLockToken:lockTokenObj];
            
            [self normalBack];
            
        }else if([host isEqualToString: HAI_HOST_GO_BACK]){
            [self normalBack];
        // xxl 0.0.4 vote
        }else if([host isEqualToString: HAI_HOST_VOTE]){
            
            NSLog(@"come to vote");
            
            //获得其他参数
            NSDictionary *params = [SAMWalletUtil getUrlParameterWithUrl:url];

            //转账主钱包的钱包
            SAMWalletInfo *curWallet = [SAMWalletDB fetchCurWallet];
            SAMWalletTokenInfo *walletToken = [SAMWalletDB fetchWalletToken:@"HAI" fromWallet:curWallet.walletName];
            CGFloat num = walletToken.balance * 0.005;
            NSString *strNum = [NSString stringWithFormat:@"%.3lf",num];
            NSString *callbackUrl = params[@"callbackurl"];
            NSString *toAddress = params[@"toaddress"];

            NSDictionary *postParam = @{
                                           @"address"       : curWallet.address,
                                           @"vote_no"       : params[@"voteno"],
                                           @"vote_result"   : params[@"voteresult"]};

               [SAMNetwork POSTWithURLStr:callbackUrl parameters:postParam success:^(id responseObject) {
                   NSLog(@"post OK");
               } failure:^(NSError *error) {
                   NSLog(@"post Error");
               }];

            //toAddress
            [self sendCoin : curWallet.walletName
                           : @"galtcoin"            //tokename
                           : toAddress
                           : strNum
                           : @"GALT"];              //token
            
            
            //load success reuslt
//            NSString *scheme = [NSString stringWithFormat:@"samwallet://hai_explorer?url=%@&result=0",url];
//            [SAMControllerTool chooseVCWithScheme:scheme];
    
        }
        
        
    }
    
    //xxl 0.0.4 vote
    if([url.scheme isEqualToString:@"haichainvote"]){
        
        
        NSLog(@"come to vote");
        
        //获得其他参数
        NSDictionary *params = [SAMWalletUtil getUrlParameterWithUrl:url];

        //转账主钱包的钱包
        SAMWalletInfo *curWallet = [SAMWalletDB fetchCurWallet];
        SAMWalletTokenInfo *walletToken = [SAMWalletDB fetchWalletToken:@"HAI" fromWallet:curWallet.walletName];
        CGFloat num = walletToken.balance * 0.005;
        NSString *strNum = [NSString stringWithFormat:@"%.3lf",num];
        NSString *callbackUrl = params[@"callbackurl"];
        NSString *toAddress = params[@"toaddress"];

        NSDictionary *postParam = @{
                                       @"address"       : curWallet.address,
                                       @"vote_no"       : params[@"voteno"],
                                       @"vote_result"   : params[@"voteresult"]};

           [SAMNetwork POSTWithURLStr:callbackUrl parameters:postParam success:^(id responseObject) {
               NSLog(@"post OK");
           } failure:^(NSError *error) {
               NSLog(@"post Error");
           }];

        //toAddress
        [self sendCoin : curWallet.walletName
                       : @"galtcoin"            //tokename
                       : toAddress
                       : strNum
                       : @"GALT"];              //token
        
        
    }
//    else if(){//xxl 0.0.5 bindaddress
//
//    }
    
    NSLog(url.scheme);
    
    switch (navigationAction.navigationType) {
        case WKNavigationTypeLinkActivated: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        case WKNavigationTypeFormSubmitted: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        case WKNavigationTypeBackForward: {

            break;
        }
        case WKNavigationTypeReload: {
            break;
        }
        case WKNavigationTypeFormResubmitted: {
            break;
        }
        case WKNavigationTypeOther: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        default: {
            break;
        }
    }
    [self updateNavigationItems];
    decisionHandler(WKNavigationActionPolicyAllow);
}

/// 获取余额
- (NSString *)fetchBalanceWithToken:(NSString *)token {
    NSString *balance = @"";
    SAMWalletInfo *curWallet = [SAMWalletDB fetchCurWallet];
    SAMWalletTokenInfo *walletToken = [SAMWalletDB fetchWalletToken:token fromWallet:curWallet.walletName];
    balance = [NSString stringWithFormat:@"%.3lf", walletToken.balance];
    
    return balance;
}

/// xxl todo now for the moment lock is only HAI
/// 转帐
- (void)sendCoin:(NSString *)walletName :
                 (NSString *)tokenName :
                 (NSString *)address :
                 (NSString *)num :
                 (NSString *)token {
    
    SAMWalletTokenInfo *walletToken = [SAMWalletDB fetchWalletToken:token fromWallet:walletName];
    NSString *pwd = [SAMWalletDB fetchPwd];
    
    NSError *error = nil;
    NSString *ret = MobileSend(tokenName,walletToken.walletID, address, num, pwd, &error);
    NSLog(@"%@", ret);
}

// 创建钱包
- (BOOL)createWalletWithWalletName:(NSString *)walletName
                        walletIcon:(NSString *)walletIcon
                        walletSeed:(NSString *)walletSeed
                             token:(SAMTokenInfo *)token {
    if (walletName.length == 0 || walletIcon.length == 0 || walletSeed.length == 0 || token.tokenName.length == 0) {
        NSLog(@"请求参数不完整！");
        
        return nil;
    }
    BOOL resultFlag = NO;
    NSString *cointType = token.tokenName;
    NSError *error = nil;
    NSString *savedPwd = [SAMWalletDB fetchPwd];
    // 新建钱包
    if (cointType.length > 0 && savedPwd.length > 0) {
        NSString *walletID = MobileNewWallet(cointType, walletName, walletSeed, savedPwd, &error);
        if (walletID.length > 0 && !error) {
            SAMWalletInfo *info = [SAMWalletInfo new];
            info.walletName = walletName;
            info.walletIcon = walletIcon;
            // 添加钱包交易地址
            info.address = [SAMWalletUtil createAddressWithWalletID:walletID];
            // 存储钱包
            if ([SAMWalletDB saveWalletInfo:info]) {
                // 存储钱包token
                SAMWalletTokenInfo *walletToken = [SAMWalletTokenInfo new];
                walletToken.walletID = walletID;
                walletToken.walletName = walletName;
                walletToken.token = token.token;
                if ([SAMWalletDB saveWalletToken:walletToken]) {
                    resultFlag = YES;
                }
                [SAMWalletDB selectWallet:walletName];
                NSLog(@"MobileNewWallet success!");
            }
        } else {
            NSLog(@"MobileNewWallet error: %@", error);
        }
    }
    
    return resultFlag;
}

/// 正常返回
- (void)normalBack {
    if ([self.wkWebView canGoBack]) {
        [self.wkWebView goBack];
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

// 内容加载失败时候调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"页面加载超时");
}

//跳转失败的时候调用
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{}

//进度条
-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{}

#pragma mark ================ WKUIDelegate ================

// 获取js 里面的提示
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

// js 信息的交流
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

// 交互。可输入的文本。
-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"textinput" message:@"JS调用输入框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
    
}

//KVO监听进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        
        // Once complete, fade out UIProgressView
        if(self.wkWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark ================ WKScriptMessageHandler ================

//拦截执行网页中的JS方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    //服务器固定格式写法 window.webkit.messageHandlers.名字.postMessage(内容);
    //客户端写法 message.name isEqualToString:@"名字"]
    if ([message.name isEqualToString:@"WXPay"]) {
        NSLog(@"%@", message.body);
        //调用微信支付方法
        //        [self WXPayWithParam:message.body];
    }
}

#pragma mark ================ 懒加载 ================
- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        //设置网页的配置文件
        WKWebViewConfiguration * Configuration = [[WKWebViewConfiguration alloc]init];
        //允许视频播放
        if (@available(iOS 9.0, *)) {
            Configuration.allowsAirPlayForMediaPlayback = YES;
        } else {
            // Fallback on earlier versions
        }
        // 允许在线播放
        Configuration.allowsInlineMediaPlayback = YES;
        // 允许可以与网页交互，选择视图
        Configuration.selectionGranularity = YES;
        // web内容处理池
        Configuration.processPool = [[WKProcessPool alloc] init];
        //自定义配置,一般用于 js调用oc方法(OC拦截URL中的数据做自定义操作)
        WKUserContentController * UserContentController = [[WKUserContentController alloc]init];
        // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
        [UserContentController addScriptMessageHandler:self name:@"WXPay"];
        // 是否支持记忆读取
        Configuration.suppressesIncrementalRendering = YES;
        // 允许用户更改网页的设置
        Configuration.userContentController = UserContentController;
        
        CGRect rectOfStatusbar = [[UIApplication sharedApplication] statusBarFrame];
        CGRect rectOfNavigationbar = self.navigationController.navigationBar.frame;
        NSInteger headHeight =  rectOfStatusbar.size.height + rectOfNavigationbar.size.height;
        
        //xxl 0.0.4 vote
        NSLog(@"xxl 0.04 %f - %f",self.view.bounds.size.width,self.view.bounds.size.height);
        if(self.view.bounds.size.width > 0){
            
            _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, headHeight,self.view.bounds.size.width,self.view.bounds.size.height-headHeight) configuration:Configuration];
            _wkWebView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
            // 设置代理
            _wkWebView.navigationDelegate = self;
            _wkWebView.UIDelegate = self;
            //kvo 添加进度监控
            [_wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:WkwebBrowserContext];
            //开启手势触摸
            _wkWebView.allowsBackForwardNavigationGestures = YES;
            // 设置 可以前进 和 后退
            //适应你设定的尺寸
            [_wkWebView sizeToFit];
            
        }
        

    }
    return _wkWebView;
}

-(UIButton*)customBackBarBtn{
    if (!_customBackBarBtn) {
    
        _customBackBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(20.f, SAM_STATUSBAR_HEIGHT + (44.f - 22.f) / 2.f, 22.f, 22.f)];
        [_customBackBarBtn setImage:[UIImage imageNamed:@"sam_back_black"] forState:UIControlStateNormal];
        [_customBackBarBtn addTarget:self action:@selector(customBackItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _customBackBarBtn;
}



//-(UIBarButtonItem*)customBackBarItem{
//    if (!_customBackBarItem) {
//        UIImage* backItemImage = [[UIImage imageNamed:@"sam_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        UIImage* backItemHlImage = [[UIImage imageNamed:@"sam_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//
//        UIButton* backButton = [[UIButton alloc] init];
//        [backButton setTitle:@"返回----" forState:UIControlStateNormal];
//        [backButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
//        [backButton setTitleColor:[self.navigationController.navigationBar.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
//        [backButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
//        [backButton setImage:backItemImage forState:UIControlStateNormal];
//        [backButton setImage:backItemHlImage forState:UIControlStateHighlighted];
//        [backButton sizeToFit];
//
//        [backButton addTarget:self action:@selector(customBackItemClicked) forControlEvents:UIControlEventTouchUpInside];
//        _customBackBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//
//        backButton.layer.borderWidth = 1;
//        backButton.layer.borderColor = [UIColor redColor].CGColor;
//
//    }
//    return _customBackBarItem;
//}

- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        if (_isNavHidden == YES) {
            _progressView.frame = CGRectMake(0, 20, self.view.bounds.size.width, 3);
        }else{
            _progressView.frame = CGRectMake(0, 64, self.view.bounds.size.width, 3);
        }
        // 设置进度条的色彩
        [_progressView setTrackTintColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0]];
        _progressView.progressTintColor = [UIColor greenColor];
    }
    return _progressView;
}

-(UIBarButtonItem*)closeButtonItem{
    if (!_closeButtonItem) {
        _closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeItemClicked)];
    }
    return _closeButtonItem;
}

-(NSMutableArray*)snapShotsArray{
    if (!_snapShotsArray) {
        _snapShotsArray = [NSMutableArray array];
    }
    return _snapShotsArray;
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"WXPay"];
    [self.wkWebView setNavigationDelegate:nil];
    [self.wkWebView setUIDelegate:nil];
}

//注意，观察的移除
-(void)dealloc{
    [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}

@end
