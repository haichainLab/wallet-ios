//
//  HaiProtocol.h
//  SamosWallet
//
//  Created by xu xinlai on 2019/11/3.
//  Copyright © 2019年 Hai. All rights reserved.
//

/**
 工具类方法
 */

//xxl 0.0.0
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HaiProtocolTool : NSObject


+ (void)dealWithUrl:(NSURL *)url;
+ (void)httpGetWithUrl:(NSString *)strUrl;
/**
 json字符转json格式数据 .
 */
+(id _Nonnull)jsonWithString:(NSString* _Nonnull)jsonString;

+(void)clearCallURLInfo;
+(void)strCallBackURL:(NSString *) str;
+(void)strOutTradeNo:(NSString *) str;
+(void)strCallURL:(NSString *) strURL;
+(void)bIsFromMoble:(BOOL ) isFromMoble;


/**
 获取网络状态
 
 @return 返回回调URL
 */
+(NSString *)getCallBackURL;
+(NSString *)getOutTradeNo;
+(NSString *)getCallURL;

+(BOOL)getIsFromMoble;

@end

NS_ASSUME_NONNULL_END
