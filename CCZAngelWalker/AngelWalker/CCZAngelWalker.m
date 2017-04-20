//
//  CCZAngelWalker.m
//  CCZAngelWalker
//
//  Created by 金峰 on 2017/3/26.
//  Copyright © 2017年 金峰. All rights reserved.
//

#import "CCZAngelWalker.h"

@interface CCZAngelWalker ()

@property (nonatomic, strong, readwrite) UIImageView *backgroundImageView;
@property (nonatomic, strong, readwrite) UIView *walkerView;
@property (nonatomic, strong, readwrite) UIView *contentView;

@property (nonatomic, readwrite) BOOL isWalking;

/// 控件自身的size
@property (nonatomic) CGSize aSize;
/// walkerView的size，不包含left和right
@property (nonatomic) CGSize wSize;

/// 动画初始位置
@property (nonatomic) CGRect frameBegin;
/// 动画中间停滞位置，当pause=0时，无停滞动画
@property (nonatomic) CGRect frame1;
/// 动画中间位置2
@property (nonatomic) CGRect frame2;
/// 动画最终位置
@property (nonatomic) CGRect frameEnd;

/// block
@property (nonatomic, copy) CCZAngelWalkerP0Block finishedBlock;
@property (nonatomic, copy) CCZAngelWalkerP0Block startBlock;
@end

@implementation CCZAngelWalker

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    self.duration = 2;
    self.pause = 0;
    self.type = CCZWalkerTypeDefault;
    self.aSize = frame.size;
    self.isWalking = NO;
    self.repeat = NO;
    
    [self setupContentView];
    
    return self;
}

- (void)setupContentView {
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.backgroundImageView.userInteractionEnabled = YES;
    [self addSubview:self.backgroundImageView];

    self.contentView = [[UIView alloc] initWithFrame:self.bounds];
    self.contentView.clipsToBounds = YES;
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
}

- (void)addWalkerView:(UIView *)walkerView {
    self.walkerView = walkerView;
    
    [self updateWalkerViewsFrame];

    !self.walkerView ?: [self.contentView addSubview:self.walkerView];
}

- (void)updateWalkerViewsFrame {
    self.wSize = self.walkerView.frame.size;
}

- (void)updateContentframe {
    self.contentView.frame = CGRectMake(CGRectGetMaxX(self.leftView.frame), 0, self.aSize.width - CGRectGetWidth(self.leftView.frame) - CGRectGetWidth(self.rightView.frame), self.aSize.height);
}

- (void)setLeftView:(UIView *)leftView {
    if (_leftView) {
        [_leftView removeFromSuperview];
        _leftView = nil;
    }
    _leftView = leftView;
    
    if (!leftView) {
        return;
    }
    
    CGSize leftSize = leftView.frame.size;
    _leftView.frame = CGRectMake(0, (self.aSize.height - leftSize.height) / 2, leftSize.width, leftSize.height);
    [self addSubview:_leftView];
    
    [self updateContentframe];
}

- (void)setRightView:(UIView *)rightView {
    if (_rightView) {
        [_rightView removeFromSuperview];
        _rightView = nil;
    }
    
    if (!rightView) {
        return;
    }
    
    _rightView = rightView;
    
    CGSize rightSize = rightView.frame.size;
    _rightView.frame = CGRectMake(self.aSize.width - rightSize.width, (self.aSize.height - rightSize.height) / 2, rightSize.width, rightSize.height);
    [self addSubview:_rightView];
    
    [self updateContentframe];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    
    self.backgroundImageView.image = backgroundImage;
}

#pragma mark - 启动

- (void)walk {
    if (self.isWalking == YES) {
        return;
    }
    
    [self calculate];
    [self addAnimations];
}

/**
 * 计算walkerView的各个阶段位置
 */
- (void)calculate {
    switch (self.type) {
        case CCZWalkerTypeDefault: {
            // 设置初始位置
            self.frameBegin = CGRectMake(CGRectGetWidth(self.contentView.frame), (self.aSize.height - self.wSize.height) / 2, self.wSize.width, self.wSize.height);
            // 设置中间段位置
            self.frame1 = CGRectMake(0, (self.aSize.height - self.wSize.height) / 2, self.wSize.width, self.wSize.height);
            // 设置结束时的位置
            self.frameEnd = CGRectMake(- self.wSize.width, (self.aSize.height - self.wSize.height) / 2, self.wSize.width, self.wSize.height);
        }
            break;
        case CCZWalkerTypeDescend: {
            // 设置初始位置
            self.frameBegin = CGRectMake(0, -self.wSize.height, self.wSize.width, self.wSize.height);
            // 设置下滚显示位置
            self.frame1 = CGRectMake(0, (self.aSize.height - self.wSize.height) / 2, self.wSize.width, self.wSize.height);
            // 设置在长度显示不下时，左滚一段距离的位置
            if (self.wSize.width > CGRectGetWidth(self.contentView.frame)) {
                self.frame2 = CGRectMake(-(self.wSize.width - CGRectGetWidth(self.contentView.frame)), CGRectGetMinY(self.frame1), self.wSize.width, self.wSize.height);
            } else {
                self.frame2 = self.frame1;
            }
            
            // 设置结束时的位置
            self.frameEnd = CGRectMake(CGRectGetMinX(self.frame2), self.aSize.height, self.wSize.width, self.wSize.height);
        }
            break;
        default:
            break;
    }
}

- (void)addAnimations {
    [self.walkerView.layer removeAllAnimations];
    self.hidden = NO;
    self.isWalking = YES;
    self.walkerView.frame = self.frameBegin;
    !self.startBlock ?: self.startBlock();
    
    CGFloat velocity;
    switch (self.type) {
            case CCZWalkerTypeDefault: {
                velocity = (self.frameBegin.origin.x - self.frame1.origin.x) / self.duration;
                
                [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.walkerView.frame = self.frame1;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:self.wSize.width / velocity delay:self.pause options:UIViewAnimationOptionCurveLinear animations:^{
                        self.walkerView.frame = self.frameEnd;
                    } completion:^(BOOL finished) {
                        self.walkerView.frame = self.frameBegin;
                        self.isWalking = NO;
                        
// ?????
// 此处修复在self.superView 也就是父容器视图在销毁的时候，不停回调的问题
// 还有一个问题是，在控制器切换的时候，UIView的anim闭包会返回一个finished == NO，这个时候，如果不去判断，那么就相当于这个动画闭包直接返回
// 注意到：上面两个应该是同一个问题
// 但是，问题又来了，一旦加了finished == NO,那么将不再重复进行滚动，返回后会发现走马灯不动了
                        
                        if (!finished) {
                            return;
                        }
                        
                        !self.finishedBlock ?: self.finishedBlock();
                        
                        if (self.repeat == YES) {
                            [self addAnimations];
                            return;
                        }
                    }];
                }];
            }
            break;
        
            case CCZWalkerTypeDescend: {
                velocity = (self.frame1.origin.y - self.frameBegin.origin.y) / self.duration;
                
                [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.walkerView.frame = self.frame1;
                } completion:^(BOOL finished) {
                    
                    if (self.wSize.width > CGRectGetWidth(self.contentView.frame)) {
                        [UIView animateWithDuration:(self.frame1.size.width - CGRectGetWidth(self.contentView.frame)) / velocity delay:self.pause options:UIViewAnimationOptionCurveLinear animations:^{
                            self.walkerView.frame = self.frame2;
                        } completion:^(BOOL finished) {
                            
                            [UIView animateWithDuration:self.duration delay:self.pause options:UIViewAnimationOptionCurveLinear animations:^{
                                self.walkerView.frame = self.frameEnd;
                            } completion:^(BOOL finished) {
                                self.walkerView.frame = self.frameBegin;
                                self.isWalking = NO;
                                
                                if (!finished) {
                                    return;
                                }
                                
                                !self.finishedBlock ?: self.finishedBlock();
                                
                                if (self.repeat == YES) {
                                    [self addAnimations];
                                    return;
                                }
                            }];

                        }];
                    } else {
                        [UIView animateWithDuration:self.duration delay:self.pause options:UIViewAnimationOptionCurveLinear animations:^{
                            self.walkerView.frame = self.frameEnd;
                        } completion:^(BOOL finished) {
                            self.walkerView.frame = self.frameBegin;
                            self.isWalking = NO;
                            
                            if (!finished) {
                                return;
                            }
                            
                            !self.finishedBlock ?: self.finishedBlock();
                            
                            if (self.repeat == YES) {
                                [self addAnimations];
                                return;
                            }
                        }];
                    }
                }];
            }
            
        default:
            break;
    }
}

#pragma mark - block

- (void)walkStartComplication:(CCZAngelWalkerP0Block)complication {
    if (complication) {
        self.startBlock = complication;
    }
}

- (void)walkFinishedComplication:(CCZAngelWalkerP0Block)complication {
    if (complication) {
        self.finishedBlock = complication;
    }
}

@end
