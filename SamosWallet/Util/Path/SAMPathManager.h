//
//  SAMPathManager.h
//  SAM
//
//  Created by zys on 2017/7/25.
//  Copyright © 2017年 Xiaobu. All rights reserved.
//

/**
 文件目录管理类
 */

#import <Foundation/Foundation.h>

@interface SAMPathManager : NSObject

#pragma mark - 获取沙盒目录
/// get documents directory
+ (NSString *)docPath;
/// get temp directory
+ (NSString *)tempPath;
/// cache path
+ (NSString *)cachePath;
/// lib path
+ (NSString *)libraryPath;

#pragma mark - 创建、删除目录，获取目录大小
/// create directory
+ (BOOL)createDirectory:(NSString *)directory;
/// remove directory
+ (BOOL)removeDirectory:(NSString *)directory;
/// get file or directory's size(unit: B)
+ (unsigned long long)sizeAtPath:(NSString *)path;

#pragma mark - 创建、删除文件
/// create file at path
+ (BOOL)createFileAtPath:(NSString *)path;
/// delete file at path
+ (BOOL)deleteFileAtPath:(NSString *)path;
/// delete file at path
+ (BOOL)deleteFileByURL:(NSURL *)url;

#pragma mark - 钱包目录
+ (NSString *)walletDirectory;

@end
