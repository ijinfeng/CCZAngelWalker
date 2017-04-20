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

@property (nonatomic, strong) CCZTrotingLabel *label;

@property (nonatomic, strong) CCZAngelWalker *walker;

@end

@implementation ViewController

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.label = [[CCZTrotingLabel alloc] initWithFrame:CGRectMake(20, 100, 300, 40)];
    self.label.backgroundImage = [UIImage imageNamed:@"rem_effect"];
    self.label.pause = 1;
    self.label.type = CCZWalkerTypeDescend;
    self.label.rate = RateFast;
    [self.view addSubview:self.label];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headr.jpg"]];
    icon.frame = CGRectMake(0, 0, 40, 40);
    self.label.rightView = icon;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundColor:[UIColor redColor]];
    backButton.frame = CGRectMake(20, 20, 120, 40);
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(didClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.label trotingWithAttribute:^(CCZTrotingAttribute * _Nonnull attribute) {
        NSLog(@"%@",attribute);
    }];
    
    
//    CCZTrotingAttribute *att = [CCZTrotingAttribute new];
//    NSMutableAttributedString *matt = [[NSMutableAttributedString alloc] initWithString:@"这是第一条数据，如果walker的类型是Descend，那么在数据较长时，能够自动左滚适应"];
//    [matt addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColor] range:NSMakeRange(0, 10)];
//    att.attribute = [matt copy];
//    [self.label addTrotingAttributes:@[att]];
}

- (void)didClick {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)clcikButton:(UIButton *)sender {
    [self.label addText:@"添加一条普通的新数据"];
}
- (IBAction)addtexts:(id)sender {
    [self.label addTexts:@[@"数组文本----1",@"数组文本----2"]];
}
- (IBAction)addTextat2:(id)sender {
    CCZTrotingAttribute *att = [[CCZTrotingAttribute alloc] init];
    NSMutableAttributedString *matt = [[NSMutableAttributedString alloc] initWithString:@"在第二位添加一条新数据，显示红色" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    att.attribute = [matt copy];
    [self.label addAttribute:att atIndex:2];
}
- (IBAction)removeTextat0:(id)sender {
    
    [self.label removeAttributeAtIndex:0];
}
- (IBAction)removeAll:(id)sender {
    [self.label removeAllAttributes];
}

@end
