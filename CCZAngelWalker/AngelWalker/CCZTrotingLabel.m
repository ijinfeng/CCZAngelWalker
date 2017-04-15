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
        self.label = [[UILabel alloc] init];
        self.label.textColor = [UIColor blackColor];
        self.label.font = [UIFont systemFontOfSize:14];
        [self addWalkerView:self.label];
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

- (void)setNeedsTroting {
    if (!self.isWalking && self.attributeArrs.count) {
        [self addAttribute:[self.attributeArrs objectAtIndex:self.index]];
    }
}

- (void)addAttribute:(CCZTrotingAttribute *)attribute {
    if (!attribute) {
        return;
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
            self.duration = self.type == CCZWalkerTypeDefault? 2 : 0.8;
            break;
        case RateSlowly:
            self.duration = self.type == CCZWalkerTypeDefault? 5 : 2;
            break;
        case RateFast:
            self.duration = self.type == CCZWalkerTypeDefault? 1 : 0.2;
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

@end
