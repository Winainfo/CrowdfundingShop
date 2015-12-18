//
//  TVClass.m
//
//
//  Created by ibokan on 15/5/19.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "HistoryClass.h"

@implementation HistoryClass

+(NSArray *)findall
{
    NSMutableArray *stus=[NSMutableArray arrayWithCapacity:1];
    //打开数据连接
    sqlite3 *db=[DB openDB];
    //创建sql语句对象
    sqlite3_stmt *stmt=nil;
    int result=sqlite3_prepare_v2(db, "select * from HISTORYinfo", -1, &stmt, NULL);
    //检查语句有效性
    if (result==SQLITE_OK) {
        while (SQLITE_ROW==sqlite3_step(stmt)) {//读取数据记录，游标来读
           
            HistoryClass *his=[HistoryClass new];
            his.Hid=sqlite3_column_int(stmt, 0);
            his.Hname=[NSString stringWithCString:(const char *)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
            
            [stus addObject:his];
        }
    }
    //关闭语句
    sqlite3_finalize(stmt);
    return  stus;
}

//添加数据
+(void) insertHname:(NSString *)Hname
{
    //打开数据连接
    sqlite3 *db=[DB openDB];
    //创建sql语句对象
    sqlite3_stmt *stmt=nil;
    int result=sqlite3_prepare_v2(db, "insert into HISTORYinfo(Hname) values(?)", -1, &stmt, NULL);
    //(?,?,?)？是为了防止sql注入
    if (result==SQLITE_OK) {//判断sql语句的有效性
        //绑定？占位符
        sqlite3_bind_text(stmt, 1, [Hname UTF8String], -1, NULL);//NULL不做任何回调，-1是长度，表示长度让系统算
        if (sqlite3_step(stmt)!=SQLITE_DONE) {
            NSLog(@"插入异常");
        }
    }
    sqlite3_finalize(stmt);
}
//删除数据
+(void) deleteHISTORY:(int)Hid
{
    //打开数据连接
    sqlite3 *db=[DB openDB];
    //创建sql语句对象
    sqlite3_stmt *stmt=nil;
    int result=sqlite3_prepare_v2(db, "delete from HISTORYinfo where Hid=?", -1, &stmt, NULL);
    //(?,?,?)？是为了防止sql注入
    if (result==SQLITE_OK) {//判断sql语句的有效性
        //绑定？占位符
        sqlite3_bind_int(stmt, 1, Hid);
        
        if (sqlite3_step(stmt)!=SQLITE_DONE) {
            NSLog(@"数据删除异常");
        }
    }
    sqlite3_finalize(stmt);
}

+(void) deleteAllHistory
{
    //打开数据连接
    sqlite3 *db=[DB openDB];
    //创建sql语句对象
    sqlite3_stmt *stmt=nil;
    int result=sqlite3_prepare_v2(db, "delete from HISTORYinfo", -1, &stmt, NULL);
    //(?,?,?)？是为了防止sql注入
    if (result==SQLITE_OK) {//判断sql语句的有效性
        
        if (sqlite3_step(stmt)!=SQLITE_DONE) {
            NSLog(@"数据删除异常");
        }
    }
    
    sqlite3_finalize(stmt);
}


@end
