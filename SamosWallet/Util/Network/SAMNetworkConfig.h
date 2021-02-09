//
//  SAMNetworkConfig.h
//  XB
//
//  Created by zys on 2018/7/3.
//  Copyright © 2018年 XiaoBu. All rights reserved.
//

/**
 网络配置类：主要处理公共参数、请求头、baseURL等
 */

#import <Foundation/Foundation.h>

@interface SAMNetworkConfig : NSObject

/// 基础urlstr
@property (class, nonatomic, copy, readonly) NSString *baseURLString;
/// 请求超时时间
@property (class, nonatomic, assign) NSTimeInterval timeoutInterval;
/// 请求头
@property (class, nonatomic, strong, readonly) NSDictionary *httpHeaders;
/// 请求支持的序列化格式
@property (class, nonatomic, strong, readonly) NSSet <NSString *> *contentTypes;

@end
