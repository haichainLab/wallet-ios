//
//  SAMTool.h
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

/**
 工具类方法
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SAMTool : NSObject

/// 保存图片成功回调
@property (nonatomic, copy) SAMVoidBlock savePhotoCompleteBlock;

/// 保存图片
- (void)savePhotoToAlbum:(UIImage *)image
              completion:(SAMVoidBlock)completion;
/// 时间戳转换 yyyy-MM-dd HH:mm:dd
+ (NSString *)formatTimeStamp:(NSInteger)timeStamp;
/// 生成二维码
+ (UIImage *)genQRCodeWithString:(NSString *)qrStr;
/// 复制到剪切板
+ (void)copyToPasteboadrd:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
