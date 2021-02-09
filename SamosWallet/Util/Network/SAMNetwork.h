//
//  SAMNetwork.h
//  XB
//
//  Created by zys on 2018/7/3.
//  Copyright © 2018年 XiaoBu. All rights reserved.
//

/**
 网络请求管理类：此类中一律提供类方法供调用
 */

#import <Foundation/Foundation.h>

@interface SAMNetwork : NSObject

/// GET请求
+ (void)GETWithURLStr:(NSString *)URLString
           parameters:(id)parameters
              success:(void (^)(id responseObject))successBlock
              failure:(void (^)(NSError *error))failBlock;
/// POST请求
+ (void)POSTWithURLStr:(NSString *)URLString
            parameters:(id)parameters
               success:(void (^)(id responseObject))successBlock
               failure:(void (^)(NSError *error))failBlock;

@end
