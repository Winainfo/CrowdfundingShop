//
//  City.m
//  PickerDemo
//
//  Created by dev1 on 15/12/15.
//  Copyright © 2015年 demo. All rights reserved.
//

#import "City.h"

@implementation City

- (id)copyWithZone:(NSZone *)zone
{
    City *city = [[City alloc] init];
    city.cityName = [self.cityName copy];
    city.citySort = [self.citySort copy];
    city.zones = [self.zones copy];
    return city;
}

- (NSMutableArray *)zones
{
    if (_zones == nil) {
        self.zones = [NSMutableArray array];
    }
    return _zones;
}

@end
