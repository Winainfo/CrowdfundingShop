//
//  RequestData.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/23.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface RequestData : NSObject
/**
 *  字典转字符串工具类
 *
 *  @param dic <#dic description#>
 *
 *  @return <#return value description#>
 */
+(NSString*)getJsonStr:(NSDictionary*)dic;
/**
 *   幻灯片
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)slides:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block;
/**
 *   所有商品
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)allGoods:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block;
/**
 *   即将揭晓
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)beginRevealed:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block;
/**
 *   人气商品
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)hotGoods:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block;
/**
 *   商品详情
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)goodsDetail:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block;
/**
 *   最新揭晓
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)newAnnounced:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block;

/**
 *   登录
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)login:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block;
/**
 *   晒单
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)shareOrder:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block;
@end
