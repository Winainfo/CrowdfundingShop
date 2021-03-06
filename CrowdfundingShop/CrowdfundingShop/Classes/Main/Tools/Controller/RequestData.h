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
+(void)login:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;;
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
+(void)search:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
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
 *  修改签名
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)updateQianMingSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
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
/**
 *   充值服务
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)rechargeSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   好友列表
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)friendsSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   佣金列表
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)commissionsSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   提现记录列表
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)cashRecordSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   第三方登录
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)thirdLodigSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   第三方注册
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)thirdRegisterSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   邀请码
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)inviteManageSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   获取UnionID
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)userinfoSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   用户注册
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)userRegisterSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   获取验证码
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)getCodeSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   核对验证码
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)checkCodeSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   一键转入云购账户
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)cashMoneySerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   绑定手机
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)bindMobileSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   发送手机验证码
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)sendMobileCodeSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   发送邮箱验证码
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)sendEmalCodeSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   找回密码发送验证码
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)forgetCodeSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   找回密码绑定验证码
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)forgetBindCodeSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   找回密码修改
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)forgetUpdateSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   余额支付
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)moneyPaySerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   支付宝支付
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)AliPaySerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   积分支付
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)ScorePaySerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   微信支付
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)WxPaySerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   商品分类
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)shopCategorySerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   头像上传
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)uplodPhotoSerivce:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   隐藏和显示
 *  @param data  传入字典
 *  @param block 返回块值
 */
+(void)hideShowView:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSDictionary *))block andFailure:(void(^)(NSError *))failure;
/**
 *   商品列表
 *  @param data  传入字典
 *  @param block 返回块值
 *  id:排序ID
 *  tid:分类ID
 *  pageSize:页数
 *  pageNo:页码
 */
+(void)goodsList:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSArray *))block andFailure:(void(^)(NSError *))failure;
/**
 *   揭晓列表
 *  @param data  传入字典
 *  @param block 返回块值
 *  pageSize:页数
 *  pageNo:页码
 *  
 */
+(void)getLotteryList:(NSDictionary *)data FinishCallbackBlock:(void(^)(NSArray *))block andFailure:(void(^)(NSError *))failure;
@end

