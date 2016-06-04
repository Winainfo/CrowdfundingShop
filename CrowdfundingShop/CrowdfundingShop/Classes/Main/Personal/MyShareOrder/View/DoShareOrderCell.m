//
//  DoShareOrderCell.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/1/3.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "DoShareOrderCell.h"

@implementation DoShareOrderCell

- (void)awakeFromNib {
    self.goodsImageView.layer.borderWidth=0.5;
    self.goodsImageView.layer.borderColor=[[UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0]CGColor];
    /**圆角*/
    [[self.goodsImageView layer]setCornerRadius:2.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
