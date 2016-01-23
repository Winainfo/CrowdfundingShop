//
//  ShareOrderCell.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/16.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "ShareOrderCell.h"
#import "RequestData.h"
@implementation ShareOrderCell


- (void)awakeFromNib {
    self.peopleImageView.layer.cornerRadius=25.0;
    self.peopleImageView.layer.masksToBounds=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/**
 *  点赞
 *
 *  @param sender <#sender description#>
 */
- (IBAction)dianza:(UIButton *)sender {
    int i= [self.praiseLabel.text intValue];
    self.praiseLabel.text=[NSString stringWithFormat:@"%i",++i];
    self.dianzaBtn.enabled=NO;
    [self. dianzaBtn setImage:[UIImage imageNamed:@"share_order_heart_select"] forState:UIControlStateNormal];
     NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.idLabel.text,@"sd_id",nil];
    [RequestData dianZanSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
        NSLog(@"%@",data);
    }];
//    //调用代理
//    [self.delegate btnClick:self andFlag:(int)sender.tag];
}
/**
 *  <#Description#>
 *
 *  @param sender <#sender description#>
 */
- (IBAction)pinglun:(UIButton *)sender {
    [self.delegate btnClick:self andFlag:(int)sender.tag andS_id:self.idLabel.text];
}

/**
 *  分享代理
 *
 *  @param sender <#sender description#>
 */
- (IBAction)shareClick:(UIButton *)sender {
        [self.delegate btnClick:self andFlag:(int)sender.tag andS_id:self.idLabel.text];
}
@end
