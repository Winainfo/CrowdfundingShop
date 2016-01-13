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
/**
 *   晒单详情
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)shareOrderDetail:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block;
/**
 *   购物车数量
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)shopCartNum:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block;
/**
 *   添加购物车
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)addShopCart:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block;
/**
 *   检测用户是否已注册
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)checkName:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block;

/**
 *   搜索接口
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)search:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block;
/**
 *   获取用户信息
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)userDetail:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block;
/**
 *   服务协议
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)servicesProtocol:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block;
/**
 *   关于我们
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)aboutSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block;
/**
 *   点赞
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)dianZanSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block;
/**
 *   评论列表
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)reviewListSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block;
/**
 *   点评
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)reviewSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block;
/**
 *   我的记录
 * uid 用户id
 * state   all(全部)、ing(进行中)、空(不传默认为已揭晓)
 * pageSize    分页数
 * pageIndex   分页当前页数
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)myRecordSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block;
/**
 *  获得的商品
 * uid 用户id
 * pageSize    分页数
 * pageIndex   分页当前页数
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)gainGoodsSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block;
/**
 *  我的晒单
 * uid 用户id
 * pageSize    分页数
 * pageIndex   分页当前页数
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)myShareSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block;
/**
 *  消费明细
 * uid 用户id
 * pageSize    分页数
 * pageIndex   分页当前页数
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)myConsumeSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block;
/**
 *  充值明细
 * uid 用户id
 * pageSize    分页数
 * pageIndex   分页当前页数
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)myRechargeSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block;
@end
