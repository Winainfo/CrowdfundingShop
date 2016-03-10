//
//  PersonalProfilesController.m
//  CrowdfundingShop
//  编辑个人资料
//  Created by 吴金林 on 16/1/4.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "PersonalProfilesController.h"
#import "UpdateNicknameController.h"
#import "AccountTool.h"
#import <UIImageView+WebCache.h>
#import "AFNetworking.h"
#define kScreen_Height      ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width       ([UIScreen mainScreen].bounds.size.width)
#define kScreen_Frame       (CGRectMake(0, 0 ,kScreen_Width,kScreen_Height))
@interface PersonalProfilesController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>{
    UIImagePickerController *pickerController;
     AFHTTPRequestOperationManager *manager;
}

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (assign,nonatomic) BOOL flag;

@end

@implementation PersonalProfilesController

//隐藏和显示底部标签栏
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"编辑个人资料";
    //导航栏右侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 30, 30);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    [self setExtraCellLineHidden:self.myTableView];
    //头像圆角
    self.userImageView.layer.cornerRadius=self.userImageView.frame.size.height/2.0;
    self.userImageView.layer.masksToBounds=YES;
    [self flagLogin];
    //初始化pickerController
    [self createData];
}

/**
 *  判断是否有登录
 */
-(void)flagLogin
{
    //沙盒路径
    AccountModel *account=[AccountTool account];
    if(account)
    {
        self.userNameLabel.text=account.username;
        self.userAutographLabel.text=[NSString stringWithFormat:@"%@",account.qianming];
//        self.userAutographLabel.text=account.qianming;
        //拼接图片网址·
        NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,account.img];
        //转换成url
        NSURL *imgUrl = [NSURL URLWithString:urlStr];
        [self.userImageView sd_setImageWithURL:imgUrl];
    }else
    {


    }
}
/**
 *  返回
 */
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
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
/**
 *  该方法在视图跳转时被触发
 *
 *  @param segue  <#segue description#>
 *  @param sender <#sender description#>
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"updateNickname"]) {
        id theSegue=segue.destinationViewController;
        [theSegue setValue:self.userNameLabel.text forKey:@"nickname"];
    }else if ([segue.identifier isEqualToString:@"updateAutograph"]){
        id theSegue=segue.destinationViewController;
        [theSegue setValue:self.userAutographLabel.text forKey:@"autograph"];
    }
}
/**
 *  初始化pickerController
 */
- (void)createData
{
    //初始化pickerController
    pickerController = [[UIImagePickerController alloc]init];
    pickerController.view.backgroundColor = [UIColor orangeColor];
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
}
/**
 *  修改头像
 *
 *  @param sender <#sender description#>
 */
- (IBAction)updateHeadClick:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册",@"图库", nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {//相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            NSLog(@"支持相机");
            [self makePhoto];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请在设置-->隐私-->相机，中开启本应用的相机访问权限！！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我知道了", nil];
            [alert show];
        }
    }else if (buttonIndex == 1){//相片
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            NSLog(@"支持相册");
            [self choosePicture];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请在设置-->隐私-->照片，中开启本应用的相机访问权限！！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我知道了", nil];
            [alert show];
        }
    }else if (buttonIndex == 2){//图册
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            NSLog(@"支持图库");
            [self pictureLibrary];
            //            [self presentViewController:picker animated:YES completion:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请在设置-->隐私-->照片，中开启本应用的相机访问权限！！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我知道了", nil];
            [alert show];
        }
    }else if (buttonIndex == 3){
        
    }
}
//跳转到imagePicker里
- (void)makePhoto
{
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:pickerController animated:YES completion:nil];
}
//跳转到相册
- (void)choosePicture
{
    pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:pickerController animated:YES completion:nil];
}
//跳转图库
- (void)pictureLibrary
{
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:pickerController animated:YES completion:nil];
}
//用户取消退出picker时候调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"%@",picker);
    [pickerController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//用户选中图片之后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSLog(@"相册：%s,info == %@",__func__,info);
    
    UIImage *userImage = [self fixOrientation:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    
    userImage = [self scaleImage:userImage toScale:0.3];
    
    [pickerController dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self.userImageView setImage:userImage];
    self.userImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.userImageView.clipsToBounds = YES;
    //照片上传
    [self upDateHeadIcon:userImage];
}

- (void)upDateHeadIcon:(UIImage *)photo
{
    //两种方式上传头像
    /*方式一：使用NSData数据流传图片*/
    NSString *imageURl = @"";
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"text/html"];
    [manager POST:imageURl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:UIImageJPEGRepresentation(photo, 1.0) name:@"text" fileName:@"test.jpg" mimeType:@"image/jpg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    /*方式二：使用Base64字符串传图片*/
    NSData *data = UIImageJPEGRepresentation(photo, 1.0);
    
    NSString *pictureDataString=[data base64Encoding];
    NSDictionary * dic  = @{@"verbId":@"modifyUserInfo",@"deviceType":@"ios",@"userId":@"",@"photo":pictureDataString,@"mobileTel":@""};
    [manager POST:@"" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"flag"] intValue] == 0) {
            
        }else{
            
        }
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          }];
}
//保存照片到沙盒路径(保存)
- (void)saveImage:(UIImage *)image name:(NSString *)iconName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //写入文件
    NSString *icomImage = iconName;
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", icomImage]];
    //沙盒路径
    AccountModel *account=[AccountTool account];
    account.img=filePath;
    [AccountTool saveAccount:account];
    [UIImagePNGRepresentation(image)writeToFile: filePath  atomically:YES];

}
//缩放图片
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"%@",NSStringFromCGSize(scaledImage.size));
    return scaledImage;
}
//修正照片方向(手机转90度方向拍照)
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end
