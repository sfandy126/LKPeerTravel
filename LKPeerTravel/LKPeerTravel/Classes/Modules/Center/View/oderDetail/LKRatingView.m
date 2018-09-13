//
//  LKRatingView.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/8/5.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKRatingView.h"

#define ZOOM 25
@interface LKRatingView()
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,assign) CGFloat starWidth;
@end

@implementation LKRatingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.bottomView = [[UIView alloc] initWithFrame:self.bounds];
        self.bottomView.backgroundColor = [UIColor clearColor];
        self.topView = [[UIView alloc] initWithFrame:CGRectZero];
        self.topView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.bottomView];
        [self addSubview:self.topView];
        
        self.topView.clipsToBounds = YES;
        self.topView.userInteractionEnabled = NO;
        self.bottomView.userInteractionEnabled = NO;
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:tap];
        [self addGestureRecognizer:pan];
        
        //
        CGFloat width = frame.size.width/7.0;
        self.starWidth = width;
        for(int i = 0;i<5;i++){
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ZOOM, ZOOM)];
            img.tag = 300+i;
            img.center = CGPointMake((i+1.5)*width, frame.size.height/2);
            img.image = [UIImage imageNamed:@"star1"];
            [self.bottomView addSubview:img];
            UIImageView *img2 = [[UIImageView alloc] initWithFrame:img.frame];
            img2.center = img.center;
            img2.tag = 400+i;
            img2.image = [UIImage imageNamed:@"star3"];
            [self.topView addSubview:img2];
        }
        self.enable = YES;
        
    }
    return self;
}
-(void)setViewColor:(UIColor *)backgroundColor{
    if(_viewColor!=backgroundColor){
        self.backgroundColor = backgroundColor;
        self.topView.backgroundColor = backgroundColor;
        self.bottomView.backgroundColor = backgroundColor;
    }
}

-(void)setStarNumber:(NSInteger)starNumber{
    if(_starNumber!=starNumber){
        _starNumber = starNumber;
        self.topView.frame = CGRectMake(0, 0, self.starWidth*(starNumber+1), self.bounds.size.height);
    }
}

- (void)setNormalStarImageName:(NSString *)normalStarImageName {
    _normalStarImageName = normalStarImageName;
    
    self.starWidth = 36;
    for (int i=0; i<5; i++) {
        UIImageView *iv = [self.bottomView viewWithTag:300+i];
        iv.image = [UIImage imageNamed:normalStarImageName];
        iv.frame = CGRectMake(0, 0, 36, 36);
        iv.centerX = self.starWidth*(i+1.5);
    }
}

- (void)setLightStarImagename:(NSString *)lightStarImagename {
    _lightStarImagename = lightStarImagename;
    
    for (int i=0; i<5; i++) {
        UIImageView *iv = [self.topView viewWithTag:400+i];
        iv.image = [UIImage imageNamed:lightStarImagename];
        iv.frame = CGRectMake(0, 0, 36, 36);
        iv.centerX = self.starWidth*(i+1.5);
    }
}

-(void)tap:(UITapGestureRecognizer *)gesture{
    if(self.enable){
        CGPoint point = [gesture locationInView:self];
        NSInteger count = (int)(point.x/self.starWidth)+1;
        self.topView.frame = CGRectMake(0, 0, self.starWidth*count, self.bounds.size.height);
        if(count>5){
            _starNumber = 5;
        }else{
            _starNumber = count-1;
        }
        
        if (count-1>=6)
        {
            count = 6;
        }
        
        
        
        
        for (int i = 0; i < 5; i++)
        {
            UIImageView *img = [self viewWithTag:300+i];
            if (self.normalStarImageName) {
                img.image = [UIImage imageNamed:self.normalStarImageName];
            } else {
                if (count-1>0)
                {
                    img.image = [UIImage imageNamed:@"star2"];
                }
                else
                {
                    img.image = [UIImage imageNamed:@"star1"];
                }
            }
        }
        
        
        
        if (self.tag == 100)
        {
            //            NSLog(@"100点击_count = %ld",count-1);
            [[NSUserDefaults standardUserDefaults] setInteger:(count-1) forKey:@"starCount1"];
        }
        else if (self.tag == 101)
        {
            //            NSLog(@"101点击_count = %d",count-1);
            [[NSUserDefaults standardUserDefaults] setInteger:(count-1) forKey:@"starCount2"];
        }
        else if (self.tag == 102)
        {
            //            NSLog(@"102点击_count = %d",count-1);
            [[NSUserDefaults standardUserDefaults] setInteger:(count-1) forKey:@"starCount3"];
        }
        
        self.star = count-1;
        
        if (self.updateRatingBlock) {
            self.updateRatingBlock();
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}
-(void)pan:(UIPanGestureRecognizer *)gesture{
    if(self.enable){
        CGPoint point = [gesture locationInView:self];
        NSInteger count = (int)(point.x/self.starWidth);
        if(count>=0 && count<=5 && _starNumber!=count){
            self.topView.frame = CGRectMake(0, 0, self.starWidth*(count+1), self.bounds.size.height);
            _starNumber = count;
        }
        
        if (count>=5)
        {
            count = 5;
        }
        
        
        for (int i = 0; i < 5; i++)
        {
            UIImageView *img = [self viewWithTag:300+i];
            if (self.normalStarImageName) {
                img.image = [UIImage imageNamed:self.normalStarImageName];
            } else {
                if (count-1>0)
                {
                    img.image = [UIImage imageNamed:@"star2"];
                }
                else
                {
                    img.image = [UIImage imageNamed:@"star1"];
                }
            }
        }
        
        
        if (self.tag == 100)
        {
            NSLog(@"100滑动count = %ld",(long)count);
            [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"starCount1"];
        }
        else if (self.tag == 101)
        {
            NSLog(@"101滑动count = %ld",(long)count);
            [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"starCount2"];
        }
        else if (self.tag == 102)
        {
            NSLog(@"102滑动count = %ld",(long)count);
            [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"starCount3"];
        }
        
        self.star = count;
        
        if (self.updateRatingBlock) {
            self.updateRatingBlock();
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


@end
