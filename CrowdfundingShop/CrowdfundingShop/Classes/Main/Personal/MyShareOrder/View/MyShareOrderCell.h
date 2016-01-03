//
//  MyShareOrderCell.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/30.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
@interface MyShareOrderCell : UITableViewCell
/**商品图片*/
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
/**商品标题*/
@property (weak, nonatomic) IBOutlet ARLabel *goodsTitleLabel;
/**幸运号码*/
@property (weak, nonatomic) IBOutlet ARLabel *numLabel;
/**揭晓时间*/
@property (weak, nonatomic) IBOutlet ARLabel *timeLabel;
@end
