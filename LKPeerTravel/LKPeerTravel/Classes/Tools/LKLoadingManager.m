//
//  LKLoadingManager.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/12.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKLoadingManager.h"

@interface LKLoadingManager ()
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIActivityIndicatorView *activityView;
@property (nonatomic,strong) UIImageView *loadIcon;
@end

@implementation LKLoadingManager

+ (LKLoadingManager *)share{
    static LKLoadingManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LKLoadingManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentView.width = kScreenWidth;
        self.contentView.height = kScreenHeight;
        
        [[UIApplication sharedApplication].delegate.window addSubview:self.contentView];
    }
    return self;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _contentView;
}

- (UIActivityIndicatorView *)activityView{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _activityView.color = [UIColor colorWithHexString:@"#e9e9e9"];
    }
    return _activityView;
}

- (UIImageView *)loadIcon{
    if (!_loadIcon) {
        _loadIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 62, 62)];
    }
    return _loadIcon;
}

- (void)layoutInView:(UIView *)view{
    self.contentView.width = view.width;
    self.contentView.height = view.height;
    self.activityView.centerX = self.contentView.width/2.0;
    self.activityView.centerY = self.contentView.height/2.0;
    
    self.loadIcon.centerX = self.contentView.width/2.0;
    self.loadIcon.centerY = self.contentView.height/2.0;
}

- (void)showAnimation:(LKLoadingAnimationType )animationType{
    if (animationType == LKLoadingAnimationType_system) {
        self.activityView.centerX = self.contentView.width/2.0;
        self.activityView.centerY = self.contentView.height/2.0;
        [self.activityView startAnimating];
        [self.contentView addSubview:self.activityView];
    }else{
        
        // 1-2-3-4-5-6-5-4-3-2-1-7-8-9-10-11-10-9-8-7
        NSArray *nums = @[@"1",@"2",@"3",@"4",@"5",@"6",@"5",@"4",@"3",@"2",@"1",@"7",@"8",@"9",@"10",@"11",@"10",@"9",@"8",@"7"];
        NSMutableArray *tempIcons = [NSMutableArray array];
        for (NSString *str in nums) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"cartoon_loading_%@",str]];
            if (image) {
                [tempIcons addObject:image];
            }
        }
        self.loadIcon.animationImages = [NSArray getArray:[tempIcons copy]];
        self.loadIcon.animationRepeatCount = 1000;
        self.loadIcon.animationDuration = 2;
        self.loadIcon.centerX = self.contentView.width/2.0;
        self.loadIcon.centerY = self.contentView.height/2.0;
        [self.loadIcon startAnimating];
        [self.contentView addSubview:self.loadIcon];
    }

}

- (void)hide{
    self.contentView.hidden = YES;
    [self.activityView stopAnimating];
    
    [self.loadIcon stopAnimating];
}


@end
