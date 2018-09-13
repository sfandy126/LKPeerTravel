//
//  LKEditSceneMainView.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/16.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKEditSceneMainView.h"

#import "LKWishEditRowCell.h"
#import "LKEditScenePicCell.h"
#import "LKEditSceneTextCell.h"
#import "LKEditTextCell.h"

#import "LKSelectCityViewController.h"

#import <YYKit.h>
#import <YYTextKeyboardManager.h>
#import "LKEditSceneToolView.h"

#import "UIResponder+firstResponder.h"
#import "UIImage+RemoteSize.h"

@interface LKEditSceneMainView () <UITableViewDelegate,UITableViewDataSource,YYTextKeyboardObserver>

@property (nonatomic, strong) LKEditSceneToolView *toolView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, strong) NSMutableArray *sceneDatas;
@property (nonatomic, strong) NSString *scenePlaceholder;
@property (nonatomic, strong) LKEditTextCell *editTextCell;


@property (nonatomic, assign) CGFloat contentCellHeight;


@end

@implementation LKEditSceneMainView

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = TableBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        [_tableView registerClass:[LKWishEditRowCell class] forCellReuseIdentifier:LKWishEditRowCellReuseIndentifier];
        [_tableView registerClass:[LKEditScenePicCell class] forCellReuseIdentifier:kLKEditScenePicCellReuserIndentifier];
        [_tableView registerClass:[LKEditSceneTextCell class] forCellReuseIdentifier:kLKEditSceneTextCellReuserIndentifier];
        [_tableView registerClass:[LKEditTextCell class] forCellReuseIdentifier:@"LKEditTextCell"];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

- (LKEditSceneToolView *)toolView {
    if (!_toolView) {
        _toolView = [[LKEditSceneToolView alloc] initWithFrame:CGRectMake(0, kScreenHeight, self.width, 55)];
         @weakify(self);
        _toolView.btnClickBlock = ^(NSInteger index) {
            @strongify(self);
            if (index==1) { // 添加图片
                [self addPic];
            } else {
                [self addText];
            }
        };
    }
    return _toolView;
}

- (void)addPic {
    [self endEditing:YES];
    NSLog(@"addPic%@",NSStringFromCGRect(self.toolView.frame));
     @weakify(self);
    [LKImagePicker getPictureWithBlock:^(UIImage *image) {
        NSLog(@"addPic%@",NSStringFromCGRect(self.toolView.frame));
        @strongify(self);
        [LKUploadManager uploadImage:image completeBlock:^(LKResult *ret, NSError *error) {
            if (ret.success) {
                LKEditSceneCellModel *info = [[LKEditSceneCellModel alloc] init];
                info.type = LKEditRowType_pic;
                info.codImageUrl = ret.data[@"data"];
                info.data = image;
                info.picurl = ret.data[@"data"];
                [self.sceneDatas addObject:info];
                [self.tableView reloadData];
            }
        }];
    }];
}

- (void)addText {
    NSString *text = [self.editTextCell addText];
    if (text.length==0) {
        [LKUtils showMessage:@"请输入文本"];
        return;
    }
    LKEditSceneCellModel *info = [[LKEditSceneCellModel alloc] init];
    info.type = LKEditRowType_text;
    info.txtImageDesc = text;
    info.data = text;
    [info juageCellHeight];
    [self.sceneDatas addObject:info];
    [self.tableView reloadData];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
    [self.toolView removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame model:(LKEditSceneModel *)model type:(NSInteger)type {
    self = [super initWithFrame:frame];
    if (self) {
        LKWishEditRowModel *row1 = [LKWishEditRowModel modelWithTitle:@"是否开放当前城市" desc:@"" showArrow:NO showSwitch:model?([model.flagOpen isEqualToString:@"1"]):YES];
        row1.switchState = YES;
        row1.title_desc = @"flagOpen";
        
        LKWishEditRowModel *row2 = [LKWishEditRowModel modelWithTitle:@"选择城市" desc:model?model.cityName:@"" showArrow:YES showSwitch:NO];
        row2.city_id = model.codDestinationNo;
        row2.title_desc = @"codDestinationCityNo";
        
        NSString *rowtitle3 = @"景点名称";
        NSString *rowtitle4 = @"景点介绍";
        self.scenePlaceholder = @"点击输入景点介绍";
        if (type==2) {
            rowtitle3 = @"商场名称";
            rowtitle4 = @"商场介绍";
            self.scenePlaceholder = @"点击输入商场介绍";

        } else if (type==3) {
            rowtitle3 = @"美食名称";
            rowtitle4 = @"美食介绍";
            self.scenePlaceholder = @"点击输入美食介绍";

        }
        
        LKWishEditRowModel *row3 = [LKWishEditRowModel modelWithTitle:rowtitle3 desc:model?model.codDestinationPointName:@"" showArrow:YES showSwitch:NO];
        row3.title_desc = @"codDestinationPointName";
   
        LKWishEditRowModel *row4 = [LKWishEditRowModel modelWithTitle:rowtitle4 desc:@"" showArrow:NO showSwitch:NO];

        self.datas = @[row1,row2,row3,row4];
        
        self.sceneDatas = [NSMutableArray array];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (NSDictionary *dict in model.images) {
                NSString *image = [NSString stringValue:dict[@"codImageUrl"]];
                NSString *desc = [NSString stringValue:dict[@"txtImageDesc"]];
                if (image.length>0) {
                    LKEditSceneCellModel *info = [[LKEditSceneCellModel alloc] init];
                    info.type = LKEditRowType_pic;
                    info.picurl = image;
                    info.codImageUrl = image;
                    CGSize size = [UIImage getImageSizeWithURL:image];
                    info.imgWidth = [NSString stringWithFormat:@"%0f",size.width];
                    info.imgHeight = [NSString stringWithFormat:@"%0f",size.height];
                    [info juageCellHeight];
                    
                    [self.sceneDatas addObject:info];
                }
                if (desc.length>0) {
                    LKEditSceneCellModel *info = [[LKEditSceneCellModel alloc] init];
                    info.type = LKEditRowType_text;
                    info.txtImageDesc = desc;
                    info.data = desc;
                    [info juageCellHeight];
                    
                    [self.sceneDatas addObject:info];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        });
     
        
        [self addSubview:self.tableView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.toolView];
        
        self.contentCellHeight = 160;
        [[YYTextKeyboardManager defaultManager] addObserver:self];
        
        [self addNoticeForKeyboard];
    }
    return self;
}
#pragma mark - public

- (NSArray *)getRowContents {
    return [NSArray arrayWithArray:self.datas];
}

- (NSArray *)getSceneContents {
    return [NSArray arrayWithArray:self.sceneDatas];
    
}
- (void)addNoticeForKeyboard {
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    UIView *firstResponder = [UIResponder lk_currentFirstResponder];
    if ([firstResponder isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
        CGRect rect = [firstResponder convertRect:firstResponder.frame toView:self];
        NSLog(@"%@",NSStringFromCGRect(rect));
        
        //获取键盘高度，在不同设备上，以及中英文下是不同的
        CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        
        //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
        CGFloat offset = (rect.origin.y+rect.size.height+self.toolView.height
                          ) - (self.height - kbHeight);
        
        //    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
        double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        //将视图上移计算好的偏移
        if(offset > 0) {
            [UIView animateWithDuration:duration animations:^{
                self.top = -offset;
            } completion:^(BOOL finished) {
                
            }];
        }
    }
  
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
//    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    self.top = 0;
    self.toolView.top = kScreenHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return self.datas.count;
    } else {
        return self.sceneDatas.count+1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        LKWishEditRowCell *cell = [tableView dequeueReusableCellWithIdentifier:LKWishEditRowCellReuseIndentifier];
        cell.model = self.datas[indexPath.row];
        return cell;
    } else {
        if (indexPath.row==self.sceneDatas.count) {
            LKEditTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LKEditTextCell"];
            cell.placeholder = self.scenePlaceholder;
            self.editTextCell = cell;
            return cell;
        } else {
            LKEditSceneCellModel *info = [self.sceneDatas objectAt:indexPath.row];
            if (info.type==LKEditRowType_pic) {
                LKEditScenePicCell *cell = [tableView dequeueReusableCellWithIdentifier:kLKEditScenePicCellReuserIndentifier];
                cell.data = info;
                return cell;
            } else {
                LKEditSceneTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kLKEditSceneTextCellReuserIndentifier];
                cell.data = info;
                return cell;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
       return 50;
    } else {
        if (indexPath.row==self.sceneDatas.count) {
            return self.contentCellHeight;
        } else {
            LKEditSceneCellModel *info = [self.sceneDatas objectAt:indexPath.row];
            return info.cellHeight;
        }
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        return;
    }
    LKWishEditRowModel *model = [self.datas objectAt:indexPath.row];
   
    // 修改城市
    if (indexPath.row==1) {
        LKSelectCityViewController *vc = [[LKSelectCityViewController alloc] init];
        vc.isChoose = YES;
         @weakify(self);
        vc.selectCityBlock = ^(NSString *city_id, NSString *city_name) {
            @strongify(self);
            if (city_id.length>0) {
                model.desc = city_name;
                model.city_id = city_id;
                [self.tableView reloadData];
            }
        };
        [LKMediator pushViewController:vc animated:YES];
    } else if (indexPath.row==2) { // 景点名称
        LKDialogViewController *vc = [LKDialogViewController alertWithDialogType:LKDialogType_nickname title:@"输入景点名称"];
         @weakify(self);
        vc.sureBlock = ^(NSString *inputStr) {
            @strongify(self);
            model.desc = inputStr;
            [self.tableView reloadData];
        };
        [self.lk_viewController presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark @protocol YYTextKeyboardObserver
- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    UIView *firstResponder = [UIResponder lk_currentFirstResponder];
    if (![firstResponder isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
        return;
    }
    CGRect toFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:[UIApplication sharedApplication].keyWindow];
    if (transition.animationDuration == 0) {
        _toolView.bottom = CGRectGetMinY(toFrame);
    } else {
        [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption | UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (CGRectGetHeight(toFrame)==0) {
                _toolView.top = kScreenHeight;
            } else {
                _toolView.bottom = CGRectGetMinY(toFrame);;
            }
        } completion:NULL];
    }
}

@end
