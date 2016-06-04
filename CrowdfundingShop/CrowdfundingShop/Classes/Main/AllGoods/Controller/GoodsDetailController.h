//
//  GoodsDetailController.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/11.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
#import "Database.h"
#import "CartModel.h"
@interface GoodsDetailController : UITableViewController
/**商品图片*/
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
/**商品名字*/
@property (weak, nonatomic) IBOutlet ARLabel *goodsNameLabel;
/**商品描述*/
@property (weak, nonatomic) IBOutlet ARLabel *goodsDescLabel;
/**进度条*/
@property (weak, nonatomic) IBOutlet UIProgressView *goodsProgressView;
/**已参与*/
@property (weak, nonatomic) IBOutlet ARLabel *goodsLabel1;
/**总需人次*/
@property (weak, nonatomic) IBOutlet ARLabel *goodsLabel2;
/**剩余人次*/
@property (weak, nonatomic) IBOutlet ARLabel *goodsLabel3;
/**商品晒单次数*/
@property (weak, nonatomic) IBOutlet ARLabel *goodsNumLabel;
/**获得者头像*/
@property (weak, nonatomic) IBOutlet UIImageView *peopleImageView;
/**获得者电话号码*/
@property (weak, nonatomic) IBOutlet ARLabel *peoplePhoneLabel;
/**获得者所在城市*/
@property (weak, nonatomic) IBOutlet ARLabel *peopleCityLabel;
/**商品揭晓时间*/
@property (weak, nonatomic) IBOutlet ARLabel *timeLabel1;
/**商品购买时间*/
@property (weak, nonatomic) IBOutlet ARLabel *timeLabel2;
/**用户云购码*/
@property (weak, nonatomic) IBOutlet ARLabel *numberLabel;

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

/**商品ID*/
@property (retain,nonatomic) NSString *gID;
@property (retain,nonatomic)NSDictionary *dic;
@end
