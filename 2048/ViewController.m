//
//  ViewController.m
//  2048
//
//  Created by 张欣欣 on 2017/4/27.
//  Copyright © 2017年 zxx. All rights reserved.
//

#import "ViewController.h"
#import "MainView.h"
@interface ViewController ()

@property (nonatomic, strong) MainView *mainView;
/** 0~15tag */
@property (nonatomic, strong) NSMutableArray *numberArrM;
/** 展示的label */
@property (nonatomic, strong) NSMutableArray *showLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back"]];
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.offset(CGSizeMake(KWidth_Scale(250), KWidth_Scale(250)));
    }];
    if (self.mainView == nil) {
        self.mainView = [[MainView alloc]init];
        [self.view addSubview:self.mainView];
        [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.offset(CGSizeMake(KWidth_Scale(250), KWidth_Scale(250)));
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
