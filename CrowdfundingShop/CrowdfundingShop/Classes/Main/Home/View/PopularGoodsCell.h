//
//  PopularGoodsCell.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/1.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
@interface PopularGoodsCell : UICollectionViewCell
/**
 *  商品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
/**
 *  价格
 */
@property (weak, nonatomic) IBOutlet ARLabel *priceLabel;
/**
 *  已参与
 */
@property (weak, nonatomic) IBOutlet ARLabel *peopleLabel1;
/**
 *  总需人次
 */
@property (weak, nonatomic) IBOutlet ARLabel *peopleLabel2;
/**
 *  剩余人次
 */
@property (weak, nonatomic) IBOutlet ARLabel *peopleLabel3;
/**
 *  进度条
 */
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@end
