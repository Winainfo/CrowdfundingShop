//
//  UIViewController+WeChatAndAliPayMethod.m
//  WeChatAndAliPayDemo
//
//  Created by 李政 on 15/10/21.
//  Copyright © 2015年 Leon李政. All rights reserved.
//

#import "UIViewController+WeChatAndAliPayMethod.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"

@implementation UIViewController (WeChatAndAliPayMethod)

- (void)payTheMoneyUseWeChatPayWithPrepay_id:(NSString *)prepay_id nonce_str:(NSString *)nonce_str
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSLog(@"%@",str);
    //调起微信支付···
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = MCH_ID;
    req.prepayId            = [NSString stringWithFormat:@"%@",prepay_id];
    req.nonceStr            = [NSString stringWithFormat:@"%@",nonce_str];
    req.timeStamp           = [str intValue];
    req.package             = @"Sign=WXpay";
    //创建支付签名对象
    payRequsestHandler *req1 =[[payRequsestHandler alloc] init];
    //初始化支付签名对象
    [req1 init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req1 setKey:PARTNER_ID];
    //第二次签名参数列表
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject: APP_ID        forKey:@"appid"];
    [signParams setObject: [NSString stringWithFormat:@"%@",nonce_str]   forKey:@"noncestr"];
    [signParams setObject: @"Sign=WXpay"      forKey:@"package"];
    [signParams setObject: MCH_ID        forKey:@"partnerid"];
    [signParams setObject: [NSString stringWithFormat:@"%d",str.intValue]   forKey:@"timestamp"];
    [signParams setObject: [NSString stringWithFormat:@"%@",prepay_id]     forKey:@"prepayid"];
    //生成签名
    NSString *signStr  = [req1 createMd5Sign:signParams];
    NSLog(@"%@",signStr);
    req.sign                =signStr;
    NSLog(@"%@",req);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:@"weixin_pay_result" object:nil];
    [WXApi sendReq:req];
}

//微信付款成功失败
-(void)noti:(NSNotification *)noti{
    NSLog(@"%@",noti);
    if ([[noti object] isEqualToString:@"成功"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:WX_PAY_RESULT object:IS_SUCCESSED];

    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:WX_PAY_RESULT object:IS_FAILED];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"weixin_pay_result" object:nil];
}


//===========================分割线==========================================================

//支付宝支付
-(void)payTHeMoneyUseAliPayWithOrderId:(NSString *)orderId totalMoney:(NSString *)totalMoney payTitle:(NSString *)payTitle
{
    NSMutableString *orderString = [NSMutableString string];
    [orderString appendFormat:@"service=\"%@\"", @"mobile.securitypay.pay"]; //
    [orderString appendFormat:@"&partner=\"%@\"", AliPartnerID];          //
    [orderString appendFormat:@"&_input_charset=\"%@\"", @"utf-8"];    //
    
    [orderString appendFormat:@"&notify_url=\"%@\"", AliNotifyURL];       //
    [orderString appendFormat:@"&out_trade_no=\"%@\"", orderId];   //
    [orderString appendFormat:@"&subject=\"%@\"", payTitle];        //
    [orderString appendFormat:@"&payment_type=\"%@\"", @"1"];          //
    [orderString appendFormat:@"&seller_id=\"%@\"", AliSellerID];         //
    [orderString appendFormat:@"&total_fee=\"%@\"", totalMoney];         //
    [orderString appendFormat:@"&body=\"%@\"", payTitle];              //
    [orderString appendFormat:@"&showUrl =\"%@\"", @"m.alipay.com"];
    
    
    id<DataSigner> signer = CreateRSADataSigner(AliPartnerPrivKey);
    NSString *signedString = [signer signString:orderString];
    
    [orderString appendFormat:@"&sign=\"%@\"", signedString];
    [orderString appendFormat:@"&sign_type=\"%@\"", @"RSA"];
    
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:kAliPayURLScheme callback:^(NSDictionary *resultDic)
     {
         NSLog(@"reslut = %@",resultDic);
         if ([[resultDic objectForKey:@"resultStatus"] isEqual:@"9000"]) {
             //支付成功
             [[NSNotificationCenter defaultCenter] postNotificationName:ALI_PAY_RESULT object:ALIPAY_SUCCESSED];
             
         }else{
             [[NSNotificationCenter defaultCenter] postNotificationName:ALI_PAY_RESULT object:ALIPAY_FAILED];
         }
     }];

}
@end
