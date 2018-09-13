//
//  LKBaseFrame.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/31.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseFrame.h"

@implementation LKBaseFrame

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configDefault];
    }
    return self;
}

- (void)configDefault{
    self.topInval = CGFLOAT_MIN;
    self.bottomInval = CGFLOAT_MIN;
    self.width = CGFLOAT_MIN;
    self.height = CGFLOAT_MIN;
    self.leftInval = CGFLOAT_MIN;
    self.rightInval = CGFLOAT_MIN;
    self.font = [UIFont systemFontOfSize:12.0];
    self.lineSpace = CGFLOAT_MIN;
    self.rowCount = 1;

}
@end
