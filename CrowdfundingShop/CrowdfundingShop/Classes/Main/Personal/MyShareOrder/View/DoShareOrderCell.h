//
//  DoShareOrderCell.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/1/3.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
@interface DoShareOrderCell : UITableViewCell
/**商品图片*/
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
/**商品标题*/
@property (weak, nonatomic) IBOutlet ARLabel *goodsTitleLabel;
/**揭晓时间*/
@property (weak, nonatomic) IBOutlet ARLabel *timeLabel;
@end
