//
//  CCZAngelWalker.h
//  CCZAngelWalker
//
//  Created by 金峰 on 2017/3/26.
//  Copyright © 2017年 金峰. All rights reserved.
//
/**
 层级关系：
                                   |-->leftView
                                   |
 CCZAngelWalker -> backgroundImage |-->contentView -> walkerView(Customized)
                                   |
                                   |-->rightView
 
 */


#import <UIKit/UIKit.h>

typedef void(^CCZAngelWalkerP0Block)();

typedef NS_ENUM(NSUInteger, CCZWalkerType) {
    /// 从左到右滚动
    CCZWalkerTypeDefault,
    /// 往下滚动
    CCZWalkerTypeDescend,
};

NS_ASSUME_NONNULL_BEGIN
@interface CCZAngelWalker : UIView

/// 设置背景图，默认nil
@property (nonatomic, strong, nullable) UIImage *backgroundImage;
/// 一次显示的动画时长，默认2
@property (nonatomic) NSTimeInterval duration;
/// 动画中间暂停的时长，默认0
@property (nonatomic) NSTimeInterval pause;
/// 展示类型，默认Default
@property (nonatomic) CCZWalkerType type;
/// 当前的walker视图，默认nil
@property (nonatomic, strong, readonly, nullable) UIView *walkerView;
/// 一个承载walker的父视图，所有添加的都应该放在这个视图上面
@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong, nullable) UIView *leftView;
@property (nonatomic, strong, nullable) UIView *rightView;
/// 获取动画是否在进行
@property (nonatomic, readonly) BOOL isWalking;
/// 重复滚动，默认NO
@property (nonatomic) BOOL repeat;

/**
 * 添加自定义的滚动视图
 */
- (void)addWalkerView:(UIView *)walkerView;

/**
 * 更新walkerView，每次改变walkerView的frame时需要主动调用
 */
- (void)updateWalkerViewsFrame;

/**
 * 需主动调用walk方法开始执行动画
 */
- (void)walk;

/**
 * 每开始一次动画的回调
 */
- (void)walkStartComplication:(CCZAngelWalkerP0Block)complication;

/**
 * 每结束一次动画的回调
 */
- (void)walkFinishedComplication:(CCZAngelWalkerP0Block)complication;

@end
NS_ASSUME_NONNULL_END
