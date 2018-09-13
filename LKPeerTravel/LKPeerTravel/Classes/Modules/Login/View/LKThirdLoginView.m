//
//  LKThirdLoginView.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/7.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKThirdLoginView.h"

@interface LKThirdLoginView ()
@property (nonatomic,strong) UILabel *titleLab;
@end

@implementation LKThirdLoginView

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLab.text = LKLocalizedString(@"LKLogin_thirdLogin_title");//@"第三方登录";
        _titleLab.textColor = [UIColor colorWithHexString:@"#999999"];
        _titleLab.font = [UIFont systemFontOfSize:12];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.height = ceil(_titleLab.font.lineHeight);
    }
    return _titleLab;
}

- (UIView *)setLineView{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#c8c8c8"];
    return line;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    CGSize titleSize = [LKUtils sizeFit:self.titleLab.text withUIFont:self.titleLab.font withFitWidth:1000 withFitHeight:self.titleLab.height];
    self.titleLab.width = titleSize.width;
    self.titleLab.centerX = self.width/2.0;
    [self addSubview:self.titleLab];
    
    UIView *leftLine = [self setLineView];
    leftLine.right = self.titleLab.left -6;
    leftLine.centerY = self.titleLab.centerY;
    [self addSubview:leftLine];
    
    UIView *rightLine = [self setLineView];
    rightLine.left = self.titleLab.right +6;
    rightLine.centerY = self.titleLab.centerY;
    [self addSubview:rightLine];
    
    
    NSArray *icons = @[@{@"icon":@"img_loading_wechat",@"title":@"微信",@"type":@(LKLoginType_wechat)},
                       @{@"icon":@"img_loading_twitter",@"title":@"twitter",@"type":@(LKLoginType_twitter)},
                       @{@"icon":@"img_loading_facebook",@"title":@"facebook",@"type":@(LKLoginType_facebook)},
                       @{@"icon":@"img_loading_microblog",@"title":@"新浪微博",@"type":@(LKLoginType_sina)}];
    
    //是否显示其对于的第三方登录入口
    BOOL isShowWeChat=YES;
    BOOL isShowtWitter=YES;
    BOOL isShowFacebook=YES;
    BOOL isShowSina=YES;
    
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dic in icons) {
        NSInteger type = [[dic valueForKey:@"type"] integerValue];
        if ((type == LKLoginType_wechat && isShowWeChat)
            || (type == LKLoginType_twitter && isShowtWitter)
            || (type == LKLoginType_facebook && isShowFacebook)
            || (type == LKLoginType_sina && isShowSina)){
            [temp addObject:dic];
        }
    }
    NSArray *newIcons = [NSArray getArray:[temp copy]];
    self.hidden = newIcons.count==0;
    
    CGSize butSize = CGSizeMake(28, 22);
    CGFloat inval = (self.width - butSize.width*newIcons.count)/(newIcons.count+1);
    NSInteger index = 0;
    for (NSDictionary *dic in newIcons) {
        NSInteger type = [[dic valueForKey:@"type"] integerValue];
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.tag =1000+type;
        [but setBackgroundImage:[UIImage imageNamed:[dic valueForKey:@"icon"]] forState:UIControlStateNormal];
        but.size = butSize;
        but.left = inval*(index+1) +butSize.width*index;
        but.top = self.titleLab.bottom+20;
        [self addSubview:but];
        [but addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
        index++;
    }
}

- (void)butAction:(UIButton *)but{
    LKLoginType selectedLogonType = but.tag -1000;
    if (self.selectedLoginBlock) {
        self.selectedLoginBlock(selectedLogonType);
    }
}

@end
