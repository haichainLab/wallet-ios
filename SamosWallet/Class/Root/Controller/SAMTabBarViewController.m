//
//  SAMTabBarViewController.m
//  SamosWallet
//
//  Created by zys on 2018/8/18.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMTabBarViewController.h"
#import "SAMNetwork.h"
#import "SAMApi.h"
#import "SAMHomeSideController.h"
#import "SAMMeController.h"
#import "SAMUIWebViewController.h"

@interface SAMTabBarViewController ()

/// 首页钱包页
@property (nonatomic, strong) SAMHomeSideController *homeSideVC;
/// 中间活动页
@property (nonatomic, strong) SAMUIWebViewController *webVC;
/// 个人中心页
@property (nonatomic, strong) SAMMeController *meVC;
/// 钱包数据
@property (nonatomic, strong) NSArray *wallets;
/// 当前钱包
@property (nonatomic, strong) SAMWalletInfo *curWallet;

@end


@implementation SAMTabBarViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSubviews];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self removeObservers];
}

#pragma mark - load data
- (void)loadData {
    // 获取钱包
    self.wallets = [SAMWalletDB fetchAllWallets];
    self.curWallet = [SAMWalletDB fetchCurWallet];
    [self updateUI];
}

#pragma mark - private methods
- (void)setupSubviews {
    [self setupChildVC];
    [self addObservers];
}

/// 设置child vc
- (void)setupChildVC {
    SAMNavigationController *homeNav = [[SAMNavigationController alloc] initWithRootViewController:self.homeSideVC];
    [self addChildVC:homeNav title:nil imageName:@"sam_tab_icon_wallet_normal" selectImageName:@"sam_tab_icon_wallet_checked"];
    //SAMNavigationController *webNav = [[SAMNavigationController alloc] initWithRootViewController:self.webVC];
    //[self addChildVC:webNav title:nil imageName:@"sam_tab_icon_find_normal" selectImageName:@"sam_tab_icon_find_checked"];
    SAMNavigationController *meNav = [[SAMNavigationController alloc] initWithRootViewController:self.meVC];
    [self addChildVC:meNav title:nil imageName:@"sam_tab_icon_me_normal" selectImageName:@"sam_tab_icon_me_checked"];
}

/// 设置图片位置
- (void)setupIconsWithItem:(UITabBarItem *)item {
    item.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
}

/// 添加一个vc
- (void)addChildVC:(UIViewController *)vc
             title:(NSString *)title
         imageName:(NSString *)imageName
   selectImageName:(NSString *)selectImageName {
    if (vc) {
        vc.tabBarItem.title = title ? title : @"";
        vc.tabBarItem.image = imageName ? [UIImage imageNamed:imageName] : [UIImage new];
        vc.tabBarItem.selectedImage = selectImageName ? [UIImage imageNamed:selectImageName] : [UIImage new];
        [self addChildViewController:vc];
        [self setupIconsWithItem:vc.tabBarItem];
    }
}

/// 更新页面
- (void)updateUI {
    self.homeSideVC.wallets = self.wallets;
    self.homeSideVC.curWallet = self.curWallet;
}

#pragma mark - KVO
- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:SAMNotificationRefreshTabBarHome object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SAMNotificationRefreshTabBarHome object:nil];
}

#pragma mark - getters
- (SAMHomeSideController *)homeSideVC {
    if (!_homeSideVC) {
        _homeSideVC = [SAMHomeSideController new];
        SAMWeakSelf
        _homeSideVC.selectWalletBlock = ^{
            [weakSelf loadData];
        };
    }
    
    return _homeSideVC;
}

- (SAMUIWebViewController *)webVC {
    if (!_webVC) {
        _webVC = [SAMUIWebViewController new];
    }
    
    return _webVC;
}

- (SAMMeController *)meVC {
    if (!_meVC) {
        _meVC = [SAMMeController new];
    }
    
    return _meVC;
}

@end
