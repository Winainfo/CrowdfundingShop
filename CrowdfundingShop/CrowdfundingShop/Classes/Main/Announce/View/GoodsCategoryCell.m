//
//  GoodsCategoryCell.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/15.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "GoodsCategoryCell.h"

@implementation GoodsCategoryCell

- (void)awakeFromNib {
    _ifSelected=NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
