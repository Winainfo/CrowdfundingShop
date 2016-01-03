//
//  DoMyCouldRecordCell.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/1/4.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
@interface DoMyCouldRecordCell : UITableViewCell
/**图片*/
@property (weak, nonatomic) IBOutlet UIView *imagView;

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
@end
