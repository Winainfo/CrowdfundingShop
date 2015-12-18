//
//  DB.h
//  京东图书APP
//
//  Created by ibokan on 15/5/19.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DB : NSObject

//创建，打开数据库
+(sqlite3 *)openDB;

@end
