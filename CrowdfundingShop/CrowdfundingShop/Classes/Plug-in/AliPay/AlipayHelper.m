//
//  AlipayHelper.m
//  Alipay
//
//  Created by 换一换 on 16/1/7.
//  Copyright © 2016年 张洋. All rights reserved.
//

#import "AlipayHelper.h"

#import "Order.h"
#import "DataSigner.h"
#define KPingPPURLScheme @"wxadc696ab9cca2ed7"
#import <AlipaySDK/AlipaySDK.h>
@interface AlipayHelper()
{
    int _price; //支付金额
    alipayBlock _success; //支付成功回调
    alipayBlock _failure; //失败回调
    
    //三个由公司提供
    NSString *_partnerId; //商户id
    NSString *_seller;    //商户账号
    NSString *_privateKey; //商户私钥
    
}
@end
@implementation AlipayHelper

-(instancetype)init
{
    self = [super init];
    if (self) {
        //从plist文件里面获取账户信息
        NSDictionary *alipayDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AlipayHelper.plist" ofType:nil]];
        
        _partnerId = alipayDic[@"partnerId"];
        _seller = alipayDic[@"seller"];
        _privateKey = alipayDic[@"privateKey"];
    
    }
    return self;
}

/**
 *  发起支付请求
 *
 *  @param dict     存放支付信息
 *  @param success  成功
 *  @param failure  失败
 *  @param ispaying 正在支付
 */


-(void) orderDetialInfo:(NSDictionary *) dict Success:(alipayBlock)success Failure:(alipayBlock)failure Ispaying:(alipayBlock)ispaying

{
    //partner和seller获取失败,提示
    if ([_partnerId length] == 0 || [_seller length] == 0 || [_privateKey length] == 0)
    {
        NSLog(@"缺少partner或者seller或者私钥,请在Alipay.plist中填写你们公司申请的partner和seller");
        return;
    }
    
    //初始化请求参数
    Order *order = [[Order alloc] init];
    
    order.partner = _partnerId;
    order.seller = _seller;
    
    order.service = @"mobile.securitypay.pay"; //支付宝服务器
    order.paymentType = @"1"; //付款类型
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com"; //支付宝scheme标识
    
    //自己生成
    
    
    order.tradeNO = [dict valueForKey:@"tradeNO"];
    order.productName = [dict valueForKey:@"productName"]; //商品标题
    order.productDescription = [dict valueForKey:@"productDescription"];//商品描述
    order.amount = [dict valueForKey:@"amount"];//商品价格
    
    //应用注册scheme,在info.plist定义url type
        NSString *appScheme = @"AliPayShop";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
   //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner>singer = CreateRSADataSigner(_privateKey);
    NSString *signStr = [singer signString:orderSpec];
    //将签名成功字符串格式化为订单字符串,请严格按照该格式 426386
    NSString *orderString = nil;
    if (signStr != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signStr, @"RSA"];
    }
    //发起支付
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        if ([[resultDic objectForKey:@"resultStatus"]intValue] == 9000) {
            success();
        }
        else if ([[resultDic objectForKey:@"resultStatus"]intValue] == 8000)
        {
            ispaying();
        }
        else
        {
            failure();
        }

        
    }];
}


+(void)orderDetialInfo:(NSDictionary *) dict Success:(alipayBlock)success Failure:(alipayBlock)failure Ispaying:(alipayBlock)ispaying
{
    AlipayHelper *helper = [[AlipayHelper alloc] init];
    [helper orderDetialInfo:dict Success:success Failure:failure Ispaying:ispaying];
}
@end
