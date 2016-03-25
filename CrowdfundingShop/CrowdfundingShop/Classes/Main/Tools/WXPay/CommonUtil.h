//
// 
//  微信支付
//
//  Created by Evans on 16/1/22.
//  Copyright (c) 2015年 Evans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtil : NSObject

+ (NSString *)md5:(NSString *)input;

+ (NSString *)sha1:(NSString *)input;

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (NSDictionary *)getIPAddresses;

@end
