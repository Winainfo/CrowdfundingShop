//
//  ShareOrderCell.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/16.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "ShareOrderCell.h"

@implementation ShareOrderCell

- (void)awakeFromNib {
    self.peopleImageView.layer.cornerRadius=25.0;
    self.peopleImageView.layer.masksToBounds=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
