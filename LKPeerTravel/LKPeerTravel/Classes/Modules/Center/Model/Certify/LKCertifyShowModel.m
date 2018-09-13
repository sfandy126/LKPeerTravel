//
//  LKCertifyShowModel.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/15.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKCertifyShowModel.h"

@implementation LKCertifyShowModel

- (NSString *)alert_msg {
    if (self.url.length>0) {
        return @"";
    } else {
        return [NSString stringWithFormat:@"请上传%@",self.title];
    }
}

@end
