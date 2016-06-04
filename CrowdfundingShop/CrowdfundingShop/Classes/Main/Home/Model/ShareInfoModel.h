//
//  ShareInfoModel.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/1/12.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareInfoModel : NSObject
@property(retain,nonatomic)NSString *sd_id;
@property(retain,nonatomic)NSString *sd_zhan;//点赞数
@property(retain,nonatomic)NSString *sd_ping;//评论数
@property(assign,nonatomic)BOOL selectState;//是否选中状态


-(instancetype)initWithDict:(NSDictionary *)dict;
@end
