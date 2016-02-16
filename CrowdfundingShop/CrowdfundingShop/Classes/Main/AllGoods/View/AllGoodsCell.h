//
//  AllGoodsCell.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/7.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
//添加代理，用于按钮加减的实现
@protocol CartCellDelegate <NSObject>

-(void)btnClick:(UITableViewCell *)cell andFlag:(int)flag;

@end
@interface AllGoodsCell : UITableViewCell
/**图片*/
@property (weak, nonatomic) IBOutlet UIView *imagView;
/**限购图标*/
@property (weak, nonatomic) IBOutlet UIImageView *limitImageVIew;
/**商品图片*/
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
/**商品名称*/
@property (weak, nonatomic) IBOutlet ARLabel *goodsLabel;
/**商品价格*/
@property (weak, nonatomic) IBOutlet ARLabel *goodsPriceLabel;
/**已参与*/
@property (weak, nonatomic) IBOutlet ARLabel *goodsLabel1;
/**总需人次*/
@property (weak, nonatomic) IBOutlet ARLabel *goodsLabel2;
/**剩余*/
@property (weak, nonatomic) IBOutlet ARLabel *goodsLabel3;
/**进度条*/
@property (weak, nonatomic) IBOutlet UIProgressView *ProgressView;
@property(assign,nonatomic)id<CartCellDelegate>delegate;
@end
