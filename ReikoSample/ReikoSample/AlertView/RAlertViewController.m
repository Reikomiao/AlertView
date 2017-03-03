//
//  RAlertViewController.m
//  ReikoSample
//
//  Created by 冯振玲 on 2017/2/9.
//  Copyright © 2017年 Reiko. All rights reserved.
//

#import "RAlertViewController.h"
#import "UIView+Additions.h"
#import "NSString+UIColor.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define RAlertControllerMessageViewHeightMaxDefault kScreenHeight - 200
#define RAlertControllerAlertViewWidthtDefault kScreenWidth * 0.8

static CGFloat const RAlertControllerTitleViewHeightDefault = 40;
static CGFloat const RAlertControllerButtonViewHeightDefault = 50;
static CGFloat const RAlertControllerContainerMarginDefault = 10;
static CGFloat const RAlertControllerMessageViewHeightMinDefault = 50;
static CGFloat const RAlertControllerTextFieldHeightDefault = 40;
static CGFloat const RAlertControllerAlertViewHeightDefault = RAlertControllerTitleViewHeightDefault + RAlertControllerMessageViewHeightMinDefault + RAlertControllerButtonViewHeightDefault;
static CGFloat const RAlertControllerMessageTextFontDefault = 18;


@interface RAlertViewController ()
@property (nonatomic, strong)UIView *alertView;
@property (nonatomic, strong)RSubView *titleView;
@property (nonatomic, strong)RSubView *messageView;
@property (nonatomic, strong)RSubView *buttonView;

@property (nonatomic, strong)UIImageView *titleImageView;
@property (nonatomic, strong)UIImageView *messageImageView;
@property (nonatomic, strong)NSMutableArray *buttonArray;
@property (nonatomic, strong)NSMutableArray *buttonHandlerArray;

@property (nonatomic, strong)NSMutableArray *textFieldArray;
@property (nonatomic, strong)NSMutableArray *textFieldHandlerArray;

@end

@implementation RAlertViewController
#pragma mark
#pragma mark -- init
+ (instancetype)alertControllerWithTitle:(NSString *)titleString message:(NSString *)messageString{
    
    RAlertViewController *alertVC = [[RAlertViewController alloc] init];
    alertVC.titleString = titleString;
    alertVC.messageString = messageString;
    alertVC.titleLable.text = titleString;
    alertVC.messageLabel.text = messageString;
    return alertVC;
}



- (instancetype)init{
    if ([super init]) {
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        // TODO:设置不同的显示风格，默认为渐入
        [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self setUpView];
        self.touchBackgroundDismiss = NO;

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
    // Do any additional setup after loading the view.
}
#pragma mark
#pragma mark -- setUpView
- (void)setUpView{
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RAlertControllerAlertViewWidthtDefault, RAlertControllerAlertViewHeightDefault)];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = 5;
    _alertView = alertView;
    [self.view addSubview:alertView];
    
    _buttonArray = [NSMutableArray array];
    _buttonHandlerArray = [NSMutableArray array];
    
    _textFieldArray = [NSMutableArray array];
    _textFieldHandlerArray = [NSMutableArray array];
    
    RSubView *titleView = [[RSubView alloc] initWithFrame:CGRectMake(0, 0, _alertView.width, RAlertControllerTitleViewHeightDefault)];
    _titleView = titleView;
    [_alertView addSubview:titleView];
    
    RLabel *titleLabel = [[RLabel alloc] initWithFrame:CGRectZero];
    titleLabel.text = _titleString;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20];
    _titleLable = titleLabel;
    [titleView addSubview:titleLabel];
    
   
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:_titleImage];
    titleImageView.frame = CGRectZero;
    titleImageView.centerX = titleView.centerX;
    _titleImageView = titleImageView;
    [titleView addSubview:titleImageView];
    
    
    RSubView *messageView = [[RSubView alloc] initWithFrame:CGRectMake(0, titleView.bottom, _alertView.width, RAlertControllerMessageViewHeightMinDefault)];
    _messageView = messageView;
    [_alertView addSubview:messageView];
    
    RLabel *messageLabel = [[RLabel alloc] initWithFrame:CGRectZero];
    messageLabel.text = _messageString;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    messageLabel.font = [UIFont systemFontOfSize:RAlertControllerMessageTextFontDefault];
    _messageLabel = messageLabel;
    [messageView addSubview:messageLabel];
    
    RSubView *buttonView = [[RSubView alloc] initWithFrame:CGRectMake(0, messageView.bottom, _alertView.width, RAlertControllerButtonViewHeightDefault)];
    _buttonView = buttonView;
    [_alertView addSubview:buttonView];
  

}

- (void)drawView{
    if (_titleString.length != 0) {
        _titleLable.frame = CGRectMake(0, 0, _titleView.width, RAlertControllerTitleViewHeightDefault);
    }
    
    if (_titleImage) {
        _titleImageView.frame = CGRectMake(0, _titleLable.bottom, 50, 50);
        _titleImageView.centerX = _titleView.centerX;
    }
    
    _titleView.height =  _titleLable.height +  _titleImageView.height;
    
    if (_messageString.length != 0) {
        _messageLabel.frame = CGRectMake(RAlertControllerContainerMarginDefault, RAlertControllerContainerMarginDefault, _messageView.width - 2 * RAlertControllerContainerMarginDefault, _messageView.height - 2 * RAlertControllerContainerMarginDefault);
        _messageLabel.height = [self theHeightWithMessageLableText:self.messageString];
        _messageView.height = _messageLabel.height + RAlertControllerContainerMarginDefault * 2;
    }
    
    if (_middleView) {
        [_messageView removeAllSubviews];
        _messageView.height = _middleView.height;
        [_messageView addSubview:_middleView];
    }
    
    _messageView.top = _titleView.bottom;
    _buttonView.top = _messageView.bottom;
    _alertView.height = _titleView.height + _messageView.height + _buttonView.height;
    _alertView.center = self.view.center;

    
}
- (CGFloat)theHeightWithMessageLableText:(NSString *)text{

    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:RAlertControllerMessageTextFontDefault] forKey:NSFontAttributeName];
    CGRect frame = [text boundingRectWithSize:CGSizeMake(_messageLabel.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    if (CGRectGetHeight(frame) >= RAlertControllerMessageViewHeightMaxDefault) { // 已经超过等于最大值
        return RAlertControllerMessageViewHeightMaxDefault;
    }
    if (CGRectGetHeight(frame) > _messageLabel.height) {
        return CGRectGetHeight(frame);
    }
    return _messageLabel.height;
}
#pragma mark
#pragma mark -- setting and getting
-(void)setMessageString:(NSString *)messageString{
    _messageString = messageString;
    _messageLabel.text = messageString;
    [self drawView];
    
    
}
- (void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    _titleLable.text  = titleString;
    [self drawView];

}

- (void)setTitleImage:(UIImage *)titleImage{
    _titleImage = titleImage;
    _titleImageView.image = titleImage;
    [self drawView];

}

- (void)setMiddleView:(UIView *)middleView{
    _middleView = middleView;

    [self drawView];
}
#pragma mark
#pragma mark -- add tf and btn
- (void)addTextFieldWithHandler:(void (^)(UITextField *textField))handler
{
    
    UITextField *textField = [[UITextField alloc] init];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    handler(textField);
    [_messageView addSubview:textField];
    [_textFieldArray addObject:textField];
    [_textFieldHandlerArray addObject:handler];
    [self setTextFieldFrame];
    // FIXME:键盘挡住了输入框的情况
    
}
- (void)setTextFieldFrame{
    for (int i = 0; i < _textFieldArray.count; i ++) {
        UITextField *textField = _textFieldArray[i];
        textField.frame = CGRectMake(RAlertControllerContainerMarginDefault, _messageLabel.bottom + RAlertControllerContainerMarginDefault * i + i * RAlertControllerTextFieldHeightDefault, _messageView.width - 2 * RAlertControllerContainerMarginDefault, RAlertControllerTextFieldHeightDefault);
    }
    _messageView.height = (_textFieldArray.count * RAlertControllerTextFieldHeightDefault) + (_textFieldArray.count + 1) * RAlertControllerContainerMarginDefault + _messageLabel.bottom;
    _buttonView.top = _messageView.bottom;
    _alertView.height = _titleView.height + _messageView.height + _buttonView.height;
    _alertView.center = self.view.center;
    
    
}

- (void)addAtionButtonTitle:(NSString *)title Handle:(alertActionHandler)handler{
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.backgroundColor = @"#28BDDB".color;
    [doneButton setTitle:title forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
    doneButton.layer.cornerRadius = 5;
    doneButton.layer.masksToBounds = YES;
    [_buttonView addSubview:doneButton];
    [_buttonArray addObject:doneButton];
    [_buttonHandlerArray addObject:handler];
    [self setButtonFrame];
}

- (void)setButtonFrame{
    // FIXME:这设置的很违和
    if (_buttonArray.count == 1) {
        UIButton *button = _buttonArray[0];
        button.frame = CGRectMake(RAlertControllerContainerMarginDefault, 0, _alertView.width - 2 * RAlertControllerContainerMarginDefault, RAlertControllerButtonViewHeightDefault - RAlertControllerContainerMarginDefault);
        
    } else if (_buttonArray.count == 2){
        CGFloat buttonWidth = (_alertView.width - 3 * RAlertControllerContainerMarginDefault) / 2;
        CGFloat buttonLeft = RAlertControllerContainerMarginDefault * 2 + buttonWidth;
        UIButton *button1 = _buttonArray[0];
        UIButton *button2 = _buttonArray[1];
        button1.frame = CGRectMake(RAlertControllerContainerMarginDefault, 0, buttonWidth, RAlertControllerButtonViewHeightDefault - RAlertControllerContainerMarginDefault);
        button2.frame = CGRectMake(buttonLeft, 0, buttonWidth, RAlertControllerButtonViewHeightDefault - RAlertControllerContainerMarginDefault);
        button2.backgroundColor = @"#FC5079".color;
        
    } else {
        for (int i = 0; i < _buttonArray.count; i ++) {
            UIButton *button = _buttonArray[i];
            button.frame = CGRectMake(RAlertControllerContainerMarginDefault, RAlertControllerContainerMarginDefault * i + i * RAlertControllerButtonViewHeightDefault, _buttonView.width - 2 * RAlertControllerContainerMarginDefault, RAlertControllerButtonViewHeightDefault);
        }
        _buttonView.height = _buttonArray.count * (RAlertControllerContainerMarginDefault + RAlertControllerButtonViewHeightDefault);
        _alertView.height = _titleView.height + _messageView.height + _buttonView.height;
        _alertView.center = self.view.center;
        
        
    }
   
    

}
- (void)actionButton:(UIButton *)button{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    NSInteger index = [_buttonArray indexOfObject:button];
    alertActionHandler handler = _buttonHandlerArray[index];
    handler(button);
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.touchBackgroundDismiss) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self.view];
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.alertView.frame];
        if (![path containsPoint:point]) {
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }
        
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
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
