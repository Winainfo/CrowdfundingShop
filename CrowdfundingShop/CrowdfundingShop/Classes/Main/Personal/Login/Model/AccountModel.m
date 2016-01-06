//
//  AccountModel.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/1/6.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "AccountModel.h"

@implementation AccountModel
+(instancetype)accountWithDict:(NSDictionary *)dict
{
    AccountModel *account=[[self alloc]init];
    account.uid=dict[@"uid"];
    account.username=dict[@"username"];
    account.email=dict[@"email"];
    account.mobile=dict[@"mobile"];
    return account;
}
#pragma mark 实现代理协议
/**
 *数据模型存进沙盒需要遵循<NSCoding>协议
 *  当一个对象要归档进沙盒中时，就会调用这个方法
 *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒
 *  @param aCoder <#aCoder description#>
 */
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.user_ip forKey:@"user_ip"];
    [aCoder encodeObject:self.img forKey:@"img"];
    [aCoder encodeObject:self.qianming forKey:@"qianming"];
    [aCoder encodeObject:self.groupid forKey:@"groupid"];
    [aCoder encodeObject:self.addgroup forKey:@"addgroup"];
    [aCoder encodeObject:self.money forKey:@"money"];
    [aCoder encodeObject:self.emailcode forKey:@"emailcode"];
    [aCoder encodeObject:self.mobilecode forKey:@"mobilecode"];
    [aCoder encodeObject:self.passcode forKey:@"passcode"];
    [aCoder encodeObject:self.reg_key forKey:@"reg_key"];
    [aCoder encodeObject:self.score forKey:@"score"];
    [aCoder encodeObject:self.jingyan forKey:@"jingyan"];
    [aCoder encodeObject:self.yaoqing forKey:@"yaoqing"];
    [aCoder encodeObject:self.band forKey:@"band"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.login_time forKey:@"login_time"];
    [aCoder encodeObject:self.sign_in_time forKey:@"sign_in_time"];
    [aCoder encodeObject:self.sign_in_date forKey:@"sign_in_date"];
    [aCoder encodeObject:self.sign_in_time_all forKey:@"sign_in_time_all"];
    [aCoder encodeObject:self.auto_user forKey:@"auto_user"];

}
/**
 *  当从沙盒解析一个对象(从沙盒加载一个对象时)时，就会调用这个方法
 *  目的:在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
 *  @param aDecoder <#aDecoder description#>
 *
 *  @return <#return value description#>
 */
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.uid=[aDecoder decodeObjectForKey:@"uid"];
        self.username=[aDecoder decodeObjectForKey:@"username"];
        self.email=[aDecoder decodeObjectForKey:@"email"];
        self.mobile=[aDecoder decodeObjectForKey:@"mobile"];
        self.user_ip=[aDecoder decodeObjectForKey:@"user_ip"];
        self.img=[aDecoder decodeObjectForKey:@"img"];
        self.qianming=[aDecoder decodeObjectForKey:@"qianming"];
        self.groupid=[aDecoder decodeObjectForKey:@"groupid"];
        self.addgroup=[aDecoder decodeObjectForKey:@"addgroup"];
        self.money=[aDecoder decodeObjectForKey:@"money"];
        self.emailcode=[aDecoder decodeObjectForKey:@"emailcode"];
        self.mobilecode=[aDecoder decodeObjectForKey:@"mobilecode"];
        self.passcode=[aDecoder decodeObjectForKey:@"passcode"];
        self.reg_key=[aDecoder decodeObjectForKey:@"reg_key"];
        self.score=[aDecoder decodeObjectForKey:@"score"];
        self.jingyan=[aDecoder decodeObjectForKey:@"jingyan"];
        self.yaoqing=[aDecoder decodeObjectForKey:@"yaoqing"];
        self.band=[aDecoder decodeObjectForKey:@"band"];
        self.time=[aDecoder decodeObjectForKey:@"time"];
        self.login_time=[aDecoder decodeObjectForKey:@"login_time"];
        self.sign_in_time=[aDecoder decodeObjectForKey:@"sign_in_time"];
        self.sign_in_date=[aDecoder decodeObjectForKey:@"sign_in_date"];
        self.sign_in_time_all=[aDecoder decodeObjectForKey:@"sign_in_time_all"];
        self.auto_user=[aDecoder decodeObjectForKey:@"auto_user"];
    }
    return self;
}
@end
