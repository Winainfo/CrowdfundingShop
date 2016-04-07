//
//  Database.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/2/14.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "Database.h"

@implementation Database
/**
 *  获取document目录并返回数据库目录
 *
 *  @return <#return value description#>
 */
-(NSString *)dataFilePath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
//    NSLog(@"路径====%@",documentsDirectory);
    return [documentsDirectory stringByAppendingPathComponent:@"CartDB.sqlite"];
}
#pragma mark创建数据库
/**
 *  创建，打开数据库
 *
 *  @return <#return value description#>
 */
-(BOOL)openDB
{
    //获取数据库路径
    NSString *path=[self dataFilePath];
    //文件管理器
    NSFileManager *fileManager=[NSFileManager defaultManager];
    //判断数据库是否存在 存在find=YES,不存在find=NO
    BOOL find=[fileManager fileExistsAtPath:path];
    
    //如果数据库存在，则用sqlite3_open直接打开（不要担心，如果数据库不存在sqlite3_open会自动创建）
    if (find) {
//        NSLog(@"数据库已存在");
        //打开数据库，这里的[path UTF8String]是将NSString转换为C字符串，因为SQLite3是采用可移植的C(而不是Objective-C)编写的，它不知道什么是NSString.
        if (sqlite3_open([path UTF8String], &_database)!=SQLITE_OK) {
            //如果打开数据库失败则关闭数据库
            sqlite3_close(_database);
//            NSLog(@"Error：打开数据库失败.");
            return NO;
        }
        //创建一个新表
        [self createDataList:_database];
        return YES;
    }
    //如果发现数据库不存在则利用sqlite3_open创建数据库（上面已经提到过），与上面相同，路径要转换为C字符串
    if (sqlite3_open([path UTF8String], &_database)==SQLITE_OK) {
        //创建一个新表
        [self createDataList:_database];
        return YES;
    }else
    {
        //如果创建并打开数据库失败则关闭数据库
        sqlite3_close(_database);
        NSLog(@"Error：打开数据库失败.");
        return NO;
    }
    return NO;
}
#pragma mark 创建表
/**
 *  创建表
 *
 *  @param db <#db description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)createDataList:(sqlite3 *)db
{
    char *sql="create table if not exists cart_table(pk_id INTEGER PRIMARY KEY  NOT NULL,shopId varchar(20),title varchar(200),shenyurenshu varchar(20),thumb varchar(200),num int,price int)";
    sqlite3_stmt *stmt;
    //sqlite3_prepare_v2 接口把一条SQL语句解析到statement结构里去. 使用该接口访问数据库是当前比较好的的一种方法
    NSInteger sqlReturn=sqlite3_prepare_v2(_database, sql, -1, &stmt, nil);
    //第一个参数跟前面一样，是个sqlite3 * 类型变量，
    //第二个参数是一个 sql 语句。
    //第三个参数我写的是-1，这个参数含义是前面 sql 语句的长度。如果小于0，sqlite会自动计算它的长度（把sql语句当成以\0结尾的字符串）。
    //第四个参数是sqlite3_stmt 的指针的指针。解析以后的sql语句就放在这个结构里。
    //第五个参数是错误信息提示，一般不用,为nil就可以了。
    //如果这个函数执行成功（返回值是 SQLITE_OK 且 statement 不为NULL ），那么下面就可以开始插入二进制数据。
    
    //如果SQL语句解析出错的话程序返回
    if (sqlReturn!=SQLITE_OK) {
        NSLog(@"Error:错误的语句");
        return NO;
    }
    //执行SQL语句
    int success=sqlite3_step(stmt);
    //释放sqlite3_stmt
    sqlite3_finalize(stmt);
    //执行SQL语句失败
    if(success!=SQLITE_DONE)
    {
        NSLog(@"Error: 执行失败");
        return NO;
    }
    NSLog(@"创建‘Book表’成功");
    return YES;
}
#pragma mark 插入
/**
 *  插入数据
 *
 *  @param insertList <#insertList description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)insertList:(CartModel *)insertList
{
    //先判断数据库是否打开
    if([self openDB]){
        sqlite3_stmt *stmt;
        //这个 sql 语句特别之处在于 values 里面有个? 号。在sqlite3_prepare函数里，?号表示一个未定的值，它的值等下才插入。
        char *sql="insert into cart_table(shopId,title,shenyurenshu,thumb,num,price)values(?,?,?,?,?,?)";
        int success=sqlite3_prepare_v2(_database, sql, -1, &stmt, NULL);
        NSLog(@"%i",success);
        if(success!=SQLITE_OK){
            NSLog(@"Error:错误的插入");
            sqlite3_close(_database);
            return NO;
        }
        //这里的数字1，2，3,4,5代表上面的第几个问号，这里将五个值绑定到五个绑定变量
        sqlite3_bind_text(stmt, 1, [insertList.shopId UTF8String],-1,NULL);
        sqlite3_bind_text(stmt, 2, [insertList.title UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [insertList.shenyurenshu UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 4, [insertList.thumb UTF8String], -1, NULL);
        sqlite3_bind_int(stmt, 5, insertList.num);
        sqlite3_bind_int(stmt, 6, insertList.price);
        //执行插入语句
        success=sqlite3_step(stmt);
        //释放statement
        sqlite3_finalize(stmt);
        //如果插入失败
        if(success==SQLITE_ERROR){
            NSLog(@"Error:插入数据失败");
            return NO;
        }
        //关闭数据库
        return YES;
    }
    return NO;
}
#pragma mark 更新
/**
 *  更新数据
 *
 *  @param updateList <#updateList description#>
 *
 *  @return <#return value description#>
 */
-(BOOL) updateList:(CartModel *)updateList
{
    if ([self openDB]) {
        sqlite3_stmt *stmt;//这相当一个容器，放转化OK的sql语句
        char *sql = "update cart_table set num = ?,price = ? where pk_id = ?";
        //将SQL语句放入sqlite3_stmt中
        int success = sqlite3_prepare_v2(_database, sql, -1, &stmt, NULL);
        if (success != SQLITE_OK) {
            NSLog(@"Error: failed to update:testTable");
            sqlite3_close(_database);
            return NO;
        }
        //这里的数字1，2，3代表第几个问号。这里只有1个问号，这是一个相对比较简单的数据库操作，真正的项目中会远远比这个复杂
        //绑定text类型的数据库数据
        sqlite3_bind_int(stmt, 1, updateList.num);
        sqlite3_bind_int(stmt, 2, updateList.price);
        sqlite3_bind_int(stmt, 3, updateList.pk_id);
        //执行SQL语句。这里是更新数据库
        success = sqlite3_step(stmt);
        //释放statement
        sqlite3_finalize(stmt);
        //如果执行失败
        if (success == SQLITE_ERROR) {
            NSLog(@"Error: failed to update the database with message.");
            return NO;
        }
        return YES;
    }
    return NO;
}
#pragma mark 查询
/**
 *  查询数据
 *
 *  @return <#return value description#>
 */
-(NSMutableArray *)getList
{
    NSMutableArray *array= [NSMutableArray arrayWithCapacity:1];
    //判断数据库是否打开
    if([self openDB])
    {
        sqlite3_stmt *stmt=nil;
        //sql语句
        char *sql="select * from cart_table";
        if(sqlite3_prepare_v2(_database, sql, -1, &stmt, NULL)!=SQLITE_OK)
        {
            NSLog(@"Error:查询失败!");
        }
        else
        {
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                CartModel *cartList=[[CartModel alloc]init];
                cartList.pk_id=sqlite3_column_int(stmt, 0);
                cartList.shopId=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt, 1)];
                cartList.title=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt, 2)];
                cartList.shenyurenshu=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt, 3)];
                cartList.thumb=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt, 4)];
                cartList.num=sqlite3_column_int(stmt, 5);
                cartList.price=sqlite3_column_int(stmt, 6);
                //添加数据到数组中
                [array addObject:cartList];
            }
        }
        sqlite3_finalize(stmt);
    }
    return array;
}
/**
 *  根据商品ID查询
 *
 *  @param searchString <#searchString description#>
 *
 *  @return <#return value description#>
 */
- (NSMutableArray*)searchTestList:(NSString*)searchString{
    
    NSMutableArray *array= [NSMutableArray arrayWithCapacity:1];
    //判断数据库是否打开
    if([self openDB])
    {
        sqlite3_stmt *stmt=nil;
        //sql语句
//        char *sql="select * from cart_table";
        //sql语句
        NSString *sql=[NSString stringWithFormat:@"select * from cart_table  where shopId =\"%@\"",searchString];
         int success = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
        
        if(success !=SQLITE_OK)
        {
            NSLog(@"Error:查询失败!");
        }
        else
        {
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                CartModel *cartList=[[CartModel alloc]init];
                cartList.pk_id=sqlite3_column_int(stmt, 0);
                cartList.shopId=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt, 1)];
                cartList.title=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt, 2)];
                cartList.shenyurenshu=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt, 3)];
                cartList.thumb=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt, 4)];
                cartList.num=sqlite3_column_int(stmt, 5);
                cartList.price=sqlite3_column_int(stmt, 6);
                //添加数据到数组中
                [array addObject:cartList];
            }
        }
        sqlite3_finalize(stmt);
    }
    return array;
}
#pragma mark 删除
/**
 *  删除数据
 *
 *  @param bid <#bid description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)deleteList:(int)bid
{
    if ([self openDB]) {
        
        sqlite3_stmt *stmt;
        //sql语句
        NSString *sql=[NSString stringWithFormat:@"delete from cart_table  where pk_id =\"%i\"",bid];
        //将SQL语句放入sqlite3_stmt中
        int success = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
        if (success != SQLITE_OK) {
            NSLog(@"Error: 错误的删除语句");
            sqlite3_close(_database);
            return NO;
        }
        
        //这里的数字1，2，3代表第几个问号。这里只有1个问号，这是一个相对比较简单的数据库操作，真正的项目中会远远比这个复杂
        sqlite3_bind_int(stmt, 1, bid);
        //执行SQL语句。这里是更新数据库
        success = sqlite3_step(stmt);
        //释放statement
        sqlite3_finalize(stmt);
        
        //如果执行失败
        if (success == SQLITE_ERROR) {
            NSLog(@"Error: 删除失败");
            //关闭数据库
            sqlite3_close(_database);
            return NO;
        }
        //执行成功后依然要关闭数据库
        sqlite3_close(_database);
        return YES;
    }
    return NO;
}
/**删除所有数据*/
-(BOOL)deleteDataList{
    if ([self openDB]) {
        
        sqlite3_stmt *stmt;
        //sql语句
        NSString *sql=[NSString stringWithFormat:@"delete from cart_table"];
        //将SQL语句放入sqlite3_stmt中
        int success = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
        if (success != SQLITE_OK) {
            NSLog(@"Error: 错误的删除语句");
            sqlite3_close(_database);
            return NO;
        }
        
        //这里的数字1，2，3代表第几个问号。这里只有1个问号，这是一个相对比较简单的数据库操作，真正的项目中会远远比这个复杂
//        sqlite3_bind_int(stmt, 1, bid);
        //执行SQL语句。这里是更新数据库
        success = sqlite3_step(stmt);
        //释放statement
        sqlite3_finalize(stmt);
        
        //如果执行失败
        if (success == SQLITE_ERROR) {
            NSLog(@"Error: 删除失败");
            //关闭数据库
            sqlite3_close(_database);
            return NO;
        }
        //执行成功后依然要关闭数据库
        sqlite3_close(_database);
        return YES;
    }
    return NO;
}
@end
