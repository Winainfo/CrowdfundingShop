//
//  DBManager.m
//  PickerDemo
//
//  Created by dev1 on 15/12/15.
//  Copyright © 2015年 demo. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>
#import "Province.h"
#import "City.h"

@interface DBManager ()

@property (nonatomic, strong) NSMutableArray *myDic;
//@property (nonatomic, strong) NSMutableDictionary *proDic;
//@property (nonatomic, strong) NSMutableDictionary *cityDic;
//@property (nonatomic, strong) NSMutableDictionary *zoneDic;

@end

@implementation DBManager

+ (instancetype)sharedDBManager
{
    static DBManager *db = nil;
    if (nil == db) {
        db = [[DBManager alloc] init];
    }
    return db;
}

static sqlite3 *db = nil;

- (void)openDB
{
    if (nil != db) {
        return;
    }
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"china_Province_city_zone(1)." ofType:@""];
    
    int result = sqlite3_open(path.UTF8String, &db);
    if (SQLITE_OK != result) {
        NSLog(@"打开数据库失败");
    }else{
        NSLog(@"打开数据库成功");
    }
}

- (void)closeDB
{
    int result = sqlite3_close(db);
    if (result == SQLITE_OK) {
        sqlite3_exec(db, @"drop student".UTF8String, NULL, NULL, NULL);
        db = nil;
        NSLog(@"关闭数据库成功");
    }else{
        NSLog(@"关闭数据库失败");
    }
}

- (NSArray *) allData
{
    return [self.myDic copy];
}

- (void) disposeProData
{
    NSString *sqlStr = @"SELECT * FROM T_Province";
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, sqlStr.UTF8String, -1, &stmt, NULL);
    if (SQLITE_OK == result) {
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //查找省份
            Province *tempProvince = [[Province alloc] init];
            NSString *proName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)];
            NSString *proSort = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            tempProvince.proName = proName;
            tempProvince.proSort = proSort;
            
            //查找市
            [self disposeCityData:tempProvince];
            
            
            [self.myDic addObject:tempProvince];
        }
    }
    else
    {
        NSLog(@"解析失败");
    }
    sqlite3_finalize(stmt);
    
    for (Province *pro in self.myDic) {
        if (pro.citys.count == 1) {
            City *city = [pro.citys objectAtIndex:0];
            [city.zones insertObject:@"不限" atIndex:0];
        }else{
            City *city = [[City alloc] init];
            city.cityName = @"不限";
            [pro.citys insertObject:city atIndex:0];
        }
    }
    
}

- (void) disposeCityData:(Province *)province
{
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM T_City WHERE ProID = %@", province.proSort];
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, sqlStr.UTF8String, -1, &stmt, NULL);
    if (SQLITE_OK == result) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            City *tempCity = [[City alloc] init];
            NSString *cityName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)];
            NSString *citySort = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            tempCity.cityName = cityName;
            tempCity.citySort = citySort;
            
            //查找区
            [self disposeZoneData:tempCity];
            
            [province.citys addObject:tempCity];
        }
    }
    else
    {
        NSLog(@"解析失败");
    }
    sqlite3_finalize(stmt);

}
- (void) disposeZoneData:(City *)city
{
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM T_Zone WHERE CityID = %@", city.citySort];
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, sqlStr.UTF8String, -1, &stmt, NULL);
    if (SQLITE_OK == result) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSString *zoneName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            [city.zones addObject:zoneName];
        }
    }
    else
    {
        NSLog(@"解析失败");
    }
    sqlite3_finalize(stmt);

}

#pragma mark - lazy loading

- (NSMutableArray *)myDic
{
    if (!_myDic) {
        self.myDic = [NSMutableArray arrayWithCapacity:34];
    }
    return _myDic;
}


@end
