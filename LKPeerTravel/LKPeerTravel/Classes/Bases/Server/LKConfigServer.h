//
//  LKConfigServer.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKConfigServer : NSObject

+ (LKConfigServer *)manager;

///设置根视图
- (void)setRootController;

- (void)loadConfig;

- (void)loadThirdConfig;


@end
