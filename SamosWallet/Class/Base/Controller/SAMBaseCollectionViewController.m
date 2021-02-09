//
//  SAMBaseCollectionViewController.m
//  SamosWallet
//
//  Created by zys on 2018/8/18.
//  Copyright © 2018年 zys. All rights reserved.
//

#import "SAMBaseCollectionViewController.h"

@interface SAMBaseCollectionViewController ()

/// collectionView
@property (nonatomic, strong) UICollectionView *collectionView;

@end


@implementation SAMBaseCollectionViewController


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - load data
- (void)loadNewDataWithCompletionHandler:(SAMVoidBlock)completion {
    // 子类重写
}

- (void)loadMoreDataWithCompletionHandler:(void (^)(BOOL hasMoreData))completion {
    // 子类重写
}

#pragma mark - UICollectionViewdataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [UICollectionViewCell new];
}

#pragma mark - private methods
- (void)setupVariables {
    [super setupVariables];
}

- (void)setupSubviews {
    [super setupSubviews];
    [self setupCollectionView];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)setupCollectionView {
    [self registerCell];
    [self placeCollectionView];
    [self setupCollectionViewRefresh];
}

- (void)placeCollectionView {
    SAMWeakSelf
    [self.view addSubview:self.collectionView];
    CGFloat top = 0.f;
    if (self.navBGColor == SAMNavigationBarBGColorWhite) {
        top = SAM_NAV_HEIGHT;
    }
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(top);
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(SAM_TABLE_BOTTOM);
    }];
}

- (void)registerCell {
    
}

- (void)setupCollectionViewRefresh {
    SAMWeakSelf
    self.collectionView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewDataWithCompletionHandler:^{
            if ([weakSelf.collectionView.mj_header isRefreshing]) {
                [weakSelf.collectionView.mj_header endRefreshing];
                [weakSelf.collectionView.mj_footer resetNoMoreData];
            }
        }];
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreDataWithCompletionHandler:^(BOOL hasMoreData) {
            if (hasMoreData) {
                [weakSelf.collectionView.mj_footer endRefreshing];
            } else {
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    }];
    
    // 缺省状态下隐藏header和footer
    self.collectionView.mj_header.hidden = YES;
    self.collectionView.mj_footer.hidden = YES;
}

#pragma mark - Setters / Getters
- (void)setShowRefreshHeader:(BOOL)showRefreshHeader {
    _showRefreshHeader = showRefreshHeader;
    self.collectionView.mj_header.hidden = !showRefreshHeader;
}

- (void)setShowRefreshFooter:(BOOL)showRefreshFooter {
    _showRefreshFooter = showRefreshFooter;
    self.collectionView.mj_footer.hidden = !showRefreshFooter;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        [self.view addSubview:_collectionView];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

@end
