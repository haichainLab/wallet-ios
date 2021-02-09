//
//  SAMHomeSideController.m
//  SamosWallet
//
//  Created by zys on 2018/8/20.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMHomeSideController.h"
#import "SAMHomeWalletController.h"
#import "SAMHomeMenuController.h"

@interface SAMHomeSideController ()

/// 首页vc
@property (nonatomic, strong) SAMHomeWalletController *homeVC;
/// 菜单vc
@property (nonatomic, strong) SAMHomeMenuController *menuVC;

@end

@implementation SAMHomeSideController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (void)setupVC {
    self.rootViewController = self.homeVC;
    self.leftViewController = self.menuVC;
    self.leftViewWidth = SAM_SCREEN_WIDTH * 3.f / 4.f;
}

#pragma mark - getters
- (SAMHomeWalletController *)homeVC {
    
   
    if (!_homeVC) {
        _homeVC = [SAMHomeWalletController new];
        SAMWeakSelf
        _homeVC.menuClickBlock = ^{
            //xxl 0.0.2 add for lock wallet
            weakSelf.wallets = [SAMWalletDB fetchAllWallets];
            [weakSelf.leftViewController viewDidLoad];
            [weakSelf showLeftViewAnimated];
        };
    }
    
    return _homeVC;
}

- (SAMHomeMenuController *)menuVC {
    if (!_menuVC) {
        _menuVC = [SAMHomeMenuController new];
        SAMWeakSelf
        _menuVC.selectWalletBlock = ^{
            if (weakSelf.selectWalletBlock) {
                weakSelf.selectWalletBlock();
            }
            [weakSelf hideLeftViewAnimated];
        };
    }
    
    return _menuVC;
}

#pragma mark - setters
- (void)setWallets:(NSArray *)wallets {
    if (wallets.count > 0) {
        _wallets = wallets;
        self.menuVC.wallets = wallets;
    }
}

- (void)setCurWallet:(SAMWalletInfo *)curWallet {
    if (curWallet) {
        self.homeVC.curWallet = curWallet;
    }
}

@end
