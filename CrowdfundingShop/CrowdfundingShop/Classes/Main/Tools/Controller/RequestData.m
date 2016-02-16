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
#define URL @"http://www.yiydb.cn"
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
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/ajax/slides/",URL];
    NSString *forkey= @"slides";
    EGOCache *cache=[EGOCache new];
    if ([cache hasCacheForKey:forkey]) {
        NSDictionary *data=(NSDictionary *)[[EGOCache globalCache]objectForKey:forkey];
        block(data);
    }else{
        [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *data =  [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]; //把网络数据转换成字符串
            NSDictionary *dictionary=[self dictionaryWithJsonString:data];//把字符串转换成字典
            [[EGOCache globalCache]setObject:dictionary forKey:forkey withTimeoutInterval:24*60*60];
            NSLog(@"请求成功-----%@",dictionary);
            block(dictionary);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //            NSLog(@"请求失败-%@",error);
        }];
    }
}
#pragma mark 所有商品
/**
 *   所有商品
 *
 *  @param data  传入字典｛categoryId：分类id，sort：排序 ,pageSize：分页数，pageIndex：当前页数｝
 *  @param block 返回块值
 */
+(void)allGoods:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void (^)(NSError *))failure{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"categoryId":data[@"categoryId"],@"sort":data[@"sort"],@"pageIndex":data[@"pageIndex"],@"pageSize":data[@"pageSize"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/ios/all_shop_list/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"所有商品请求成功-----%@",responseObject);
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
/**
 *  即将揭晓
 *
 *  @param data  <#data description#>
 *  @param block <#block description#>
 */
+(void)beginRevealed:(NSDictionary *)data FinishCallbackBlock:(void (^)(NSDictionary *))block andFailure:(void (^)(NSError *))failure{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"pageIndex":data[@"pageIndex"],@"pageSize":data[@"pageSize"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/ios/index/ready/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

//+(void)beginRevealed:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block{
//    //1.请求管理者
//    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
//    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
//    //设置参数
//    NSDictionary *params=@{@"pageIndex":data[@"pageIndex"],@"pageSize":data[@"pageSize"]};
//    NSString *url=[NSString stringWithFormat:@"%@/?/ios/ios/index/ready/",URL];
//    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        block(responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////        NSLog(@"所有商品请求失败-%@",error);
//    }];
//}
/**
 *  人气商品
 *
 *  @param data         <#data description#>
 *  @param changeFormat <#changeFormat description#>
 *  @param data         <#data description#>
 */
+(void)hotGoods:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void (^)(NSError *))failure{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"pageIndex":data[@"pageIndex"],@"pageSize":data[@"pageSize"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/ios/index/shoplist_renqi/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"所有商品请求成功-----%@",responseObject);
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
/**
 *   最新揭晓
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)newAnnounced:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void (^)(NSError *))failure{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"pageIndex":data[@"pageIndex"],@"pageSize":data[@"pageSize"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/ajax/get_lottery_list/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"最新揭晓商品请求成功-----%@",responseObject);
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
/**
 *  商品详情
 *
 *  @param data  <#data description#>
 *  @param block <#block description#>
 */
+(void)goodsDetail:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void (^)(NSError *))failure{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"itemId":data[@"goodsId"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/ios/item/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
/**
 *   已揭晓商品详情
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)lotteryGoodsDetail:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"itemId":data[@"goodsId"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/ajax/dataserver/",URL];
    NSLog(@"%@",url);
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
/**
 *  登录
 *
 *  @param data  <#data description#>
 *  @param block <#block description#>
 */
+(void)login:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"user":data[@"user"],@"password":data[@"password"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/ajax/userlogin/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"登录请求成功-----%@",responseObject);
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"登录请求失败-%@",error);
    }];
}
/**
 *   晒单
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)shareOrder:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void (^)(NSError *))failure{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"pageIndex":data[@"pageIndex"],@"pageSize":data[@"pageSize"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/ios/index/shaidan/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"晒单请求成功-----%@",responseObject);
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
/**
 *   晒单详情
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)shareOrderDetail:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void (^)(NSError *))failure{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"sd_id":data[@"sd_id"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/shaidan/detail/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
/**
 *   购物车数量
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)shopCartNum:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    //    NSDictionary *params=@{@"pageIndex":data[@"pageIndex"],@"pageSize":data[@"pageSize"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/ajax/cartnum/",URL];
    [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"晒单请求失败-%@",error);
    }];
}
/**
 *   添加购物车
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)addShopCart:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"ShopId":data[@"ShopId"],@"ShopNum":data[@"ShopNum"],@"cartbs":@"10"};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/ajax/addShopCart/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"添加购物车请求成功-----%@",responseObject);
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"晒单请求失败-%@",error);
    }];
}


/**
 *   检测用户是否已注册
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)checkName:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"user":data[@"user"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/ajax/checkname/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"添加购物车请求成功-----%@",responseObject);
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"晒单请求失败-%@",error);
    }];
}

/**
 *   搜索接口
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)search:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block
{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"keyword":data[@"keyword"],@"pageIndex":data[@"pageIndex"],@"pageSize":data[@"pageSize"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/ios/search/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"所有商品请求成功-----%@",responseObject);
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"所有商品请求失败-%@",error);
    }];
}
/**
 *   获取用户信息
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)userDetail:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void (^)(NSError *))failure{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"uid":data[@"uid"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/ios/userindex/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
/**
 *  将传入的二进制数据转为字符串后将content字段删除
 *  @param data 包含content字段的二进制数据
 *  @return 不包含content字段的二进制数据
 */
+(NSData*) changeFormat:(NSData*) data{
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"hello" ofType:@"json"];
    str=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *regStr=@"\"content\":\"<.+,\"fmtContent2\"";
    NSRange rage=[str rangeOfString:regStr options:NSRegularExpressionSearch];
    NSString *newStr= [str stringByReplacingCharactersInRange:rage withString:@"\"fmtContent2\""];
    NSData *newData=[newStr dataUsingEncoding:NSUTF8StringEncoding];
    return newData;
}

/**
 *  NSString去除所有HTML标签
 *
 *  @param html <#html description#>
 *  @param trim <#trim description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim {
    NSScanner *theScanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    // trim off whitespace
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
/**
 *   服务协议
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)servicesProtocol:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    //    NSDictionary *params=@{@"uid":data[@"uid"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/ios/terms/",URL];
    [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"请求成功-----%@",responseObject);
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"所有商品请求失败-%@",error);
    }];
}
/**
 *   关于我们
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)aboutSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    //    NSDictionary *params=@{@"uid":data[@"uid"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/ios/about/",URL];
    [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"请求成功-----%@",responseObject);
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"所有商品请求失败-%@",error);
    }];
}
/**
 *   点赞
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)dianZanSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"sd_id":data[@"sd_id"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/shaidan/dianZan/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求成功-----%@",responseObject);
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"所有商品请求失败-%@",error);
    }];
}
/**
 *   评论列表
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)reviewListSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"type":data[@"type"],@"sd_id":data[@"sd_id"],@"pageIndex":data[@"pageIndex"],@"pageSize":data[@"pageSize"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/shaidan/detail/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求成功-----%@",responseObject);
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"所有商品请求失败-%@",error);
    }];
}
/**
 *   点评
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)reviewSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void (^)(NSError *))failure{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"uid":data[@"uid"],@"sdhf_id":data[@"sdhf_id"],@"sdhf_content":data[@"sdhf_content"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/shaidan/plajax/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"请求成功-----%@",responseObject);
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
/**
 *   我的记录
 * uid 用户id
 * state   all(全部)、ing(进行中)、空(不传默认为已揭晓)
 * pageSize    分页数
 * pageIndex   分页当前页数
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)myRecordSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void (^)(NSError *))failure{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"uid":data[@"uid"],@"state":data[@"state"],@"pageIndex":data[@"pageIndex"],@"pageSize":data[@"pageSize"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/shopajax/getUserBuyList/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"请求成功-----%@",responseObject);
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
/**
 *  获得的商品
 * uid 用户id
 * pageSize    分页数
 * pageIndex   分页当前页数
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)gainGoodsSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void (^)(NSError *))failure{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"uid":data[@"uid"],@"pageIndex":data[@"pageIndex"],@"pageSize":data[@"pageSize"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/shopajax/getUserOrderList/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"请求成功-----%@",responseObject);
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
/**
 *  我的晒单
 * uid 用户id
 * pageSize    分页数
 * pageIndex   分页当前页数
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)myShareSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void (^)(NSError *))failure{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"uid":data[@"uid"],@"pageIndex":data[@"pageIndex"],@"pageSize":data[@"pageSize"]};
    NSLog(@"参数%@",params);
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/shopajax/getUserPostList/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"请求成功-----%@",responseObject);
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
/**
 *  未晒单
 * uid 用户id
 * pageSize    分页数
 * pageIndex   分页当前页数
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)postSingleList:(NSDictionary *)data FinishCallbackBlock:(void (^)(NSDictionary *))block andFailure:(void (^)(NSError *))failure{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"uid":data[@"uid"],@"pageIndex":data[@"pageIndex"],@"pageSize":data[@"pageSize"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/shopajax/getUserUnPostList/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
/**
 *  消费明细
 * uid 用户id
 * pageSize    分页数
 * pageIndex   分页当前页数
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)myConsumeSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void (^)(NSError *))failure{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"uid":data[@"uid"],@"pageIndex":data[@"pageIndex"],@"pageSize":data[@"pageSize"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/shopajax/getUserConsumption/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"请求成功-----%@",responseObject);
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
/**
 *  充值明细
 * uid 用户id
 * pageSize    分页数
 * pageIndex   分页当前页数
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)myRechargeSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void (^)(NSError *))failure{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"uid":data[@"uid"],@"pageIndex":data[@"pageIndex"],@"pageSize":data[@"pageSize"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/shopajax/getUserRecharge/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"请求成功-----%@",responseObject);
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
/**
 *  商品购买记录
 * itemId 商品id
 * pageSize    分页数
 * pageIndex   分页当前页数
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)buyRecordSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"itemId":data[@"itemId"],@"pageIndex":data[@"pageIndex"],@"pageSize":data[@"pageSize"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/ios/buy_records/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
/**
 *  密码修改
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)updatePwdSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"uid":data[@"uid"],@"userpassword":data[@"userpassword"],@"userpassword2":data[@"userpassword2"],@"password":data[@"password"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/home/userpassword/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
/**
 *  修改昵称
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)updateNikenameSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"uid":data[@"uid"],@"username":data[@"username"],@"qianming":data[@"qianming"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/home/usermodify/",URL];
    NSLog(@"对象%@",params);
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
/**
 *  获取验证码
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)getMobileCodeSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"uid":data[@"uid"],@"mobile":data[@"mobile"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/home/mobile_send/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
/**
 *  计算结果详情
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)getCalResultSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"itemId":data[@"itemId"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/ios/calResult/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
/**
 *   添加收货地址
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)addAddressSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"uid":data[@"uid"],@"sheng":data[@"sheng"],@"shi":data[@"shi"],@"xian":data[@"xian"],@"jiedao":data[@"jiedao"],@"youbian":data[@"youbian"],@"shouhuoren":data[@"shouhuoren"],@"tell":data[@"tell"],@"mobile":data[@"mobile"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/home/useraddress/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
/**
 *   收货地址
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)getAddressSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"uid":data[@"uid"],@"pageIndex":data[@"pageIndex"],@"pageSize":data[@"pageSize"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/home/address/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
/**
 *   删除地址
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)delAddressSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"uid":data[@"uid"],@"id":data[@"id"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/home/deladdress/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
/**
 *   更新地址
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)updateAddressSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"id":data[@"id"],@"uid":data[@"uid"],@"sheng":data[@"sheng"],@"shi":data[@"shi"],@"xian":data[@"xian"],@"jiedao":data[@"jiedao"],@"youbian":data[@"youbian"],@"shouhuoren":data[@"shouhuoren"],@"tell":data[@"tell"],@"mobile":data[@"mobile"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/home/updateddress/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
/**
 *   充值服务
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)rechargeSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure{
    //1.请求管理者
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置参数
    NSDictionary *params=@{@"uid":data[@"uid"],@"banktype":data[@"banktype"],@"money":data[@"money"]};
    NSString *url=[NSString stringWithFormat:@"%@/?/ios/cart/addmoney/",URL];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
@end
