//
//  LKEditSceneCellModel.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/22.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKEditSceneCellModel.h"

@implementation LKEditSceneCellModel

- (void)setData:(id)data {
    _data = data;
    
    if (_type==LKEditRowType_pic) {
        if ([data isKindOfClass:[UIImage class]]) {
            UIImage *img = (UIImage *)data;
            self.cellHeight = img.size.height*(kScreenWidth-40)/img.size.width+10;
        }
    } else {
        if ([data isKindOfClass:[NSString class]]) {
            self.txtImageDesc = data;
            CGSize size = [LKUtils sizeFit:self.txtImageDesc withUIFont:kFont(14) withFitWidth:kScreenWidth-40 withFitHeight:MAXFLOAT];
            self.cellHeight = size.height+34;
        }
    }
}

-  (void)juageCellHeight {
    if (self.type==LKEditRowType_pic) {
        if (self.imgWidth.floatValue > 0 && self.imgHeight.floatValue>0) {
            self.cellHeight = self.imgHeight.floatValue*(kScreenWidth-40)/self.imgWidth.floatValue+10;
        } else {
            self.cellHeight = 0;
        }
    } else {
        CGSize size = [LKUtils sizeFit:self.txtImageDesc withUIFont:kFont(14) withFitWidth:kScreenWidth-40 withFitHeight:MAXFLOAT];
        self.cellHeight = size.height+34;
    }
}

@end
