//
//  Province.h
//  PickerDemo
//
//  Created by dev1 on 15/12/15.
//  Copyright © 2015年 demo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Province : NSObject<NSCopying>

@property (nonatomic, copy) NSString *proName;
@property (nonatomic, copy) NSString *proSort;
@property (nonatomic, strong) NSMutableArray *citys;

@end
