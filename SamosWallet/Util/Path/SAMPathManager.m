//
//  SAMPathManager.m
//  XB
//
//  Created by zys on 2017/7/25.
//  Copyright © 2017年 Xiaobu. All rights reserved.
//

#import "SAMPathManager.h"

@implementation SAMPathManager

/// 钱包目录名
#define kWalletDirectoryName @"sam_wallet_directory"

#pragma mark - 获取沙盒目录
+ (NSString *)docPath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    return path;
}

+ (NSString *)tempPath {
    NSString *path = NSTemporaryDirectory();
    
    return path;
}

+ (NSString *)cachePath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    
    return path;
}

+ (NSString *)libraryPath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
    
    return path;
}

#pragma mark - 创建、删除目录，获取目录大小
+ (BOOL)createDirectory:(NSString *)directory {
    NSFileManager *fm = [NSFileManager defaultManager];
    // if directory not exist, then create
    if (![fm fileExistsAtPath:directory]) {
        return [fm createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return YES;
}

+ (BOOL)removeDirectory:(NSString *)directory {
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:directory]) {
        return [fm removeItemAtPath:directory error:nil];
    }
    return YES;
}

+ (unsigned long long)sizeAtPath:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = YES;
    if (![fm fileExistsAtPath:path isDirectory:&isDir]) {
        return 0;
    };
    unsigned long long fileSize = 0;
    // directory
    if (isDir) {
        NSDirectoryEnumerator *enumerator = [fm enumeratorAtPath:path];
        while (enumerator.nextObject) {
            fileSize += enumerator.fileAttributes.fileSize;
        }
    } else {
        // file
        fileSize = [fm attributesOfItemAtPath:path error:nil].fileSize;
    }
    return fileSize;
}

#pragma mark - 创建、删除文件
+ (BOOL)createFileAtPath:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path] == NO) {
        return [fm createFileAtPath:path contents:nil attributes:nil];
    }
    
    return YES;
}

+ (BOOL)deleteFileAtPath:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        return [fm removeItemAtPath:path error:nil];
    }
    
    return YES;
}

+ (BOOL)deleteFileByURL:(NSURL *)url {
    if (url) {
        NSFileManager *fm = [NSFileManager defaultManager];
        return [fm removeItemAtURL:url error:nil];
    }
    return YES;
}

#pragma mark - 钱包目录
+ (NSString *)walletDirectory {
    NSString *path = [[self docPath] stringByAppendingPathComponent:kWalletDirectoryName];
    [self createDirectory:path];
    
    return path;
}

@end
