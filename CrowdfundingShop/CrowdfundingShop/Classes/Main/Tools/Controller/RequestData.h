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
+(void)allGoods:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;;
/**
 *   即将揭晓
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)beginRevealed:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   人气商品
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)hotGoods:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   商品详情
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)goodsDetail:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   已揭晓商品详情
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)lotteryGoodsDetail:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   最新揭晓
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)newAnnounced:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;

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
+(void)shareOrder:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   晒单详情
 *
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)shareOrderDetail:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
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
+(void)userDetail:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
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
+(void)reviewSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   我的记录
 * uid 用户id
 * state   all(全部)、ing(进行中)、空(不传默认为已揭晓)
 * pageSize    分页数
 * pageIndex   分页当前页数
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)myRecordSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *  获得的商品
 * uid 用户id
 * pageSize    分页数
 * pageIndex   分页当前页数
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)gainGoodsSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *  我的晒单
 * uid 用户id
 * pageSize    分页数
 * pageIndex   分页当前页数
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)myShareSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *  未晒单
 * uid 用户id
 * pageSize    分页数
 * pageIndex   分页当前页数
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)postSingleList:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *  消费明细
 * uid 用户id
 * pageSize    分页数
 * pageIndex   分页当前页数
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)myConsumeSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *  充值明细
 * uid 用户id
 * pageSize    分页数
 * pageIndex   分页当前页数
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)myRechargeSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *  商品购买记录
 * itemId 商品id
 * pageSize    分页数
 * pageIndex   分页当前页数
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)buyRecordSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *  密码修改
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)updatePwdSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *  修改昵称
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)updateNikenameSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *  获取验证码
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)getMobileCodeSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *  计算结果详情
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)getCalResultSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   添加收货地址
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)addAddressSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   收货地址
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)getAddressSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   删除地址
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)delAddressSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   更新地址
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)updateAddressSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
@end
