//
//  ViewController.m
//  ReikoSample
//
//  Created by 冯振玲 on 2017/1/6.
//  Copyright © 2017年 Reiko. All rights reserved.
//

#import "ViewController.h"
#import "RAlertViewController.h"
#import "UIView+Additions.h"
#import "RActionSheetViewController.h"
#import "RActionSheetItem.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *dataArray;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = @[@"普通弹框1",@"普通弹框2",@"带图弹框",@"文字自适应",@"自定义弹框",@"带UITextField弹框",@"",@"actionsheet-3",@"actionsheet-5"];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.tableView];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.dataArray[indexPath.row];
    if ([title isEqualToString:@"普通弹框1"]) {
        
        RAlertViewController *alertVC = [RAlertViewController alertControllerWithTitle:@"提示" message:@"点击了普通弹框-运用类方法初始化"];
        [alertVC addAtionButtonTitle:@"确定" Handle:^(UIButton *sender) {
            
            NSLog(@"点击了确定");
            
        }];
        [alertVC addAtionButtonTitle:@"取消" Handle:^(UIButton *sender) {
            NSLog(@"点击了取消");
            
        }];
        
        [self presentViewController:alertVC animated:YES completion:nil];
    }else if ([title isEqualToString:@"普通弹框2"]){
        RAlertViewController *alertVC = [[RAlertViewController alloc] init];
        alertVC.titleString = @"提示";
        alertVC.messageString = @"点击了普通弹框-运用init方法初始化";
        [alertVC addAtionButtonTitle:@"确定" Handle:^(UIButton *sender) {
            
            NSLog(@"点击了确定");
            
        }];
        [alertVC addAtionButtonTitle:@"取消" Handle:^(UIButton *sender) {
            NSLog(@"点击了取消");
            
        }];
        [alertVC addAtionButtonTitle:@"╮(╯_╰)╭" Handle:^(UIButton *sender) {
            NSLog(@"点击了╮(╯_╰)╭");
            
        }];
        [self presentViewController:alertVC animated:YES completion:nil];

        
    }else if ([title isEqualToString:@"带图弹框"]){
        RAlertViewController *alertVC = [[RAlertViewController alloc] init];
//        alertVC.titleString = @"提示";
        alertVC.titleImage = [UIImage imageNamed:@"takephotobutton"];
        alertVC.messageString = @"点击了带图片弹框-运用init方法初始化";
        [alertVC addAtionButtonTitle:@"取消" Handle:^(UIButton *sender) {
            
            NSLog(@"点击了取消");
            
        }];
        [self presentViewController:alertVC animated:YES completion:nil];

    }else if ([title isEqualToString:@"文字自适应"]){
        RAlertViewController *alertVC = [[RAlertViewController alloc] init];
                alertVC.titleString = @"提示";
        alertVC.titleImage = [UIImage imageNamed:@"heart"];
        alertVC.messageString = @"当你看着这么多的星星时，你会有什么感觉？”小国王问。“我感觉自己很渺小，也很不重要。”我说，“我感觉自己变得和你一样小——甚至更小。我感觉这个世界是如此之大，而我不过是沧海一粟。”“你知道我是怎么想的吗？”小国王说，“此时此刻，我感觉自己变得很大，而且我还在一直变大、变大，变得和浩瀚的宇宙一样大。但我并不是像气球一样被吹大的，因为那样一定会在某个时刻爆掉。我所感觉的变大，是一种很轻松很自然的感觉，没有任何被拉伸的不适感。仿佛我就是空气，一股四散漂流的空气。最后，我不仅仅是宇宙的一部分，我就是宇宙的全部，所有的星星都与我同在。你能想象这种感觉吗？”";
        [alertVC addAtionButtonTitle:@"取消" Handle:^(UIButton *sender) {
            
            NSLog(@"点击了取消");
            
        }];
        [self presentViewController:alertVC animated:YES completion:nil];
        
    }else if ([title isEqualToString:@"自定义弹框"]){
        RAlertViewController *alertVC = [[RAlertViewController alloc] init];
        alertVC.titleString = @"提示";
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.frame), 30)];
        lable.text = @"自定义中部的内容";
        [view addSubview:lable];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(lable.frame), 50, 50)];
        imageView.image = [UIImage imageNamed:@"heart"];
        [view addSubview:imageView];
        alertVC.middleView = view;
        
        [alertVC addAtionButtonTitle:@"取消" Handle:^(UIButton *sender) {
            
            NSLog(@"点击了取消");
            
        }];
        [self presentViewController:alertVC animated:YES completion:nil];
        
    }else if ([title isEqualToString:@"带UITextField弹框"]){
        RAlertViewController *alertVC = [[RAlertViewController alloc] init];
        alertVC.titleString = @"登录";
//        alertVC.messageString = @"请输入下面信息";
        [alertVC addTextFieldWithHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入手机号";
        }];
        [alertVC addTextFieldWithHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入密码";
        }];
        [alertVC addTextFieldWithHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入验证码";
        }];
        [alertVC addAtionButtonTitle:@"取消" Handle:^(UIButton *sender) {
            
            NSLog(@"点击了取消");
            
        }];
        [self presentViewController:alertVC animated:YES completion:nil];
      
        
    }else if ([title isEqualToString:@"actionsheet-3"]){
        RActionSheetItem *item1 = [RActionSheetItem actionSheetItemWithTitle:@"微博分享" image:[UIImage imageNamed:@"chat"] handler:^{
            NSLog(@"微博分享");
            
        }];
        RActionSheetItem *item2 = [RActionSheetItem actionSheetItemWithTitle:@"微信分享" image:[UIImage imageNamed:@"weibo"] handler:^{
            NSLog(@"微信分享");
            
        }];
        RActionSheetItem *item3 = [RActionSheetItem actionSheetItemWithTitle:@"朋友圈分享" image:[UIImage imageNamed:@"friend"] handler:^{
            NSLog(@"朋友圈分享");
            
        }];
        

        RActionSheetViewController *actionSheetVC = [[RActionSheetViewController alloc] initWithTitle:@"选择分享" Message:nil Items:@[item1,item2,item3]];
        [self presentViewController:actionSheetVC animated:YES completion:nil];


  }else if ([title isEqualToString:@"actionsheet-5"]){
   
      RActionSheetItem *item1 = [RActionSheetItem actionSheetItemWithTitle:@"微博分享" image:[UIImage imageNamed:@"heart"] handler:^{
          NSLog(@"微博分享");
          
      }];
      
      RActionSheetViewController *actionSheetVC = [[RActionSheetViewController alloc] initWithTitle:@"选择分享" Message:@"...翻牌子辣..." Items:@[item1,item1,item1,item1,item1,item1,item1,item1,item1,item1,item1,item1,item1,item1,item1,item1,item1,item1]];
      [self presentViewController:actionSheetVC animated:YES completion:nil];
    
}
}
-(void)photoCapViewController:(UIViewController *)viewController didFinishDismissWithImage:(UIImage *)image{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
