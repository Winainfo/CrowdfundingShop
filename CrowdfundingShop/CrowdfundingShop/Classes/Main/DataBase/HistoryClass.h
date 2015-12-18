//
//  TVClass.h
//  5.19考试
//
//  Created by ibokan on 15/5/19.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DB.h"

@interface HistoryClass : NSObject

@property(assign,nonatomic)int Hid;
@property(retain,nonatomic)NSString *Hname;


+(NSArray *)findall;//查询所有数据
//添加数据
+(void) insertHname:(NSString *)Hname;
//删除一条搜索历史
+(void) deleteHISTORY:(int)Hid;
//删除所有搜索历史
+(void) deleteAllHistory;

@end
