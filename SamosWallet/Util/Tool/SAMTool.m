//
//  SAMTool.m
//  SamosWallet
//
//  Created by zys on 2018/12/1.
//  Copyright © 2018 zys. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SAMTool.h"

@implementation SAMTool

#pragma mark - public methods
#pragma mark instance methods
- (void)savePhotoToAlbum:(UIImage *)image
              completion:(SAMVoidBlock)completion {
    self.savePhotoCompleteBlock = completion;
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *) error contextInfo:(void *) contextInfo {
    if (self.savePhotoCompleteBlock) {
        self.savePhotoCompleteBlock();
    }
    if(!error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:SAM_LOCALIZED(@"language_save_success")];
        });
    } else {
        // 相册权限
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == kCLAuthorizationStatusNotDetermined
            || author == kCLAuthorizationStatusRestricted
            || author == kCLAuthorizationStatusDenied) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:SAM_LOCALIZED(@"language_album") message:SAM_LOCALIZED(@"language_album_desc") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:SAM_LOCALIZED(@"language_cancel") style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:SAM_LOCALIZED(@"language_ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                // 无权限，引导去开启
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if (url) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication] openURL:url];
                    });
                }
            }];
            [alert addAction:cancelAction];
            [alert addAction:confirmAction];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SAMControllerTool currentVC] presentViewController:alert animated:YES completion:nil];
            });
        }
    }
}


#pragma mark - class methos
+ (NSString *)formatTimeStamp:(NSInteger)timeStamp {
    NSString *resultStr = @"";
    if (timeStamp > 0) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
        NSDateFormatter *fmt = [NSDateFormatter new];
        fmt.dateFormat = @"yyyy-MM-dd hh:mm:ss";
        resultStr = [fmt stringFromDate:date];
    }
    
    return resultStr;
}

+ (UIImage *)genQRCodeWithString:(NSString *)qrStr {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    [filter setValue:[qrStr dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *ciImage = [filter outputImage];
    UIImage *outputImage = [SAMTool excludeFuzzyImageFromCIImage:ciImage size:200.f];
    
    return outputImage;
}

+ (void)copyToPasteboadrd:(NSString *)text {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = text;
}

#pragma mark - private methods
+ (UIImage *)excludeFuzzyImageFromCIImage:(CIImage *)image size:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    // 通过比例计算，让最终的图像大小合理（正方形是我们想要的）
    CGFloat scale = MIN(size / CGRectGetWidth(extent), size / CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext * context = [CIContext contextWithOptions: nil];
    CGImageRef bitmapImage = [context createCGImage: image fromRect: extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // 切记ARC模式下是不会对CoreFoundation框架的对象进行自动释放的，所以要我们手动释放
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGColorSpaceRelease(colorSpace);
    UIImage *resultImage = [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);
    
    return resultImage;
}

@end
