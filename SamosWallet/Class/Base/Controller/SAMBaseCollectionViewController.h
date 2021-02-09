//
//  SAMBaseCollectionViewController.h
//  SamosWallet
//
//  Created by zys on 2018/8/18.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 项目里所有collection列表页基类
 */

#import "SAMBaseViewController.h"

@interface SAMBaseCollectionViewController : SAMBaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

/// collectionView
@property (nonatomic, strong, readonly) UICollectionView *collectionView;
/// 是否显示下拉刷新
@property (nonatomic, assign) BOOL showRefreshHeader;
/// 是否显示上拉刷新
@property (nonatomic, assign) BOOL showRefreshFooter;


/**
 注册cell，子类重写
 */
- (void)registerCell;

/**
 下拉刷新 子类重写
 
 @param completion 数据加载完成的回调
 */
- (void)loadNewDataWithCompletionHandler:(SAMVoidBlock)completion;


/**
 上拉加载 子类重写
 
 @param completion 数据加载完成的回调
 */
- (void)loadMoreDataWithCompletionHandler:(void (^)(BOOL hasMoreData))completion;

@end
