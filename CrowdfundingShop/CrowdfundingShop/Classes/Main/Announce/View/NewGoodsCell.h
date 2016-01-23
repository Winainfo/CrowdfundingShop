//
//  NewGoodsCell.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/9.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MZTimerLabel.h>
#import "ARLabel.h"
@interface NewGoodsCell : UITableViewCell
/**已揭晓view*/
@property (weak, nonatomic) IBOutlet UIView *view1;
/**图片框*/
@property (weak, nonatomic) IBOutlet UIView *imgView;
/**商品图片*/
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
/**获得者*/
@property (weak, nonatomic) IBOutlet ARLabel *nameLabel;
/**头像*/
@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;
/**参与人次*/
@property (weak, nonatomic) IBOutlet ARLabel *numLabel;
/**商品价格*/
@property (weak, nonatomic) IBOutlet ARLabel *priceLabel;
/**揭晓时间*/
@property (weak, nonatomic) IBOutlet ARLabel *timeLabel;
//正在揭晓
/**正在揭晓view*/
@property (weak, nonatomic) IBOutlet UIView *view2;
/**图片框*/
@property (weak, nonatomic) IBOutlet UIView *imgView2;
/**商品图片*/
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView2;
/**商品名字*/
@property (weak, nonatomic) IBOutlet ARLabel *goodsNameLabel;
/**商品价格*/
@property (weak, nonatomic) IBOutlet ARLabel *priceLabel2;
/**揭晓倒计时*/
@property (weak, nonatomic) IBOutlet ARLabel *timeLabel2;
@end
