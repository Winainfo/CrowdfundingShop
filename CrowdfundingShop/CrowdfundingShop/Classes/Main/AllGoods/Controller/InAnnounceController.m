//
//  InAnnounceController.m
//  CrowdfundingShop
//  正在揭晓
//  Created by 吴金林 on 15/12/13.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "InAnnounceController.h"
#import "ARLabel.h"
@interface InAnnounceController ()
/**商品图片*/
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
/**商品名字*/
@property (weak, nonatomic) IBOutlet ARLabel *goodsNameLabel;
/**商品描述*/
@property (weak, nonatomic) IBOutlet ARLabel *goodsDescLabel;
/**进度条*/
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
/**已参与次数*/
@property (weak, nonatomic) IBOutlet ARLabel *num1Label;
/**总需人次*/
@property (weak, nonatomic) IBOutlet ARLabel *num2Label;
/**剩余人次*/
@property (weak, nonatomic) IBOutlet ARLabel *num3Label;

@end

@implementation InAnnounceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.goodsImageView.layer.borderWidth=0.5;
    self.goodsImageView.layer.borderColor=[[UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0]CGColor];
    /**圆角*/
    [[self.goodsImageView layer]setCornerRadius:2.0];
    //更改进度条高度
    self.progressView.transform=CGAffineTransformMakeScale(1.0f, 2.0f);
    //设置进度值并动画显示
    [self.progressView setProgress:1.0 animated:YES];
}



@end
