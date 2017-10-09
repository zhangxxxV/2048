//
//  MainView.m
//  2048
//
//  Created by zxx on 2017/4/27.
//  Copyright © 2017年 zxx. All rights reserved.
//

#import "MainView.h"

@interface MainView ()

/** frame集合 */
@property (nonatomic, strong) NSMutableArray *rectArrM;
/** 未被使用的frame */
@property (nonatomic, strong) NSMutableArray *noOccupyFrame;
/** label集合 */
@property (nonatomic, strong) NSMutableArray *labelArrM;
/** 正在显示的label */
@property (nonatomic, strong) NSMutableArray *showLabelArrM;

@end


@implementation MainView

- (instancetype)init{
    self = [super init];
    if (self) {
        for (int i = 0; i<16; i++) {
            [self setLabelWithIndex:i];
        }
        UILabel *label1 = self.labelArrM.firstObject;
        label1.tag = arc4random()%self.rectArrM.count;
        label1.text = @"2";
        label1.hidden = NO;
        label1.frame = [self.rectArrM[label1.tag] CGRectValue];
        [self addSubview:label1];
        [self.labelArrM removeObject:label1];
        [self.showLabelArrM addObject:label1];
        [self.noOccupyFrame removeObject:self.rectArrM[label1.tag]];
        
        UILabel *label2 = self.labelArrM.firstObject;
        NSInteger index2 = arc4random()%self.noOccupyFrame.count;
        for (int i = 0; i<self.rectArrM.count; i++) {
            if ([self.rectArrM[i] isEqual:self.noOccupyFrame[index2]]) {
                label2.tag = i;
            }
        }
        label2.text = @"2";
        label2.hidden = NO;
        label2.frame = [self.noOccupyFrame[index2] CGRectValue];
        [self addSubview:label2];
        [self.labelArrM removeObject:label2];
        [self.showLabelArrM addObject:label2];
        [self.noOccupyFrame removeObject:self.noOccupyFrame[index2]];
        [self setSwipeGestureRecognizer];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(NSMutableArray *)rectArrM{
    if (_rectArrM == nil) {
        _rectArrM = [NSMutableArray array];
        for (int i = 0; i<16; i++) {
            CGRect rect = CGRectMake(KWidth_Scale(10)+KWidth_Scale(60)*(i%4), KWidth_Scale(10)+KWidth_Scale(60)*(i/4), KWidth_Scale(50), KWidth_Scale(50));
            [_rectArrM addObject:[NSValue valueWithCGRect:rect]];
        }
    }
    return _rectArrM;
}
-(NSMutableArray *)labelArrM{
    if (_labelArrM == nil) {
        _labelArrM = [NSMutableArray array];
    }
    return _labelArrM;
}
-(NSMutableArray *)noOccupyFrame{
    if (_noOccupyFrame == nil) {
        _noOccupyFrame = [NSMutableArray array];
        for (int i = 0; i<16; i++) {
            CGRect rect = CGRectMake(KWidth_Scale(10)+KWidth_Scale(60)*(i%4), KWidth_Scale(10)+KWidth_Scale(60)*(i/4), KWidth_Scale(50), KWidth_Scale(50));
            [_noOccupyFrame addObject:[NSValue valueWithCGRect:rect]];
        }
    }
    return _noOccupyFrame;
}
-(NSMutableArray *)showLabelArrM{
    if (_showLabelArrM == nil) {
        _showLabelArrM = [NSMutableArray array];
    }
    return _showLabelArrM;
}
-(void)setSwipeGestureRecognizer{
    // 3. 轻扫手势
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:swipeRight];
    [self addGestureRecognizer:swipeLeft];
    [self addGestureRecognizer:swipeUp];
    [self addGestureRecognizer:swipeDown];
}
-(void)setLabelWithIndex:(NSInteger)index{
    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.tag = index;
    label.backgroundColor = UIColorFromRGB(0xF0E8E2);
    label.hidden = YES;
    label.layer.cornerRadius = 5.0;
    label.layer.masksToBounds = YES;
    [self.labelArrM addObject:label];
}

// 轻扫手势
- (void)swipeAction:(UISwipeGestureRecognizer *)recognizer {
    __block BOOL isNewLabel = 0;
    NSInteger index = 0;
    //给self的子控件label排序，使靠近边缘的label在子控件数组的前面
    switch (recognizer.direction) {
        case UISwipeGestureRecognizerDirectionRight:
        {
            for (int i = 3; i>=0; i--) {
                for (UILabel *label in self.showLabelArrM) {
                    if (label.tag%4 == i) {
                        [self insertSubview:label atIndex:index];
                        index ++;
                    }
                }
            }
            break;
        }
        case UISwipeGestureRecognizerDirectionLeft:
        {
            for (int i = 0; i<4; i++) {
                for (UILabel *label in self.showLabelArrM) {
                    if (label.tag%4 == i) {
                        [self insertSubview:label atIndex:index];
                        index ++;
                    }
                }
            }
            break;
        }
        case UISwipeGestureRecognizerDirectionUp:
        {
            for (int i = 0; i<4; i++) {
                for (UILabel *label in self.showLabelArrM) {
                    if (label.tag/4 == i) {
                        [self insertSubview:label atIndex:index];
                        index ++;
                    }
                }
            }
            break;
        }
        case UISwipeGestureRecognizerDirectionDown:
        {
            for (int i = 3; i>=0; i--) {
                for (UILabel *label in self.showLabelArrM) {
                    if (label.tag/4 == i) {
                        [self insertSubview:label atIndex:index];
                        index ++;
                    }
                }
            }
            break;
        }
        default:
            break;
    }
    for (UILabel *label in self.subviews) {
         index = 0;
        NSInteger tag = 0;
        [self.noOccupyFrame addObject:[NSValue valueWithCGRect:label.frame]];
        //确定label移动的位置frame
        switch (recognizer.direction) {
            case UISwipeGestureRecognizerDirectionRight:
            {
                int a = (int)label.tag/4;
                if ([self.noOccupyFrame containsObject:self.rectArrM[a*4+3]]) {
                    index = a*4+3;
                }else if ([self.noOccupyFrame containsObject:self.rectArrM[a*4+2]]){
                    index = a*4+2;
                }else if ([self.noOccupyFrame containsObject:self.rectArrM[a*4+1]]){
                    index = a*4+1;
                }else{
                    index = a*4+0;
                }
                break;
            }
            case UISwipeGestureRecognizerDirectionLeft:
            {
                int a = (int)label.tag/4;
                if ([self.noOccupyFrame containsObject:self.rectArrM[a*4+0]]) {
                    index = a*4+0;
                }else if ([self.noOccupyFrame containsObject:self.rectArrM[a*4+1]]){
                    index = a*4+1;
                }else if ([self.noOccupyFrame containsObject:self.rectArrM[a*4+2]]){
                    index = a*4+2;
                }else{
                    index = a*4+3;
                }
                break;
            }
            case UISwipeGestureRecognizerDirectionUp:
            {
                int a = (int)label.tag%4;
                if ([self.noOccupyFrame containsObject:self.rectArrM[0*4+a]]) {
                    index = 0*4+a;
                }else if ([self.noOccupyFrame containsObject:self.rectArrM[1*4+a]]){
                    index = 1*4+a;
                }else if ([self.noOccupyFrame containsObject:self.rectArrM[2*4+a]]){
                    index = 2*4+a;
                }else{
                    index = 3*4+a;
                }
                break;
            }
            case UISwipeGestureRecognizerDirectionDown:
            {
                int a = (int)label.tag%4;
                if ([self.noOccupyFrame containsObject:self.rectArrM[3*4+a]]) {
                    index = 3*4+a;
                }else if ([self.noOccupyFrame containsObject:self.rectArrM[2*4+a]]){
                    index = 2*4+a;
                }else if ([self.noOccupyFrame containsObject:self.rectArrM[1*4+a]]){
                    index = 1*4+a;
                }else{
                    index = 0*4+a;
                }
                break;
            }
            default:
                break;
        }
        //确定label和前面label是否相加
        switch (recognizer.direction) {
            case UISwipeGestureRecognizerDirectionRight:
            {
                if (tag == 1) {
                    break;
                }
                for (int i = 1; index+i<(index/4+1)*4; i++) {
                    if (![self.noOccupyFrame containsObject:self.rectArrM[index+i]]) {
                        for (UILabel *tempLabel in self.showLabelArrM) {
                            if ([[NSValue valueWithCGRect:tempLabel.frame] isEqualToValue:self.rectArrM[index+i]] ) {
                                if ([tempLabel.text isEqualToString:label.text]) {
                                    label.text = [NSString stringWithFormat:@"%ld",[label.text integerValue]*2];
                                    index = index+i;
                                    for (UILabel *canLabel in self.subviews) {
                                        if ([[NSValue valueWithCGRect:canLabel.frame] isEqualToValue:self.rectArrM[index]]) {
                                            [canLabel removeFromSuperview];
                                            [self.showLabelArrM removeObject:canLabel];
                                            [self setLabelWithIndex:0];
                                            [self.noOccupyFrame addObject:self.rectArrM[index-i]];
                                        }
                                    }
                                }
                                tag = 1;
                            }
                            if (tag == 1) {
                                break;
                            }
                        }
                    }
                    if (tag == 1) {
                        break;
                    }
                }
                break;
            }
            case UISwipeGestureRecognizerDirectionLeft:
            {
                if (tag == 1) {
                    break;
                }
                for (int i = 1; index/4*4-1<index-i; i++) {
                    if (![self.noOccupyFrame containsObject:self.rectArrM[index-i]]) {
                        for (UILabel *tempLabel in self.showLabelArrM) {
                            if ([[NSValue valueWithCGRect:tempLabel.frame] isEqualToValue:self.rectArrM[index-i]] ) {
                                if ([tempLabel.text isEqualToString:label.text]) {
                                    label.text = [NSString stringWithFormat:@"%ld",[label.text integerValue]*2];
                                    index = index-i;
                                    for (UILabel *canLabel in self.subviews) {
                                        if ([[NSValue valueWithCGRect:canLabel.frame] isEqualToValue:self.rectArrM[index]]) {
                                            [canLabel removeFromSuperview];
                                            [self.showLabelArrM removeObject:canLabel];
                                            [self setLabelWithIndex:0];
                                            [self.noOccupyFrame addObject:self.rectArrM[index+i]];
                                        }
                                    }
                                }
                                tag = 1;
                            }
                            if (tag == 1) {
                                break;
                            }
                        }
                    }
                    if (tag == 1) {
                        break;
                    }
                }
                break;
            }
            case UISwipeGestureRecognizerDirectionUp:
            {
                if (tag == 1) {
                    break;
                }
                for (int i = 4; index%4-1<index-i; i = i+4) {
                    if (![self.noOccupyFrame containsObject:self.rectArrM[index-i]]) {
                        for (UILabel *tempLabel in self.showLabelArrM) {
                            if ([[NSValue valueWithCGRect:tempLabel.frame] isEqualToValue:self.rectArrM[index-i]] ) {
                                if ([tempLabel.text isEqualToString:label.text]) {
                                    label.text = [NSString stringWithFormat:@"%ld",[label.text integerValue]*2];
                                    index = index-i;
                                    for (UILabel *canLabel in self.subviews) {
                                        if ([[NSValue valueWithCGRect:canLabel.frame] isEqualToValue:self.rectArrM[index]]) {
                                            [canLabel removeFromSuperview];
                                            [self.showLabelArrM removeObject:canLabel];
                                            [self setLabelWithIndex:0];
                                            [self.noOccupyFrame addObject:self.rectArrM[index+i]];
                                        }
                                    }
                                }
                                tag = 1;
                            }
                            if (tag == 1) {
                                break;
                            }
                        }
                    }
                    if (tag == 1) {
                        break;
                    }
                }
                break;
            }
            case UISwipeGestureRecognizerDirectionDown:
            {
                if (tag == 1) {
                    break;
                }
                for (int i = 4; index+i<index%4+13; i = i+4) {
                    if (![self.noOccupyFrame containsObject:self.rectArrM[index+i]]) {
                        for (UILabel *tempLabel in self.showLabelArrM) {
                            if ([[NSValue valueWithCGRect:tempLabel.frame] isEqualToValue:self.rectArrM[index+i]] ) {
                                if ([tempLabel.text isEqualToString:label.text]) {
                                    label.text = [NSString stringWithFormat:@"%ld",[label.text integerValue]*2];
                                    
                                    index = index+i;
                                    for (UILabel *canLabel in self.subviews) {
                                        if ([[NSValue valueWithCGRect:canLabel.frame] isEqualToValue:self.rectArrM[index]]) {
                                            [canLabel removeFromSuperview];
                                            [self.showLabelArrM removeObject:canLabel];
                                            [self setLabelWithIndex:0];
                                            [self.noOccupyFrame addObject:self.rectArrM[index-i]];
                                        }
                                    }
                                }
                                tag = 1;
                            }
                            if (tag == 1) {
                                break;
                            }
                        }
                    }
                    if (tag == 1) {
                        break;
                    }
                }
                break;
            }
                
            default:
                break;
        }
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            if (![[NSValue valueWithCGRect:label.frame] isEqualToValue:self.rectArrM[index]]) {
                isNewLabel = YES;
            }
            [self.noOccupyFrame addObject:[NSValue valueWithCGRect:label.frame]];
            label.frame = [self.rectArrM[index] CGRectValue];
            label.tag = index;
            [self.noOccupyFrame removeObject:self.rectArrM[index]];
            
            if ([label.text isEqualToString:@"2"]) {
                label.backgroundColor = UIColorFromRGB(0xF0E8E2);
            }else if ([label.text isEqualToString:@"4"]){
                label.backgroundColor = UIColorFromRGB(0xEEE4D2);
            }else if ([label.text isEqualToString:@"8"]){
                label.backgroundColor = UIColorFromRGB(0xE8BB8B);
            }else if ([label.text isEqualToString:@"16"]){
                label.backgroundColor = UIColorFromRGB(0xE09D68);
            }else if ([label.text isEqualToString:@"32"]){
                label.backgroundColor = UIColorFromRGB(0xE58E72);
            }else if ([label.text isEqualToString:@"64"]){
                label.backgroundColor = UIColorFromRGB(0xD86E4A);
            }else if ([label.text isEqualToString:@"128"]){
                label.backgroundColor = UIColorFromRGB(0xEFDD85);
            }else if ([label.text isEqualToString:@"256"]){
                label.backgroundColor = UIColorFromRGB(0xEDD56A);
            }else if ([label.text isEqualToString:@"512"]){
                label.backgroundColor = UIColorFromRGB(0xE1C850);
            }else if ([label.text isEqualToString:@"1024"]){
                label.backgroundColor = UIColorFromRGB(0xDEC242);
            }else if ([label.text isEqualToString:@"2048"]){
                label.backgroundColor = UIColorFromRGB(0xE7CC42);
            }
            
        } completion:^(BOOL finished) {
            
        }];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (isNewLabel) {
            UILabel *label1 = self.labelArrM.firstObject;
            NSInteger index1 = arc4random()%self.noOccupyFrame.count;
            label1.text = @"2";
            label1.frame = [self.noOccupyFrame[index1] CGRectValue];
            label1.hidden = NO;
            for (int i = 0; i<self.rectArrM.count; i++) {
                if ([self.rectArrM[i] isEqual:self.noOccupyFrame[index1]]) {
                    label1.tag = i;
                }
            }
            [self addSubview:label1];
            [self.labelArrM removeObject:label1];
            [self.showLabelArrM addObject:label1];
            [self.noOccupyFrame removeObject:self.noOccupyFrame[index1]];
        }else if(self.showLabelArrM.count == 16){
            [SVProgressHUD showErrorWithStatus:@"游戏结束！"];
            
        }
        
    });
}

@end
