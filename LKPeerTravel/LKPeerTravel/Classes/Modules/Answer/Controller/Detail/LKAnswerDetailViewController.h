//
//  LKAnswerDetailViewController.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/2.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseViewController.h"
#import "LKAnswerModel.h"

@interface LKAnswerDetailViewController : LKBaseViewController

@property (nonatomic,strong) NSString *questionNo;

///外部带进的数据
@property (nonatomic,strong) NSDictionary *params;
///外部带进的数据
@property (nonatomic,strong) LKAnswerSingleModel *answerModel;

@end
