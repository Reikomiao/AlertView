//
//  RActionSheetViewController.m
//  ReikoSample
//
//  Created by 冯振玲 on 2017/2/13.
//  Copyright © 2017年 Reiko. All rights reserved.
//

#import "RActionSheetViewController.h"
#import "RActionSheetItem.h"
#import "RActionSheetTransition.h"
#import "UIView+Additions.h"
#import "RLabel.h"
#import "RButton.h"
#import "RActionSheetItemCell.h"
#import "NSString+UIColor.h"


static const CGFloat RActionSheetViewTitleViewHight = 50;
static const CGFloat RActionSheetViewMessageViewHight = 50;
static const CGFloat RActionSheetViewButtonViewHight = 45;
static const CGFloat RActionSheetViewMargin = 20;
static const CGFloat RActionSheetItemViewMargin = 25;

@interface RActionSheetViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)RLabel *titleLabel;
@property (nonatomic, strong)RLabel *messageLabel;
@property (nonatomic, strong)RButton *donebutton;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSArray <RActionSheetItem *> *itemsArray;
@property (nonatomic, strong)NSString *itemTitle;
@property (nonatomic, strong)NSString *itemMessage;

@end

@implementation RActionSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithTitle:(NSString *)title Message:(NSString *)message Items:(NSArray <RActionSheetItem *>*)items
{
    self = [super init];
    if (self) {
        [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        self.itemsArray = items;
        self.itemTitle = title;
        self.itemMessage = message;
    
    }
    return self;
}
- (instancetype)init{
    if (self= [super init]) {
        [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        
    }
    return self;
}
#pragma mark -- 设置界面
- (void)setUpView{
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 20);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake((kScreenWidth - RActionSheetViewWidthDefault) / 2, kScreenHeight, RActionSheetViewWidthDefault, RActionSheetViewHeightDefault) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.layer.cornerRadius = 5;
    self.collectionView.layer.masksToBounds = YES;
    [self.collectionView registerClass:[RActionSheetItemCell class] forCellWithReuseIdentifier:@"RActionSheetItemCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableViewHeader"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableViewFooter"];
    [self.view addSubview:self.collectionView];
    [self performSelector:@selector(actionAnimation) withObject:nil afterDelay:0.1f];

    
    
}
#pragma mark --
#pragma mark -- collectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    collectionView.height = [self returnActionItemViewHeight];
    
    return self.itemsArray.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RActionSheetItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RActionSheetItemCell" forIndexPath:indexPath];
    RActionSheetItem *itemModel = [self.itemsArray objectAtIndex:indexPath.row];
//    cell.contentView.backgroundColor = [UIColor cyanColor];
    cell.itemImageView.image = itemModel.image;
    cell.itemLabel.text = itemModel.title;

    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    RActionSheetItem *itemModel = [self.itemsArray objectAtIndex:indexPath.row];
    [self dismissViewControllerAnimated:YES completion:^{
        itemModel.handler();
    }];
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itemWidth = (self.collectionView.width - (2 * RActionSheetViewMargin + 2 * RActionSheetItemViewMargin))/ 3;
    return CGSizeMake(itemWidth,itemWidth + 20);
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    // 如果有title
    CGFloat hearderViewHeight = 0;
    if (self.itemTitle.length > 0) {
        hearderViewHeight += RActionSheetViewTitleViewHight;
    }
    if (self.itemMessage.length > 0) {
        hearderViewHeight += RActionSheetViewMessageViewHight;
    }
    return CGSizeMake(0, hearderViewHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(0, RActionSheetViewButtonViewHight);
    
}
// set footer and header
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    // 表头
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableViewHeader" forIndexPath:indexPath];
        if (self.itemTitle.length > 0) {
            self.titleLabel = [[RLabel alloc] initWithFrame:CGRectMake(0, 0, headerView.width, RActionSheetViewTitleViewHight)];
            self.titleLabel.text = self.itemTitle;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.font = [UIFont systemFontOfSize:20];
            [headerView addSubview:self.titleLabel];
        }
        if (self.itemMessage.length > 0) {
            self.messageLabel = [[RLabel alloc] initWithFrame:CGRectMake(0, self.titleLabel.bottom , headerView.width, RActionSheetViewMessageViewHight)];
            self.messageLabel.textAlignment = NSTextAlignmentCenter;
            self.messageLabel.text = self.itemMessage;
            [headerView addSubview:self.messageLabel];
        }
        return headerView;

        
    // 表尾
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableViewFooter" forIndexPath:indexPath];
        self.donebutton = [RButton buttonWithType:UIButtonTypeCustom];
        self.donebutton.frame = CGRectMake(15, 0, self.collectionView.width - 30, RActionSheetViewButtonViewHight);
        [self.donebutton setTitle:@"取消" forState:UIControlStateNormal];
        self.donebutton.backgroundColor = @"FC5079".color;
        self.donebutton.layer.masksToBounds = YES;
        self.donebutton.layer.cornerRadius = 5;
        [self.donebutton addTarget:self action:@selector(actionDoneButton:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:self.donebutton];
        
        return footerView;
    }
    return nil;
}


- (void)actionAnimation{
    [UIView animateWithDuration:0.1f animations:^{
        self.collectionView.top = kScreenHeight - [self returnActionItemViewHeight];
    }];
}
#pragma mark --取消按钮的点击事件
- (void)actionDoneButton:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:^{
        [UIView animateWithDuration:0.1f animations:^{
            self.collectionView.top = kScreenHeight;
        }];
    }];
}
#pragma mark --计算应该返回的高度
- (CGFloat)returnActionItemViewHeight{
    // 计算出返回的高度
    NSInteger itemLineNum = self.itemsArray.count / 3;
    if (self.itemsArray.count % 3 != 0) {
        itemLineNum ++;
    }
    CGFloat itemHeight = ((self.collectionView.width - (2 * RActionSheetViewMargin + 2 * RActionSheetItemViewMargin))/ 3) + 30;
    CGFloat actionSheetViewHeight = itemLineNum * itemHeight;
    if (self.itemTitle.length > 0) {
        actionSheetViewHeight += RActionSheetViewTitleViewHight;
    }
    if (self.itemMessage.length > 0) {
        actionSheetViewHeight += RActionSheetViewMessageViewHight;
    }
    actionSheetViewHeight += RActionSheetViewButtonViewHight + 30;
    if (actionSheetViewHeight >= kScreenHeight) {
        actionSheetViewHeight = kScreenHeight;
    }
    return actionSheetViewHeight;
}
#pragma mark --点击空白处回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.collectionView.frame];
    if (![path containsPoint:point]) {
        [self dismissViewControllerAnimated:YES completion:^{
            [UIView animateWithDuration:0.1f animations:^{
                self.collectionView.top = kScreenHeight;
            }];
        }];
    }
    
    
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
