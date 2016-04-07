//
//  AllGoodsCell.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/7.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "AllGoodsCell.h"
@implementation AllGoodsCell

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
/**
 *  添加购物车
 *
 *  @param sender <#sender description#>
 */
- (IBAction)addCartClick:(UIButton *)sender {
    //调用代理
    [self.delegate btnClick:self andFlag:(int)sender.tag];
}

-(void)updateConstraints{
    [super updateConstraints];
    if (IS_IPHONE_4_OR_LESS) {
        self.progressLeading.constant=110;
    }else if(IS_IPHONE_6){
        self.progressLeading.constant=165;
    }else if(IS_IPHONE_6P){
        self.progressLeading.constant=205;
    }else{
        self.progressLeading.constant=110;
    }
}

@end
