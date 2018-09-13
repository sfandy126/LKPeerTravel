//
//  LKAnswerModel.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/31.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseModel.h"

@class LKAnswerSingleModel;
@interface LKAnswerModel : LKBaseModel

///热门回答
@property (nonatomic,strong) NSArray *hotLists;

///最新
@property (nonatomic,strong) NSArray *lastestList;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,assign) BOOL isLastPage;

///获取问答列表接口（热门）
- (void)obtainAnswerHotListData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

///获取问答列表接口（最新）
- (void)obtainAnswerLastestListData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

@end



@interface LKAnswerSingleModel : LKBaseModel


@property (nonatomic,copy) NSString *questionNo;///问题编号
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *nick_name;
@property (nonatomic,copy) NSString *face;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSAttributedString *contentAttri;
@property (nonatomic,copy) NSString *join_num;///参入人数
@property (nonatomic,copy) NSString *location;
@property (nonatomic,copy) NSString *looks;
@property (nonatomic,copy) NSString *comments;
@property (nonatomic,copy) NSString *datCreate;


//最新cell frame
@property (nonatomic,assign) BOOL isHideFooter;//是否隐藏底部间隙
@property (nonatomic,strong) LKBaseFrame *newestCellFrame;//cellframe
@property (nonatomic,strong) LKBaseFrame *newesBgFrame;//标题frame
@property (nonatomic,strong) LKBaseFrame *newesTitleFrame;//标题frame
@property (nonatomic,strong) LKBaseFrame *newestContentFrame;//正文frame
@property (nonatomic,strong) LKBaseFrame *newestUserFrame;//用户信息frame

@property (nonatomic,strong) LKBaseFrame *lookFrame; 
@property (nonatomic,strong) LKBaseFrame *commentFrame;



@end
