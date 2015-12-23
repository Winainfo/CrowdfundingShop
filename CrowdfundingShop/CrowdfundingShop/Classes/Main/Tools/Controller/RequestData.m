//
//  RequestData.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/23.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "RequestData.h"
#import "AFNetworking.h"
#import <EGOCache.h>
#define URL @"http://wn.winainfo.com"
@implementation RequestData
/**
 *  字典转字符串工具类
 *
 *  @param dic <#dic description#>
 *
 *  @return <#return value description#>
 */
+(NSString*)getJsonStr:(NSDictionary*)dic{
    NSError *error = nil;
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dic
                                                     options:NSJSONWritingPrettyPrinted
                                                       error:&error];
    if ([jsonData length] > 0 && error == nil){
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }else{
        return nil;
    }
}
#pragma mark 登录
/**
 *  登录接口
 *
 *  @param data  <#data description#>
 *  @param block <#block description#>
 */
+(void)lgin:(NSDictionary *)data FinishCallbackBlock:(void (^)(NSDictionary *))block
{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
   //设置参数
    NSDictionary *params=@{@"user":data[@"user"],@"password":data[@"password"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/ajax/userlogin/",URL];
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"登录请求成功-----%@",responseObject);
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"登录请求失败-%@",error);
    }];
    
}
#pragma mark 首页图片轮播
/**
 *  首页幻灯片
 *
 *  @param data  <#data description#>
 *  @param block <#block description#>
 */
+(void)slides:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/ajax/slides/",URL];
    NSString *forkey= @"slides";
    EGOCache *cache=[EGOCache new];
    if ([cache hasCacheForKey:forkey]) {
        NSDictionary *data=(NSDictionary *)[[EGOCache globalCache]objectForKey:forkey];
        NSLog(@"缓存存在---");
        block(data);
    }else{
        [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [[EGOCache globalCache]setObject:responseObject forKey:forkey withTimeoutInterval:24*60*60];
            NSLog(@"登录请求成功-----%@",responseObject);
            block(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"登录请求失败-%@",error);
        }];
    }
}
@end
