//
//  HistoryTableViewCell.h
//  AlayiShopDemo
//
//  Created by ibokan on 15/7/12.
//  Copyright (c) 2015年 kolin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"

@interface HistoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet ARLabel *foodName;
@property (assign,nonatomic)int cellId;

@end
