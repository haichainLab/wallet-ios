//
//  NSString+encryptionMD5.h
//  SamosWallet
//
//  Created by xu xinlai on 2019/12/30.
//  Copyright © 2019年 Samos. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSString (encryptionMD5)
//外部调用,用于字符串加密
+(NSMutableString *)stringMD5:(NSString *)string;
+(NSMutableString *)stringMD5Lower:(NSString *)string;

@end
