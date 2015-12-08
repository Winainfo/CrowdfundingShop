//
//  NewGoodsCell.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/9.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "NewGoodsCell.h"

@implementation NewGoodsCell

- (void)awakeFromNib {
    self.imgView.layer.borderWidth=0.5;
    self.imgView.layer.borderColor=[[UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0]CGColor];
    /**圆角*/
    [[self.imgView layer]setCornerRadius:2.0];
    self.faceImageView.layer.cornerRadius=25.0;
    self.faceImageView.layer.masksToBounds=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
