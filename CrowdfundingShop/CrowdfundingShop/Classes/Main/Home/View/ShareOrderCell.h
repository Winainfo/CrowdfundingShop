//
//  ShareOrderCell.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/16.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
#import "ShareInfoModel.h"
//添加代理，用于评论和点赞的实现
@protocol CartCellDelegate <NSObject>

-(void)btnClick:(UITableViewCell *)cell andFlag:(int)flag andS_id:(NSString *)sid;

@end
@interface ShareOrderCell : UITableViewCell
/**用户头像*/
@property (weak, nonatomic) IBOutlet UIImageView *peopleImageView;
/**用户名*/
@property (weak, nonatomic) IBOutlet UIButton *peopleName;
/**时间*/
@property (weak, nonatomic) IBOutlet ARLabel *timeLabel;
/**标题*/
@property (weak, nonatomic) IBOutlet ARLabel *titleLabel;
/**内容*/
@property (weak, nonatomic) IBOutlet ARLabel *contentLabel;
/**商品图片*/
@property (weak, nonatomic) IBOutlet UIScrollView *goodsImageScroll;
/**点赞数*/
@property (weak, nonatomic) IBOutlet ARLabel *praiseLabel;
/**评论数*/
@property (weak, nonatomic) IBOutlet ARLabel *commentaryLabel;
@property (weak, nonatomic) IBOutlet UIButton *dianzaBtn;

@property (weak, nonatomic) IBOutlet UILabel *idLabel;

@property(assign,nonatomic)id<CartCellDelegate>delegate;
//赋值
-(void)addTheValue:(ShareInfoModel *)shareModel;
@end
