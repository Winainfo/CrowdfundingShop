//
//  NewGoodsCell.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/9.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
@interface NewGoodsCell : UITableViewCell
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

@end
