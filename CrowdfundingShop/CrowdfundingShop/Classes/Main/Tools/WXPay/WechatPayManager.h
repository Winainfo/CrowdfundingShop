//
//  WechatPayManager.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/3/23.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "CommonUtil.h"
#import "GDataXMLNode.h"
@interface WechatPayManager : NSObject
- (void)getWeChatPayWithOrderName:(NSString *)name
                            price:(NSString*)price;
@end
