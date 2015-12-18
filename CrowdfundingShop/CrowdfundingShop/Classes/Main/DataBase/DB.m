//
//  DB.m
//  
//
//  Created by ibokan on 15/5/19.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "DB.h"


@implementation DB

static sqlite3 *db=nil;//静态连接对象，创建之后不再反复创建，一直持有
+(sqlite3 *)openDB
{
    if (!db){
        //数据库文件源路径
        NSString *source=[[NSBundle mainBundle]pathForResource:@"HITORY" ofType:@"sqlite"];
        //目标目录Document
        NSArray *array1=NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory,//获取Documents
                                                            NSUserDomainMask,//ios中一般为此选项
                                                            YES);//绝对路径
        NSString *path=array1[0];
        //往路径添加文件
        NSString *target=[path stringByAppendingPathComponent:@"HITORY.sqlite"];
        NSLog(@"%@",path);
        //文件管理器
        NSFileManager *file=[NSFileManager defaultManager];
        if (![file fileExistsAtPath:target]) {//判断是否不存在这份文档
            NSError *error;
            [file copyItemAtPath:source toPath:target error:&error];
            if (error) {
                NSLog(@"%@",error);
            }
        }
        
        //打开数据连接
        sqlite3_open([target UTF8String], &db);
        
    }
    return db;
}

@end
