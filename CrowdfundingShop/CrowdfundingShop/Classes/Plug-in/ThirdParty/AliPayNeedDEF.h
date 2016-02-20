//
//  AliPayNeedDEF.h
//  WeChatAndAliPayDemo
//
//  Created by 李政 on 15/10/21.
//  Copyright © 2015年 Leon李政. All rights reserved.
//

#ifndef AliPayNeedDEF_h
#define AliPayNeedDEF_h

#import <AlipaySDK/AlipaySDK.h>
////合作身份者id，以2088开头的16位纯数字（客户给）
//#define AliPartnerID @"合作者身份id"
//
////收款支付宝账号
//#define AliSellerID  @"这里一般填写客户的企业级支付宝收款账号"

//合作身份者id，以2088开头的16位纯数字（客户给）
#define AliPartnerID @"2088711955534853"

//收款支付宝账号
#define AliSellerID  @"1144775900@qq.com"

//商户私钥，自助生成（这个私钥需要自己手动生成，具体生成方法可以看支付宝的官方文档，下面给出大体格式）
#define AliPartnerPrivKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAKOgg5L/hVBxXcjNMXg0OodQxvEWAUtQs0vo7KmD43r6sQVTyhvwiQuJABzj3c9mV1LF+cHE7FL3hwoI/+DGoGWkUC/L+kSCq1h9CCHd1cUcJTs5s5p6yi+WmYLUDlom2T9mJXGSl+ycNf4SdElBx6upmicD0DFxET3E9yVBapcJAgMBAAECgYBLnYvwTKEBEcKzXw/zar95dPzawL6MXZjeBaAInmhrlppjydrmmnvals80iqEgjTzhhZfr0eMcXENNgectqtzIHraSwd01Y9uMwcRtI/X0G+KvnY5QcrQoQt1toTYElL3L+Siq9Ragv6lZFdum9EZKj6XIJssmUsaru6gB/kqWGQJBANFSCWqR6Cb2ce6DpgHLuK9DgxLTGMF7N9zTDXRhkSIt31FnInxzsWshePgyEjXNnWac2Xti0Nk1YCyOZ1/1Tr8CQQDIHd5+nuMnV6UJaRbYjCcWLv+kp41UT1TZdXFyPXstzB1/xEaNID4uedQKg235LyptQBTPYrNUUB7UtpgyIFQ3AkEAhoz0TpOxpfH+tHHdcQQSGF8OTzhwjlZ1RzZHTMs2rsDL7xibm2IG5rVifDA7cmhUSFSEnAKd+zGLO7jiDFW0IwJAEENNJ6El+LaItQETWDnbm1PqdqkfNTDVRm7i71PLxOcHprB+w01RgFlqQAh6UXvhyMsiZdAxnrJ8LvE/4SL7dQJAcGqoj/F27L9gR89a8msswphyUcBoY+zxfOOOqanmf5tJO7+SfF0HNkoBDU4S2O9qY5Eme3IHCLhRPyY3tA9FAA=="
//后台给的接口网址
#define AliNotifyURL @"后台给的接口网址"

#define kAliPayURLScheme @"AliPayShop"

//通知的名字及参数
#define ALI_PAY_RESULT   @"Ali_pay_result_isSuccessed"
#define ALIPAY_SUCCESSED    @"Ali_pay_isSuccessed"
#define ALIPAY_FAILED       @"Ali_pay_isFailed"

#endif /* AliPayNeedDEF_h */
