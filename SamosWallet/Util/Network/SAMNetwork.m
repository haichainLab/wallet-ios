//
//  XBNetwork.m
//  XB
//
//  Created by zys on 2018/7/3.
//  Copyright © 2018年 XiaoBu. All rights reserved.
//

#import "AFNetworking.h"
#import "SAMNetwork.h"
#import "SAMNetworkConfig.h"

@implementation SAMNetwork

#pragma mark - public methods
/// GET请求
+ (void)GETWithURLStr:(NSString *)URLString
           parameters:(id)parameters
              success:(void (^)(id responseObject))successBlock
              failure:(void (^)(NSError *error))failBlock {
    AFHTTPSessionManager *manager = [self manager];
    if (![URLString hasPrefix:@"http"]) {
        // 拼接完整的URL
        URLString = [SAMNetworkConfig.baseURLString stringByAppendingPathComponent:URLString];
    }
    NSLog(@"===URL: %@", URLString);
    NSLog(@"===Param: %@", parameters);
    [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failBlock) {
            failBlock(error);
        }
    }];
}

+ (void)POSTWithURLStr:(NSString *)URLString
            parameters:(id)parameters
               success:(void (^)(id responseObject))successBlock
               failure:(void (^)(NSError *error))failBlock {
    AFHTTPSessionManager *manager = [self manager];
    if (![URLString hasPrefix:@"http"]) {
        // 拼接完整的URL
        URLString = [SAMNetworkConfig.baseURLString stringByAppendingPathComponent:URLString];
    }
    NSLog(@"===URL: %@", URLString);
    NSLog(@"===Param: %@", parameters);
    [manager POST:URLString
       parameters:parameters
         progress:^(NSProgress * _Nonnull uploadProgress) {}
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if (successBlock) {
                  successBlock(responseObject);
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              if (failBlock) {
                  failBlock(error);
              }
          }];
}

#pragma mark - private methods
/**
 创建AFHTTPSessionManager实例
 
 @return AFHTTPSessionManager实例
 */
+ (AFHTTPSessionManager *)manager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    // 默认解析模式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 配置请求序列化
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    serializer.removesKeysWithNullValues = YES;
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.requestSerializer.timeoutInterval = SAMNetworkConfig.timeoutInterval;
    // 配置响应序列化
    manager.responseSerializer.acceptableContentTypes = SAMNetworkConfig.contentTypes;
    
    return manager;
}

@end
