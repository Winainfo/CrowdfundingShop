//
//  MyCouldRecordCell.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/29.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
@interface MyCouldRecordCell : UITableViewCell
/**商品图片*/
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
/**商品名字*/
@property (weak, nonatomic) IBOutlet ARLabel *goodsTitleLabel;
/**获得者*/
@property (weak, nonatomic) IBOutlet UIButton *userNameBtn;
/**揭晓时间*/
@property (weak, nonatomic) IBOutlet ARLabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *view;
@end
