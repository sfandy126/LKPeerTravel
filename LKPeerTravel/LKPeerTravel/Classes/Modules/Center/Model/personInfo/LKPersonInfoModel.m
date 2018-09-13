//
//  LKPersonInfoModel.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/11.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKPersonInfoModel.h"

@implementation LKPersonInfoModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDictionary *dic = @{@"face":@"http://cdnq.duitang.com/uploads/item/201504/28/20150428020331_nkPcd.jpeg",
                              @"name":@"给陌生的你听",
                              @"sex":@"女",
                              @"age":@"22",
                              @"profession":@"学生",
                              @"language":@"日语、英语、法语、汉语",
                              @"city":@"深圳",
                              @"interest":@"美食家、摄影达人、游泳健将、篮球",
                              @"voice":@"http://boscdn.bpc.baidu.com/v1/developer/b42ea13e-2b61-4496-91d7-eae07ea4763e.mp3",
                              @"introduce":@"这首歌写给你听，我想请你闭上眼睛，这首可能不太动听，但是我有足够的用心，这首歌写给你听，我想请你闭上眼睛，这首可能不太动听，但是我有足够的用心，OK 你我可能还没见过，那就先让这首把未曾听闻给打破，说实话我也没有什么十足的把握，能让你动心再次播放这首歌......",
                              };
        [self loadDataWithDict:dic];
    }
    return self;
}

- (void)loadDataWithDict:(NSDictionary *)dict{
    self.face = [NSString stringValue:[dict valueForKey:@"face"]];
    self.name = [NSString stringValue:[dict valueForKey:@"name"]];
    self.sex = [NSString stringValue:[dict valueForKey:@"sex"]];
    self.age = [NSString stringValue:[dict valueForKey:@"age"]];
    self.profession = [NSString stringValue:[dict valueForKey:@"profession"]];
    self.language = [NSString stringValue:[dict valueForKey:@"language"]];
    self.city = [NSString stringValue:[dict valueForKey:@"city"]];
    self.interest = [NSString stringValue:[dict valueForKey:@"interest"]];
    self.voice = [NSString stringValue:[dict valueForKey:@"voice"]];
    self.introduce = [NSString stringValue:[dict valueForKey:@"introduce"]];

    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 2;
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.introduce];
    [attri addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],
                           NSParagraphStyleAttributeName:style} range:NSMakeRange(0, attri.length)];
    self.introduceAttri = attri;
}

@end
