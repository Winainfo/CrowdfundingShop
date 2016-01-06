//
//  AccountModel.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/1/6.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import <Foundation/Foundation.h>
/**数据模型存进沙盒需要遵循<NSCoding>协议*/
@interface AccountModel : NSObject<NSCoding>
/**字典转换成数据模型*/
+(instancetype)accountWithDict:(NSDictionary *)dict;
/**用户id*/
@property(retain,nonatomic) NSString *uid;
/**用户名*/
@property(retain,nonatomic) NSString *username;
/**用户邮箱*/
@property(retain,nonatomic) NSString *email;
/**用户手机*/
@property(retain,nonatomic) NSString *mobile;
/**用户ip*/
@property(retain,nonatomic) NSString *user_ip;
/**用户头像*/
@property(retain,nonatomic) NSString *img;
/**用户签名*/
@property(retain,nonatomic) NSString *qianming;
/**用户权限组*/
@property(retain,nonatomic) NSString *groupid;
/**用户加入的圈子*/
@property(retain,nonatomic) NSString *addgroup;
/**账户金额*/
@property(retain,nonatomic) NSString *money;
/**邮箱认证码*/
@property(retain,nonatomic) NSString *emailcode;
/**手机认证码*/
@property(retain,nonatomic) NSString *mobilecode;
/**找会密码认证码*/
@property(retain,nonatomic) NSString *passcode;
/**注册参数*/
@property(retain,nonatomic) NSString *reg_key;
/**积分*/
@property(retain,nonatomic) NSString *score;
/**经验值*/
@property(retain,nonatomic) NSString *jingyan;
/**邀请*/
@property(retain,nonatomic) NSString *yaoqing;
/***/
@property(retain,nonatomic) NSString *band;
/**注册时间*/
@property(retain,nonatomic) NSString *time;
/**登录时间*/
@property(retain,nonatomic) NSString *login_time;
/**连续签到天数*/
@property(retain,nonatomic) NSString *sign_in_time;
/**上次签到日期*/
@property(retain,nonatomic) NSString *sign_in_date;
/**总签到次数*/
@property(retain,nonatomic) NSString *sign_in_time_all;
/***/
@property(retain,nonatomic) NSString *auto_user;
@end
