//
//  LKTypeDef.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

#ifndef LKTypeDef_h
#define LKTypeDef_h


typedef NS_ENUM(NSInteger,LKRefreshType) {
    LKRefreshType_Refresh=0,    //刷新
    LKRefreshType_LoadMore,     //向上拉，向下加载更多
    LKRefreshType_UpLoadMore,   //向下拉，向上加载更多
};

///分享类型
typedef NS_ENUM(NSInteger,LKShareType) {
    LKShareType_wechat=0,
    LKShareType_QQ=1,
    LKShareType_sina=2,
    LKShareType_facebook=3,
    LKShareType_tswitter=4,
};


#endif /* LKTypeDef_h */
