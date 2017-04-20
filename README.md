# CCZAngelWalker

## 最新更新（重要）
1. 修复在第一次点击添加文本的时候，如下：
```Objective-C
// label的初始位置不正确
[self.label addTexts:@[@"数组文本----1",@"数组文本----2"]];
```
2. 修复在切换控制器时，[UIView animation:]闭包无限快速回调，消耗内存的bug
3. 为了在控制器再次显示的时候，走马灯仍然能够正常运行，请做如下操作：
```Objective-C
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //// 请务必写上这句话，防止因为控制器切换而不能正常工作
    [self.label walk];
}

```

## 导语
> 做这个走马灯是用在我们项目的公告中的，同时在socket来时及时更新展示内容。

## 功能

* 支持添加富文本
* 支持添加文本数组
* 支持无限重复滚动
* 支持在type为从上往下滚动的时候，自动适应文字而向左滚动，具体请看DEMO展示

### 先来看看效果图

![image](https://github.com/CranzCapatain/CCZAngelWalker/blob/master/CCZGuideView_gif.gif)

*** 

### 使用
```Objective-C
// 创建
    self.label = [[CCZTrotingLabel alloc] initWithFrame:CGRectMake(20, 100, 300, 40)];
    self.label.pause = 1;
    [self.view addSubview:self.label];
// 运行
    [self.label addText:@"此处是第一条数据"];

```

#### Demo中我只封装了一个trotingLabel，如果想要自定义的时候可以自己照着进行封装

欢迎大家加QQ群：**536251377**

一起学习，一起交流
