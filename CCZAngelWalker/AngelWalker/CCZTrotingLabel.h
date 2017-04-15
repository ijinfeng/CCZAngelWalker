//
//  CCZTrotingLabel.h
//  CCZAngelWalker
//
//  Created by 金峰 on 2017/4/8.
//  Copyright © 2017年 金峰. All rights reserved.
//

#import "CCZAngelWalker.h"
#import "CCZTrotingAttribute.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CCZTrotingRate) {
    /// default
    RateNormal,
    RateSlowly,
    RateFast,
};

typedef void(^CCZTrotingBlock)(CCZTrotingAttribute *attribute);

@interface CCZTrotingLabel : CCZAngelWalker

@property (nonatomic) CCZTrotingRate rate;
/**
 * 重复滚动数组，默认YES
 */
@property (nonatomic) BOOL repeatTextArr;
/**
 * 当滚动结束时，walker控件是否隐藏，默认NO;repeatTextArr == YES时不起作用
 */
@property (nonatomic) BOOL hideWhenStoped;
/**
 * 默认14
 */
@property (nonatomic, strong) UIFont *font;
/**
 * 默认blackColor
 */
@property (nonatomic, strong) UIColor *textColor;

- (void)addText:(NSString *)text;
- (void)addTexts:(NSArray <NSString *>*)texts;
- (void)addTrotingAttributes:(NSArray <CCZTrotingAttribute *>*)atts;
- (void)addAttribute:(CCZTrotingAttribute *)attribute atIndex:(NSUInteger)index;

- (void)removeAttributeAtIndex:(NSUInteger)index;
- (void)removeAllAttributes;

- (void)trotingWithAttribute:(CCZTrotingBlock)handle;

@end

NS_ASSUME_NONNULL_END
