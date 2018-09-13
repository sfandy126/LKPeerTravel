//
//  LKAnswerListViewController.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/14.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseViewController.h"

@interface LKAnswerListViewController : LKBaseViewController

///问题列表类型 （1-最新;2-热门,3-没回答的,isMine-我的）
@property (nonatomic,strong) NSString *type;

@end
