//
//  RequestData.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/21.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
@interface RequestData : NSObject
/**
 *  字典转字符串工具类
 *
 *  @param dic <#dic description#>
 *
 *  @return <#return value description#>
 */
+(NSString*)getJsonStr:(NSDictionary*)dic;

@end
