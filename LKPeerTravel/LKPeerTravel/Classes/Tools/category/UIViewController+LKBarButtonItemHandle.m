//
//  UIViewController+LKBarButtonItemHandle.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/4.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "UIViewController+LKBarButtonItemHandle.h"

@implementation UIViewController (LKBarButtonItemHandle)

- (void)setBackBtn {
    if (self.navigationController.viewControllers[0] != self) {
        UIButton *backBtn = [self setLeftButtonWithImageName:@"btn_title_return_none" hightlightedImageName:@"btn_title_return_pressed" title:@""];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)setLeftButtonWithImageName:(NSString *)imageName
                   hightlightedImageName:(NSString *)hightlightedImageName
                                   title:(NSString *)title
{
    UIButton *btn = [self buttonWithImg:imageName highlightImg:hightlightedImageName title:title];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    self.navigationItem.leftBarButtonItems =  [NSArray arrayWithObjects:item,spaceItem,nil];
    self.navigationItem.leftBarButtonItem = item;
    return btn;
}

- (UIButton *)setRightButtonWithImageName:(NSString *)imageName
                    hightlightedImageName:(NSString *)hightlightedImageName
                                    title:(NSString *)title
{
    UIButton *btn = [self buttonWithImg:imageName highlightImg:hightlightedImageName title:title];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    return btn;
}

- (void)setRightNavigationItems:(NSArray<NSString *>*)rightItemIcons action:(SEL)selOne action:(SEL)selTwo{
    if (!rightItemIcons || rightItemIcons.count==0 ||rightItemIcons.count>2) {
        return;
    }
    NSMutableArray *temp = [NSMutableArray array];
    NSInteger index=0;
    for (NSString *imageName in rightItemIcons) {
        UIButton *btn = [self buttonWithImg:imageName highlightImg:imageName title:nil];
        [btn addTarget:self action:(index==1?selTwo:selOne) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [temp addObject:item];
        index++;
    }
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    [temp addObject:spaceItem];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithArray:[temp copy]];
}

- (UIButton *)buttonWithImg:(NSString *)imgStr highlightImg:(NSString *)highlightImgStr  title:(NSString *)title {
    UIImage *img = [UIImage imageNamed:imgStr];
    UIImage *highlightImg = [UIImage imageNamed:highlightImgStr];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title && title.length>0) {
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, img.size.width, img.size.height);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    else {
        btn.frame = CGRectMake(0, 0, 44, 44);
//        btn.backgroundColor = [UIColor redColor];
    }
    
    if (img) {
        [btn setImage:img forState:UIControlStateNormal];
        if (highlightImg) {
            [btn setImage:highlightImg forState:UIControlStateHighlighted];
        }
    }
    
    return btn;
}

- (UIBarButtonItem *) barButtomItemImageName:(NSString *)imageName
                       hightlightedImageName:(NSString *)hightlightedImageName
                                       Title:(NSString *)title
                                      Target:(id)target
                                    Selector:(SEL)action
                                      isLeft:(BOOL)isLeft {
    UIButton *btn = [self buttonWithImg:imageName highlightImg:hightlightedImageName title:title];
    if (isLeft) {
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
    
}

@end
