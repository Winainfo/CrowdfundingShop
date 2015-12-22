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
 *  商品名字
 */
@property (weak, nonatomic) IBOutlet ARLabel *goodsNameLabel;
/**
 *  时间
 */
@property (weak, nonatomic) IBOutlet ARLabel *timeLabel;

@end
