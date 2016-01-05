//
//  City.h
//  PickerDemo
//
//  Created by dev1 on 15/12/15.
//  Copyright © 2015年 demo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject<NSCopying>

@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *citySort;
@property (nonatomic, strong) NSMutableArray *zones;


@end
