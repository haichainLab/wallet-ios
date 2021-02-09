//
//  SAMNetworkConfig.m
//  XB
//
//  Created by zys on 2018/7/3.
//  Copyright © 2018年 XiaoBu. All rights reserved.
//

#import "SAMNetworkConfig.h"
#import "SAMAppConfig.h"
#import "SAMApi.h"

/// 服务器地址
static NSString *_baseURLString = nil;
/// 请求头
static NSDictionary *_httpHeaders = nil;
/// 超时时间
static NSTimeInterval _timeoutInterval = 10.f;
/// 支持的序列化格式
static NSSet <NSString *> *_contentTypes = nil;


@interface SAMNetworkConfig ()

@end


@implementation SAMNetworkConfig

#pragma mark - public methods

#pragma mark - setters
+ (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
    if (timeoutInterval > 0.f) {
        _timeoutInterval = timeoutInterval;
    }
}

#pragma mark - getters
+ (NSString *)baseURLString {
    if (!_baseURLString) {
        _baseURLString = SAMApiBaseURLString;
    }
    
    return _baseURLString;
}

+ (NSTimeInterval)timeoutInterval {
    if (_timeoutInterval <= 0.f) {
        _timeoutInterval = 10.f;
    }
    
    return _timeoutInterval;
}

+ (NSDictionary *)httpHeaders {
    if (!_httpHeaders) {
        _httpHeaders = [NSDictionary new];
    }
    
    return _httpHeaders;
}

+ (NSSet <NSString *> *)contentTypes {
    if (!_contentTypes) {
        _contentTypes = [NSSet setWithArray:@[@"application/json",
                                              @"text/html",
                                              @"text/json",
                                              @"text/plain",
                                              @"text/javascript",
                                              @"text/xml",
                                              @"image/*",
                                              @"application/octet-stream",
                                              @"application/zip"]];
    }
    
    return _contentTypes;
}

@end
