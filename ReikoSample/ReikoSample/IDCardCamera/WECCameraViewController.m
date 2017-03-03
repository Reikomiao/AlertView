//
//  WECCameraViewController.m
//  Wecash
//
//  Created by 冯振玲 on 2016/10/26.
//  Copyright © 2016年 Wecash. All rights reserved.
//

#import "WECCameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define kTakeShootViewHeight 70
@interface WECCameraViewController ()<UIGestureRecognizerDelegate>


// AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
//@property (nonatomic, strong)UIImageView *bgImageView;
@property (nonatomic, strong) AVCaptureSession* session;

// 输入设备
@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;
// 照片输出流
@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;

// 预览图层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;

// 记录开始的缩放比例
@property(nonatomic,assign)CGFloat beginGestureScale;

// 最后的缩放比例
@property(nonatomic,assign)CGFloat effectiveScale;
@property(nonatomic, strong) UIView   *focusView;       // 聚焦动画
@property (assign, nonatomic)  BOOL isUsingFrontFacingCamera;

@end

@implementation WECCameraViewController

- (instancetype)initWithDelegate:(id<WECCustomViewControllerDelegate>)delegate IDCardType:(IDCardType)cardType{
    if (self = [super init]) {
        self.delegate = delegate;
        self.cardType = cardType;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (self.session) {
        
        [self.session startRunning];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubViews];
    self.effectiveScale = self.beginGestureScale = 1.0f;
    [self initAVCaptureSession];
    [self setUpGesture];// 设置焦距
    [self runFocusAnimation:self.focusView point:self.view.center];
    
    
}
- (void)addSubViews{
    // 拍照背景
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.userInteractionEnabled = YES;
    [self.view addSubview:bgImageView];

    for (NSLayoutAttribute i = NSLayoutAttributeLeft; i <= NSLayoutAttributeBottom; i++) {
        NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:bgImageView attribute:i relatedBy:NSLayoutRelationEqual toItem:self.view attribute:i multiplier:1 constant:0];
        [self.view addConstraint:c];
    }
   
//    self.bgImageView = bgImageView;
    // 拍摄区域
    UIView *takePhoneView = [[UIView alloc] init];
    [bgImageView addSubview:takePhoneView];
    
    NSLayoutConstraint *leftTakePhoneView = [NSLayoutConstraint constraintWithItem:takePhoneView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:bgImageView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *rightTakePhoneView = [NSLayoutConstraint constraintWithItem:takePhoneView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:bgImageView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *bottomTakePhoneView = [NSLayoutConstraint constraintWithItem:takePhoneView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bgImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *heightTakePhoneView = [NSLayoutConstraint constraintWithItem:takePhoneView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kTakeShootViewHeight];
    [bgImageView addConstraints:@[leftTakePhoneView,rightTakePhoneView,bottomTakePhoneView,heightTakePhoneView]];
    
    
    
    // 拍照按钮
    UIButton *takePhoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [takePhoneButton setImage:[UIImage imageNamed:@"takephotobutton"] forState:UIControlStateNormal];
    [takePhoneButton addTarget:self action:@selector(actionTakePhone:) forControlEvents:UIControlEventTouchUpInside];
    [takePhoneView addSubview:takePhoneButton];
   
    NSLayoutConstraint *heightTakePhoneButton = [NSLayoutConstraint constraintWithItem:takePhoneButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:55];
    NSLayoutConstraint *widthTakePhoneButton = [NSLayoutConstraint constraintWithItem:takePhoneButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:55];
    NSLayoutConstraint *centerXTakePhoneButton = [NSLayoutConstraint constraintWithItem:takePhoneButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:takePhoneView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerYTakePhoneButton = [NSLayoutConstraint constraintWithItem:takePhoneButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:takePhoneView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [takePhoneView addConstraints:@[heightTakePhoneButton,widthTakePhoneButton,centerXTakePhoneButton,centerYTakePhoneButton]];
    
    // 取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [takePhoneView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(actionCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    
    NSLayoutConstraint *centerYCancelButton = [NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:takePhoneButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
     NSLayoutConstraint *leftCancelButton = [NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:takePhoneView attribute:NSLayoutAttributeLeft multiplier:1 constant:15];
    [takePhoneView addConstraints:@[centerYCancelButton,leftCancelButton]];
   
    // 翻转
    UIButton *overturnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    overturnButton.hidden = YES;
    [overturnButton setTitle:@"翻转" forState:UIControlStateNormal];
    [takePhoneView addSubview:overturnButton];
    [overturnButton addTarget:self action:@selector(actionOverturnButton:) forControlEvents:UIControlEventTouchUpInside];
    
    NSLayoutConstraint *centerYOverturnButton = [NSLayoutConstraint constraintWithItem:overturnButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:takePhoneButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *rightOverturnButton = [NSLayoutConstraint constraintWithItem:overturnButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:takePhoneView attribute:NSLayoutAttributeRight multiplier:1 constant:-15];
    [takePhoneView addConstraints:@[centerYOverturnButton,rightOverturnButton]];
    
    // 提示文字
    UILabel *hintLable = [[UILabel alloc] init];
    hintLable.textColor = [UIColor whiteColor];
    hintLable.font = [UIFont systemFontOfSize:13];
    hintLable.textAlignment = NSTextAlignmentCenter;
    hintLable.transform = CGAffineTransformMakeRotation(M_PI/2);
    hintLable.translatesAutoresizingMaskIntoConstraints = NO;
    [bgImageView addSubview:hintLable];
    

    NSLayoutConstraint *centerYHintLable = [NSLayoutConstraint constraintWithItem:hintLable attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:bgImageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *centerXHintLable = [NSLayoutConstraint constraintWithItem:hintLable attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bgImageView attribute:NSLayoutAttributeLeft multiplier:1 constant:10];
    [bgImageView addConstraints:@[centerYHintLable,centerXHintLable]];
 
    switch (self.cardType) {
        case IDCardTypeForBack:
            bgImageView.image = [UIImage imageNamed:@"idback"];
            hintLable.text = @"请拍摄身份证反面，保持文字清晰";
            overturnButton.hidden = YES;

            break;
        case IDCardTypeForFront:{
            bgImageView.image = [UIImage imageNamed:@"idfront"];
            hintLable.text = @"请拍摄身份证正面，保持文字清晰";
            overturnButton.hidden = YES;

            break;
        }
        case IDCardTypeForHand:
            overturnButton.hidden = NO;
            break;
        default:
            break;
    }
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];


}
-(UIView *)focusView{
    if (_focusView == nil) {
        _focusView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 150, 150.0f)];
        _focusView.backgroundColor = [UIColor clearColor];
        _focusView.layer.borderColor = [UIColor blueColor].CGColor;
        _focusView.layer.borderWidth = 2.0f;
        _focusView.hidden = YES;
        [self.view addSubview:self.focusView];

    }
    return _focusView;
}
// 初始化相机
- (void)initAVCaptureSession{
    
    self.session = [[AVCaptureSession alloc] init];
    
    NSError *error;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    // 如果没有闪光灯就会崩溃，所以要判断一下
    if (device.hasFlash) {
    [device lockForConfiguration:nil];
    //设置闪光灯为自动
    [device setFlashMode:AVCaptureFlashModeAuto];
    [device unlockForConfiguration];
    }
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.previewLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view.layer addSublayer:self.previewLayer];
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
//    [self.view bringSubviewToFront:self.backView];;
}
// 拍照的按钮
- (void)actionTakePhone:(UIButton *)sender {
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput        connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:self.effectiveScale];
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer) {
            NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            //原始的图片
            UIImage *originalImage = [UIImage imageWithData:jpegData];
            if (_delegate && [_delegate respondsToSelector:@selector(photoCapViewController:didFinishDismissWithImage:)]) {
                [_delegate photoCapViewController:self didFinishDismissWithImage:originalImage];
            }
            
        }else{
          
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
            
        });
    }];
    
}
- (void)actionOverturnButton:(UIButton *)button{
    AVCaptureDevicePosition desiredPosition;
    if (self.isUsingFrontFacingCamera){
        desiredPosition = AVCaptureDevicePositionBack;
    }else{
        desiredPosition = AVCaptureDevicePositionFront;
    }
    
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            [self.previewLayer.session beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in self.previewLayer.session.inputs) {
                [[self.previewLayer session] removeInput:oldInput];
            }
            [self.previewLayer.session addInput:input];
            [self.previewLayer.session commitConfiguration];
            break;
        }
    }
    
    self.isUsingFrontFacingCamera = !self.isUsingFrontFacingCamera;

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}
// 取消按钮
- (void)actionCancelButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma 创建手势
- (void)setUpGesture{
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinch.delegate = self;
    [self.view addGestureRecognizer:pinch];
}
#pragma mark gestureRecognizer delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}
//缩放手势 用于调整焦距
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:self.view];
        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
        if ( ! [self.previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    if ( allTouchesAreOnThePreviewLayer ) {
        
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0){
            self.effectiveScale = 1.0;
        }
        
        CGFloat maxScaleAndCropFactor = [[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        
        if (self.effectiveScale > maxScaleAndCropFactor)
            self.effectiveScale = maxScaleAndCropFactor;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
        
    }
    
}
#pragma mark - 聚焦
-(void)tapAction:(UIGestureRecognizer *)tap{
    if ([self.videoInput.device isFocusPointOfInterestSupported]) {
        CGPoint point = [tap locationInView:self.view];
        [self runFocusAnimation:self.focusView point:point];
        CGPoint focusPoint = [self.previewLayer captureDevicePointOfInterestForPoint:point];
        [self focusAtPoint:focusPoint];
    }
}

// 聚焦动画
-(void)runFocusAnimation:(UIView *)view point:(CGPoint)point{
    view.center = point;
    view.hidden = NO;
    [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
    }completion:^(BOOL complete) {
        double delayInSeconds = 0.5f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            view.hidden = YES;
            view.transform = CGAffineTransformIdentity;
        });
    }];
}

// 聚焦
- (void)focusAtPoint:(CGPoint)point {
    AVCaptureDevice *device = self.videoInput.device;
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.focusPointOfInterest = point;
            device.focusMode = AVCaptureFocusModeAutoFocus;
            [device unlockForConfiguration];
        }
        else{
//            [self showError:error];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    if (self.session) {
        [self.session stopRunning];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
