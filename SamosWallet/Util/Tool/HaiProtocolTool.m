//
//  HaiProtocol.m
//  SamosWallet
//
//  Created by xu xinlai on 2019/11/3.
//  Copyright © 2019年 Samos. All rights reserved.
//

#import "HaiProtocolTool.h"
#import "NSString+encryptionMD5.h"

@implementation HaiProtocolTool;

#pragma mark - public methods
#pragma mark instance methods


//xxl 0.0.1 for haichain protocal
+ (void)dealWithUrl:(NSURL *)url{
    
    //获得其他参数
    NSDictionary *params = [SAMWalletUtil getUrlParameterWithUrl:url];
    if([url.host isEqualToString:@"pay"]){
        
        [HaiProtocolTool bIsFromMoble:true];
        [HaiProtocolTool strCallURL:[url absoluteString]];
        
        NSString *    tokenName = params[HAI_PARAM_COIN_NAME];
        if([tokenName isEqualToString:@"HAIC"]){
            tokenName = @"HAI";
        }
        //xxl 0.0.1
        [HaiProtocolTool strCallBackURL:params[HAI_PARAM_CALLBACK_URL]];
        [HaiProtocolTool strOutTradeNo:params[HAI_PARAM_OUT_TRADE_NO]];
        
        NSString *scheme = [NSString stringWithFormat:@"samos://pay?address=%@&amount=%@&token=%@",
                            params[HAI_PARAM_RECEIVING_ADDRESS],
                            params[HAI_PARAM_AMOUNT],
                            tokenName];
        
        [SAMControllerTool chooseVCWithScheme:scheme];
    //xxl 0.0.4 vote
    }else if([url.host isEqualToString:@"vote"]){
        
        
    }else{
        //xxl 0.0.5 vote TODO only one page
        //add address
        SAMWalletInfo *wallet = [SAMWalletDB fetchCurWallet];
        
        SAMWalletTokenInfo *walletToken = [SAMWalletDB fetchWalletToken:@"HAI" fromWallet:wallet.walletName];
        NSString* hai_balance = [NSString stringWithFormat:@"%.3lf", walletToken.balance];
        
        walletToken = [SAMWalletDB fetchWalletToken:@"GALT" fromWallet:wallet.walletName];
        NSString* galt_balance = [NSString stringWithFormat:@"%.3lf", walletToken.balance];
        
        NSMutableString *sign = [NSString stringMD5Lower:@"6aQq4Bmxw0gV05cm359N"];
        
        NSString *toURL = [
                           NSString stringWithFormat:@"%@?address=%@&hai_balance=%@&galt_balance=%@&sign=%@",
                               [url absoluteString],
                               wallet.address,
                               hai_balance,
                               galt_balance,
                               sign
                           ];
        
        toURL = [toURL URLEncodedString];
        NSString *scheme = [NSString stringWithFormat:@"samwallet://hai_explorer?url=%@",toURL];
        //[SAMControllerTool chooseVCWithScheme:toURL];
        [SAMControllerTool chooseVCWithScheme:scheme];
        
        //Send Galt
        
    }

}


/**
 json字符转json格式数据 .
 */
+(id)jsonWithString:(NSString*)jsonString {
    NSAssert(jsonString,@"数据不能为空!");
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                             options:NSJSONReadingMutableContainers
                                               error:&err];
    
    NSAssert(!err,@"json解析失败");
    return dic;
}


//xxl 0.0.1 for haichain protocal
+ (void)httpGetWithUrl:(NSString *)strUrl{
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [urlRequest setHTTPMethod:@"GET"];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",returnString);
}


+(void)clearCallURLInfo {
    strURL = @"";
    strCallURL = @"";
    strOutTradeNo = @"";
}


//xxl 0.0.1 for haichain protocal
static NSString* strURL;
static NSString* strCallURL;
static NSString* strOutTradeNo;
static BOOL isFromMobile;


+(void)strCallURL:(NSString *) strURL {
    
    if (strURL != nil) {
        strCallURL = strURL;
    }
}

+(NSString *)getCallURL {
    if(strCallURL == nil){
        strCallURL = @"";
    }
    
    return strCallURL;
}

+(void)strCallBackURL:(NSString *) str {
    
    if (str != nil) {
        strURL = str;
    }
}

+(NSString *)getCallBackURL {
    return strURL;
}

+(void)strOutTradeNo:(NSString *) str {
    
    if (str != nil) {
        strOutTradeNo = str;
    }
}

+(NSString *)getOutTradeNo {
    return strOutTradeNo;
}

+(void)bIsFromMoble:(BOOL) bFlag {

   isFromMobile = bFlag;
}

+(BOOL)getIsFromMoble {
    return isFromMobile;
}


@end
