//
//  SAMTokenNode.h
//  SamosWallet
//
//  Created by zys on 2018/8/19.
//  Copyright © 2018年 zys. All rights reserved.
//

/**
 Token节点数据
 */

#import <Foundation/Foundation.h>

/// token节点
@interface SAMTokenNode : NSObject

/// token array
@property (nonatomic, strong) NSArray *tokens;
/// web url
@property (nonatomic, copy) NSString *weburl;
/// 默认的Token，比如SAMO
@property (nonatomic, copy) NSString *defaultToken;
/// 配置的版本号
@property (nonatomic, copy) NSString *version;

@end
