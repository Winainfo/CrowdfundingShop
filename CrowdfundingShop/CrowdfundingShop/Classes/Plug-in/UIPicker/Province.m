//
//  Province.m
//  PickerDemo
//
//  Created by dev1 on 15/12/15.
//  Copyright © 2015年 demo. All rights reserved.
//

#import "Province.h"

@implementation Province

- (id)copyWithZone:(NSZone *)zone
{
    Province *province = [[Province alloc] init];
    province.proName = [self.proName copy];
    province.proSort = [self.proSort copy];
    province.citys = [self.citys copy];
    return province;
}

- (NSMutableArray *)citys
{
    if (_citys == nil) {
        self.citys = [NSMutableArray array];
    }
    return _citys;
}

@end
