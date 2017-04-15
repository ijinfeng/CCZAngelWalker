//
//  ViewController.m
//  CCZAngelWalker
//
//  Created by 金峰 on 2017/3/26.
//  Copyright © 2017年 金峰. All rights reserved.
//

#import "ViewController.h"
#import "CCZAngelWalker.h"
#import "CCZTrotingLabel.h"
@interface ViewController ()
@property (nonatomic, strong ) CCZAngelWalker *walker;
@property (nonatomic, strong) CCZTrotingLabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.label = [[CCZTrotingLabel alloc] initWithFrame:CGRectMake(20, 100, 300, 40)];
    self.label.backgroundImage = [UIImage imageNamed:@"rem_effect"];
    self.label.pause = 1;
    self.label.repeatTextArr = YES;
    self.label.type = CCZWalkerTypeDescend;
    self.label.rate = RateSlowly;
    [self.view addSubview:self.label];
    
    
    [self.label trotingWithAttribute:^(CCZTrotingAttribute * _Nonnull attribute) {
        NSLog(@"%@",attribute);
    }];
    
    
    CCZTrotingAttribute *att = [CCZTrotingAttribute new];
    NSMutableAttributedString *matt = [[NSMutableAttributedString alloc] initWithString:@"诶吴磊宝得，😄你个，今天天气真是好，你们说是不是"];
    [matt addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(10, 5)];
    att.attribute = [matt copy];
    [self.label addTrotingAttributes:@[att]];
}

- (IBAction)clcikButton:(UIButton *)sender {
    [self.label addText:@"******77&&&&"];
}
- (IBAction)addtexts:(id)sender {
    [self.label addTexts:@[@"你们好",@"大家好！！！1"]];
}
- (IBAction)addTextat2:(id)sender {
    CCZTrotingAttribute *att = [[CCZTrotingAttribute alloc] init];
    att.text = @"在第二位添加字符串";
    NSMutableAttributedString *matt = [[NSMutableAttributedString alloc] initWithString:att.text];
    [matt addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(1, 3)];
    att.attribute = [matt copy];
    [self.label addAttribute:att atIndex:2];
}
- (IBAction)removeTextat0:(id)sender {
    
    [self.label removeAttributeAtIndex:0];
}
- (IBAction)removeAll:(id)sender {
    [self.label removeAllAttributes];
}
- (IBAction)switchmm:(UISwitch *)sender {
    sender.on = !sender.on;
    
    self.label.hideWhenStoped = sender.on;
}

@end
