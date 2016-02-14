//
//  Database.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/2/14.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "CartModel.h"
@interface Database : NSObject
@property (nonatomic)sqlite3 *database;
/**创建，打开数据库*/
-(BOOL)openDB;
/**创建数据库*/
-(BOOL)createDataList:(sqlite3 *)db;
/**插入数据*/
-(BOOL)insertList:(CartModel *)insertList;
/**更新数据*/
-(BOOL) updateList:(CartModel *)updateList;
/**获取全部数据*/
-(NSMutableArray *)getList;
/**删除数据*/
-(BOOL)deleteList:(int)bid;
/**查询数据库，searchID为要查询数据的ID，返回数据为查询到的数据*/
-(NSMutableArray*)searchTestList:(NSString*)searchString;
@end
