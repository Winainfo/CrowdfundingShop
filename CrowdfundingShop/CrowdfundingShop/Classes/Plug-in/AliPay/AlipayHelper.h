//
//  AlipayHelper.h
//  Alipay
//
//  Created by 换一换 on 16/1/7.
//  Copyright © 2016年 张洋. All rights reserved.
//
typedef void(^alipayBlock)(void);
#import <Foundation/Foundation.h>

@interface AlipayHelper : NSObject



+(void)orderDetialInfo:(NSDictionary *) dict Success:(alipayBlock)success Failure:(alipayBlock)failure Ispaying:(alipayBlock)ispaying;

@end
