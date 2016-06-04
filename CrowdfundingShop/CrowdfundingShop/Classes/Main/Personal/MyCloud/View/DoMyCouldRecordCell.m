//
//  DoMyCouldRecordCell.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/1/4.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "DoMyCouldRecordCell.h"

@implementation DoMyCouldRecordCell

- (void)awakeFromNib {
    self.imagView.layer.borderWidth=0.5;
    self.imagView.layer.borderColor=[[UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0]CGColor];
    /**圆角*/
    [[self.imagView layer]setCornerRadius:2.0];
    //更改进度条高度
    self.ProgressView.transform=CGAffineTransformMakeScale(1.0f, 2.0f);
    //设置进度值并动画显示
    [self.ProgressView setProgress:0.7 animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
