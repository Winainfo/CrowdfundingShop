//
//  ShareInfoModel.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/1/12.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "ShareInfoModel.h"

@implementation ShareInfoModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.sd_id=dict[@"sd_id"];
        self.sd_zhan=dict[@"sd_zhan"];
        self.sd_ping=dict[@"sd_ping"];
        self.selectState = [dict[@"selectState"]boolValue];
    }
    return  self;
}
@end
