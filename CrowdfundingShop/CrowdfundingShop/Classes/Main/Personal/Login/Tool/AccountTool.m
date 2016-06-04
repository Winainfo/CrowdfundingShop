//
//  AccountTool.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/1/6.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "AccountTool.h"

/**
 *  账号的存储路径
 *
 *  @param NSDocumentDirectory <#NSDocumentDirectory description#>
 *  @param NSUserDomainMask    <#NSUserDomainMask description#>
 *  @param YES                 <#YES description#>
 *
 *  @return <#return value description#>
 */
#define  AccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfo.archive"]
@implementation AccountTool
/**
 *   存储账号信息
 *
 *  @param account <#account description#>
 */
+(void)saveAccount:(AccountModel *)account
{
    //利用NSKeyedArchiver类 写进沙盒
    //自定义对象的存储必须用NSKeyedArchiver,不再有什么writeToFile方法
    [NSKeyedArchiver archiveRootObject:account toFile:AccountPath];
}
/**
 *  返回账号信息
 *
 *  @return 账号模型(如果账号过期，返回nil)
 */
+(AccountModel *)account
{
    //加载模型
    AccountModel *account=[NSKeyedUnarchiver unarchiveObjectWithFile:AccountPath];
    /**验证账号是否过期*/
    //NSLog(@"%@ %@",expiresTime,now);
    return account;
}
@end
