//
//  SAMApi.m
//  XB
//
//  Created by Xiaobu on 2017/2/20.
//  Copyright © 2017年 XiaoBu. All rights reserved.
//

#import "SAMApi.h"
#import "SAMConst.h"

@implementation SAMApi

//xxl test env
//NSString *const SAMApiBaseURLString          = @"http://172.20.10.2:1031/";
//NSString *const SAMApiGetToken               = @"config/galt-token-enc.cfg";
//NSString *const SAMApiGetPrice               = @"api/token-price.php";
//NSString *const SAMApiGetCoinTradeRecordList = @"api/transaction.php";



//xxl real env
//NSString *const SAMApiBaseURLString          = @"http://samos.yqkkn.com/";
NSString *const SAMApiBaseURLString          = @"http://hkappapi.haicshop.com";
NSString *const SAMApiGetToken               = @"config/galt-token-enc.cfg";
NSString *const SAMApiGetPrice               = @"api/token-price";
NSString *const SAMApiGetCoinTradeRecordList = @"api/transaction";

@end
