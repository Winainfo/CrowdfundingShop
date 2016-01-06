//
//  AccountTool.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/1/6.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountModel.h"
/**
 *  业务逻辑
 */
@interface AccountTool : NSObject
/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+(void)saveAccount:(AccountModel *)account;

/**
 *  返回账号信息
 *
 *  @return 账号模型(如果账号过期，返回nil)
 */
+(AccountModel *)account;
@end
