//
//  shopCartCell.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/27.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "shopCartCell.h"
#import "CartModel.h"
#import "Database.h"
@implementation shopCartCell

- (void)awakeFromNib {
    self.goodsImageView.layer.borderWidth=0.5;
    self.goodsImageView.layer.borderColor=[[UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0]CGColor];
    /**圆角*/
    [[self.goodsImageView layer]setCornerRadius:2.0];
    
//    //代理监听
//    self.numTextField.delegate=self;
//    // 二 添加文本框改变事件
//    [self.numTextField addTarget:self action:@selector(textChange) forControlEvents:
//     UIControlEventEditingChanged];
//    // 三 添加文本框改变通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:nil];
}


//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
//replacementString:(NSString *)string {
//    
//    NSLog(@"调用了代理方法");
//    
//    return YES;    //如果NO就不会显示文本内容
//    
//}
//
//- (void)textChange {
//    self.goodsPriceLabel.text=[NSString stringWithFormat:@"¥%@",self.numTextField.text];
//}
//
//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    //移除监听
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/**
 *  添加数量
 *
 *  @param sender <#sender description#>
 */
- (IBAction)addClick:(UIButton *)sender {
    //调用代理
    [self.delegate btnClick:self andFlag:(int)sender.tag];
}
/**
 *  减少数量
 *
 *  @param sender <#sender description#>
 */
- (IBAction)subClick:(UIButton *)sender {
    //调用代理
    [self.delegate btnClick:self andFlag:(int)sender.tag];
}

@end
