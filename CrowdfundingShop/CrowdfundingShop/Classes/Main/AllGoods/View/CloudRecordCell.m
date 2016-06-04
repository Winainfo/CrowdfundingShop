//
//  CloudRecordCell.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/11.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "CloudRecordCell.h"

@implementation CloudRecordCell

- (void)awakeFromNib {
    // Initialization code
    /**头像圆角*/
    self.peopleImageView.layer.cornerRadius=30.0;
    self.peopleImageView.layer.masksToBounds=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
