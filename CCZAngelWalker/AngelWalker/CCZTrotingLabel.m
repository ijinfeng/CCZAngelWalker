//
//  CCZTrotingLabel.m
//  CCZAngelWalker
//
//  Created by 金峰 on 2017/4/8.
//  Copyright © 2017年 金峰. All rights reserved.
//

#import "CCZTrotingLabel.h"

@interface CCZTrotingLabel ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSMutableArray *attributeArrs;
@property (nonatomic) NSInteger index;
@property (nonatomic, copy) CCZTrotingBlock trotingBlock;
@property (nonatomic, strong) CCZTrotingAttribute *currentAttribute;
@end

@implementation CCZTrotingLabel

- (NSMutableArray *)attributeArrs {
    if (!_attributeArrs) {
        _attributeArrs = [NSMutableArray array];
    }
    return _attributeArrs;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.index = 0;
    self.rate = RateNormal;
    self.repeatTextArr = YES;
    
    if (!self.label) {
        
// ????
// 为label设置一个默认的值，一定要有值，否则会出现第一次frame动画错乱的问题
// 问题重现可以把这个默认的frame去掉
        
        self.label = [[UILabel alloc] init];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor blackColor];
        self.label.font = [UIFont systemFontOfSize:14];
    }
    
    __weak typeof(self) weakSelf = self;
    // 每开始一次walk
    [self walkStartComplication:^{
        !weakSelf.trotingBlock ?: weakSelf.trotingBlock(weakSelf.currentAttribute);
    }];
    
    // 每走完一次walk
    [self walkFinishedComplication:^{
        
        if (weakSelf.attributeArrs.count == 0) {
            weakSelf.index = 0;
            if (weakSelf.hideWhenStoped == YES) {
                weakSelf.hidden = YES;
            }
            return;
        }
        
        if (weakSelf.index < weakSelf.attributeArrs.count - 1) {
            weakSelf.index++;
            
        } else {
            weakSelf.index = 0;
            
            if (weakSelf.repeatTextArr == NO) {
                if (weakSelf.hideWhenStoped == YES) {
                    weakSelf.hidden = YES;
                }
                return;
            }
        }
        
        [weakSelf addAttribute:weakSelf.attributeArrs[weakSelf.index]];
    }];
    
    return self;
}

- (void)walk {
    if (self.attributeArrs.count) {
        [super walk];
    }
}

- (void)setNeedsTroting {
    if (!self.isWalking && self.attributeArrs.count) {
        [self addAttribute:[self.attributeArrs objectAtIndex:self.index]];
    }
}

- (void)addAttribute:(CCZTrotingAttribute *)attribute {
    if (!attribute) {
        return;
    }
    
    if (self.walkerView == nil) {
        [self addWalkerView:self.label];
    }
    
    self.currentAttribute = attribute;
    self.hidden = NO;
    
    attribute.attribute? [self.label setAttributedText:attribute.attribute] : [self.label setText:attribute.text];
    
    CGSize textSize = [self.label.text sizeWithAttributes:@{NSFontAttributeName: self.label.font}];
    self.label.frame = CGRectMake(0, 0, textSize.width, textSize.height);
    
    [self calcuteDuration];
    [self updateWalkerViewsFrame];
    [self walk];
}

- (void)addTrotingAttributes:(NSArray<CCZTrotingAttribute *> *)atts {
    if (atts.count == 0) {
        return;
    }
    
    [self.attributeArrs addObjectsFromArray:atts];
    
    [self setNeedsTroting];
}

- (void)addTexts:(NSArray<NSString *> *)texts {
    NSMutableArray *textArrs = [NSMutableArray array];
    for (NSString *text in texts) {
        CCZTrotingAttribute *att = [[CCZTrotingAttribute alloc] init];
        att.text = text;
        [textArrs addObject:att];
    }
    [self addTrotingAttributes:textArrs];
}

- (void)addText:(NSString *)text {
    [self addTexts:@[text]];
}

- (void)addAttribute:(CCZTrotingAttribute *)attribute atIndex:(NSUInteger)index {
    if ((index > self.attributeArrs.count - 1 || !self.attributeArrs.count) && index != 0) {
        return;
    }
    
    [self.attributeArrs insertObject:attribute atIndex:index];
    
    [self setNeedsTroting];
}

- (void)removeAttributeAtIndex:(NSUInteger)index {
    if (index > self.attributeArrs.count - 1 || self.attributeArrs.count == 0) {
        return;
    }
    
    [self.attributeArrs removeObjectAtIndex:index];
    
    [self setNeedsTroting];
}

- (void)removeAllAttributes {
    if (self.attributeArrs.count) {
        [self.attributeArrs removeAllObjects];
    }
}

- (void)trotingWithAttribute:(CCZTrotingBlock)handle {
    if (handle) {
        self.trotingBlock = handle;
    }
}

- (void)calcuteDuration {
    switch (self.rate) {
        case RateNormal:
            self.duration = self.type == CCZWalkerTypeDefault? 5 : 0.8;
            break;
        case RateSlowly:
            self.duration = self.type == CCZWalkerTypeDefault? 8 : 2;
            break;
        case RateFast:
            self.duration = self.type == CCZWalkerTypeDefault? 2 : 0.2;
            break;
    }
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    
    self.label.textColor = textColor;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    
    self.label.font = font;
}

- (void)setHideWhenStoped:(BOOL)hideWhenStoped {
    _hideWhenStoped = hideWhenStoped;
    
    self.hidden = hideWhenStoped;
}

@end
