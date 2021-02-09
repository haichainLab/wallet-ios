//
//  NSString+SAMAddtion.h
//  SamosWallet
//
//  Created by zys on 2018/10/14.
//  Copyright © 2018 zys. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SAMAddtion)

/**
 去除首尾的空格和回车
 
 @return 处理后的字符串
 */
- (NSString *)trime;


/**
 对url进行enCode
 
 @return enCode后的字符串
 */
- (NSString *)enCode;

/**
 对url进行deCode
 
 @return deCode后的字符串
 */
- (NSString *)deCode;

// 3DES加密
- (NSString*)encrypt3DES;
// 3DES解密
- (NSString*)decrypt3DES;

/**
 *  URLEncode
 */
- (NSString *)URLEncodedString;

/**
 *  URLDecode
 */
-(NSString *)URLDecodedString;

@end

NS_ASSUME_NONNULL_END
