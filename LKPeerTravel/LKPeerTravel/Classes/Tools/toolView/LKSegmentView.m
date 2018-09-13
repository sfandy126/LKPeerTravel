//
//  LKSegmentView.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSegmentView.h"

@interface LKSegmentView ()
@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,strong) UIButton *lastBut;
@property (nonatomic,strong) UIView *proccess;
@end

@implementation LKSegmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configDefault];
    }
    return self;
}

//配置默认参数
- (void)configDefault{
    self.currentIndex = 0;
    self.butInval = 12.0;
    self.layoutStyle = LKSegmentLayoutStyle_custom;
    self.paddingEdgeInsets = UIEdgeInsetsZero;
    _buttons = [NSMutableArray array];
    self.selectdTitleColor = [UIColor colorWithHexString:@"#333333"];
    self.unSelectdTitleColor = [UIColor colorWithHexString:@"#333333"];
    self.selectdTitleFont = [UIFont boldSystemFontOfSize:18.0];
    self.unSelectdTitleFont = [UIFont systemFontOfSize:16.0];
    self.proccessColor = [UIColor colorWithHexString:@"#FDB92C"];
    self.proccessHeight = 7.0;
    self.proccessWidth = 0;
}

///显示菜单栏
- (void)showSegment{
    [self createView];
}

- (void)createView{
    //取第一个标题的宽度，来计算间距（前提是各个标题字个数相同）
    NSString *firstTitle = [_titles firstObject];
    CGSize titleSize = [LKUtils sizeFit:firstTitle withUIFont:self.selectdTitleFont withFitWidth:100 withFitHeight:ceil(self.selectdTitleFont.lineHeight)];
    
    CGFloat butWidth = titleSize.width;
    CGFloat butHeight = self.height;//titleSize.height;
    CGFloat leftX = 0;

    butWidth += self.paddingEdgeInsets.left+self.paddingEdgeInsets.right;
//    butHeight += self.paddingEdgeInsets.top + self.paddingEdgeInsets.bottom;
    
    if (self.layoutStyle == LKSegmentLayoutStyle_center) {
        _butInval = (self.width - butWidth*self.titles.count)/(self.titles.count+1);
        leftX = _butInval;
    }

    NSInteger index = 0;
    for (NSString *title in _titles) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.tag = 100 +index;
        [button setTitle:title forState:UIControlStateNormal];
        
        if (index== self.currentIndex) {
            [button setTitleColor:self.selectdTitleColor forState:UIControlStateNormal];
            button.titleLabel.font = self.selectdTitleFont;
            _lastBut = button;
        }else{
            [button setTitleColor:self.unSelectdTitleColor forState:UIControlStateNormal];
            button.titleLabel.font = self.unSelectdTitleFont;
        }
        [button addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(leftX, 0, butWidth, butHeight);
        [self addSubview:button];
        
        [_buttons addObject:button];
        leftX += (button.width +_butInval);
        index++;
    }
    
    //底部选择条
    UIButton *selectedBut = [self.buttons objectAt:self.currentIndex];
    if (self.proccessWidth<=0) {
        self.proccessWidth = selectedBut.width;
    }
    _proccess= [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.proccessWidth, self.proccessHeight)];
    if (self.proccessTop>0) {
        self.proccess.top = selectedBut.centerY +titleSize.height/2.0 +self.proccess.top;
    }else{
        _proccess.bottom = self.height;
    }
    _proccess.centerX = selectedBut.centerX;
    _proccess.userInteractionEnabled = NO;
    _proccess.backgroundColor = self.proccessColor;
    _proccess.layer.cornerRadius = _proccess.height/2.0;
    _proccess.layer.masksToBounds = YES;
    [self addSubview:_proccess];
}

- (void)butAction:(UIButton *)but{
    NSInteger index = but.tag-100;
    if (index == self.currentIndex || but==_lastBut) {
        //选择了相同的一个按钮，不做处理
        return;
    }
    
    //刷新按钮选中状态
    for (UIButton *btn in _buttons) {
        if (btn == but) {//选中的
            [btn setTitleColor:self.selectdTitleColor forState:UIControlStateNormal];
            btn.titleLabel.font = self.selectdTitleFont;
        }else{
            [btn setTitleColor:self.unSelectdTitleColor forState:UIControlStateNormal];
            btn.titleLabel.font = self.unSelectdTitleFont;
        }
    }
    
    //刷新进度位置(从上一个按钮的位置，移动到现在选择的按钮位置)
    _proccess.centerX = _lastBut.centerX;
    [UIView animateWithDuration:0.25 animations:^{
        _proccess.centerX = but.centerX;

    } completion:^(BOOL finished) {
        _proccess.centerX = but.centerX;
        if (self.selectedBlock) {
            self.selectedBlock(index);
        }
    }];
    
    
    _lastBut = but;
    _currentIndex = index;
}

- (void)setSelectedCurrentIndex:(NSInteger)index{
    if (index == self.currentIndex) {
        return;
    }
    
    //刷新按钮选中状态
    UIButton *but = nil;
    for (UIButton *btn in _buttons) {
        NSInteger tag = btn.tag - 100;
        if (tag == index) {//选中的
            [btn setTitleColor:self.selectdTitleColor forState:UIControlStateNormal];
            btn.titleLabel.font = self.selectdTitleFont;
            but = btn;
        }else{
            [btn setTitleColor:self.unSelectdTitleColor forState:UIControlStateNormal];
            btn.titleLabel.font = self.unSelectdTitleFont;
        }
    }
    
    //刷新进度位置(从上一个按钮的位置，移动到现在选择的按钮位置)
    _proccess.centerX = _lastBut.centerX;
    [UIView animateWithDuration:0.25 animations:^{
        _proccess.centerX = but.centerX;
        
    } completion:^(BOOL finished) {
        _proccess.centerX = but.centerX;
    }];
    
    _lastBut = but;
    _currentIndex = index;
}

@end
