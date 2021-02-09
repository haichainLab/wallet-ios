//
//  NSString+encryptionMD5.m
//  SamosWallet
//
//  Created by xu xinlai on 2019/12/30.
//  Copyright © 2019年 Samos. All rights reserved.
//

#import "NSString+encryptionMD5.h"
#import <CommonCrypto/CommonCrypto.h>


@implementation NSString (encryptionMD5)
+(NSMutableString *)stringMD5:(NSString *)string
{
    const char *data = [string UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(data, (CC_LONG)strlen(data), result);
    NSMutableString *mString = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        //02:不足两位前面补0,   %02x:十六进制数
        [mString appendFormat:@"%02X",result[i]];
    }
    
    return mString;
}

+(NSMutableString *)stringMD5Lower:(NSString *)string
{
    const char *data = [string UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(data, (CC_LONG)strlen(data), result);
    NSMutableString *mString = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        //02:不足两位前面补0,   %02x:十六进制数
        [mString appendFormat:@"%02x",result[i]];
    }
    
    return mString;
}

@end

