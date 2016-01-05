//
//  DBManager.h
//  PickerDemo
//
//  Created by dev1 on 15/12/15.
//  Copyright © 2015年 demo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

+ (instancetype)sharedDBManager;

- (void)openDB;

- (void)closeDB;

- (NSArray *) allData;

- (void) disposeProData;
//- (void) disposeCityData;
//- (void) disposeZoneData;

@end
