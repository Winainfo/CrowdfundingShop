//
//  LoginMethod.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/1/12.
//  Copyright © 2016年 吴金林. All rights reserved.
//



#import <Foundation/Foundation.h>
//#import <objc/runtime.h>
@protocol LoginMethodDelegate <NSObject>
/**
 *  拿到数据之后的代理方法
 *
 *  @param userInfo 拿到的用户数据
 *  @param errorMsg 返回的错误信息。（判断是否存在错误信息，如果没有错误信息，用户数据可以拿到）
 */
- (void)recieveTheUserInfo:(NSDictionary *)userInfo errorMsg:(NSString *)errorMsg;
@end

typedef NS_ENUM(NSInteger,LoginType) {
    LoginTypeWechat,//微信
    LoginTypeQQ,//QQ
    LoginTypeSinaWeibo//新浪微博
};

@interface LoginMethod : NSObject
- (void)getUserInfoDicWithThirdPartyLoginType:(LoginType)loginType;
@property (nonatomic ,weak) id<LoginMethodDelegate>delegate;
@end
