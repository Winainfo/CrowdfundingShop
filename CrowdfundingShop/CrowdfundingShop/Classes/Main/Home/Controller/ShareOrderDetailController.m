//
//  ShareOrderDetailController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/21.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "ShareOrderDetailController.h"
#import "CommentaryCell.h"
//获得当前屏幕宽高点数（非像素）
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
@interface ShareOrderDetailController ()
@property (nonatomic, strong) UITableViewCell *prototypeCell;
/**评论数组*/
@property(retain,nonatomic) NSArray *contentArray;
@property (weak, nonatomic) IBOutlet UIView *myView;

@end

@implementation ShareOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myView.layer.cornerRadius=3.0;
    self.myView.layer.masksToBounds=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
/**
 *  去掉多余的分割线
 *
 *  @param tableView <#tableView description#>
 */
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark - 表格代理
@end
