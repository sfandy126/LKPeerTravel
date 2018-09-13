//
//  LKEditSceneContentCell.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/16.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKEditSceneContentCell.h"

#import <YYTextView.h>

#import "LKEditTextCell.h"
#import "LKEditPictureCell.h"

#import "LKEditSceneCellModel.h"

static NSString *testCellID = @"LKEditTextCell";
static NSString *picCellId = @"LKEditPictureCell";





@interface LKEditSceneContentCell () <UITableViewDelegate,UITableViewDataSource>


@end

@implementation LKEditSceneContentCell

{
    UILabel *_titleLabel;
    UITableView *_tableView;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _titleLabel.textColor = kColorGray1;
    _titleLabel.frame = CGRectMake(20, 0, 100, 50);
    _titleLabel.text = @"景点介绍";
    [self.contentView addSubview:_titleLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(_titleLabel.left, 0, kScreenWidth-_titleLabel.left, 0.5)];
    line.backgroundColor = kColorLine1;
    [self.contentView addSubview:line];
    line.bottom = 50;
    
    /*
    YYTextView *textView = [YYTextView new];
    textView.font = kFont(14);
    textView.placeholderText = @"点击输入景点介绍";
    textView.placeholderTextColor = kColorGray2;
    textView.textColor = kColorGray1;
    textView.placeholderFont = kFont(14);
    textView.frame = CGRectMake(20, line.bottom+17, kScreenWidth-40, 150);
    [self.contentView addSubview:textView];
     */
    
    /*
    LKEditSceneInputView *inputView = [[LKEditSceneInputView alloc] initWithFrame:CGRectMake(0, line.bottom+17, kScreenWidth, 150)];
     @weakify(self);
    inputView.updateCellHeight = ^(CGFloat height) {
        @strongify(self);
        if (self.updateCellHeight) {
            self.updateCellHeight(height+50);
        }
    };
    [self.contentView addSubview:inputView];
    _inputView = inputView;
     */
    
    _datas = [NSMutableArray array];
    
    LKEditSceneCellModel *scene = [LKEditSceneCellModel new];
    scene.type = LKEditRowType_text;
    
    [_datas addObject:scene];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, line.bottom, kScreenWidth, 0) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[LKEditTextCell class] forCellReuseIdentifier:testCellID];
    [tableView registerClass:[LKEditPictureCell class] forCellReuseIdentifier:picCellId];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:tableView];
    _tableView = tableView;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat height = self.height-_tableView.top;
    if (height>_tableView.contentSize.height) {
        _tableView.height = height;
    } else {
        _tableView.height = _tableView.contentSize.height;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LKEditSceneCellModel *model = [_datas objectAtIndex:indexPath.section];
    if (model.type == LKEditRowType_text) {
        LKEditTextCell *cell = [tableView dequeueReusableCellWithIdentifier:testCellID];
        cell.model = model;
        return cell;
    } else if (model.type  == LKEditRowType_pic) {
        LKEditPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:picCellId];
        cell.data = model.data;
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LKEditSceneCellModel *model = [_datas objectAtIndex:indexPath.section];
    if (model.type==LKEditRowType_text) {
        return 200;
    } else if (model.type==LKEditRowType_pic) {
        return model.cellHeight;
    }
    return CGFLOAT_MIN;
}

- (void)insetImage:(UIImage *)image {
    LKEditSceneCellModel *model  = [_datas firstObject];
    
    LKEditSceneCellModel *pic = [LKEditSceneCellModel new];
    pic.type = LKEditRowType_pic;
    pic.data = image;
    
    [LKUploadManager uploadImage:image completeBlock:^(LKResult *ret, NSError *error) {
        if (ret.success) {
            pic.picurl = ret.data[@"data"];
        }
    }];
    
    if (model.type==LKEditRowType_text) {
        [_datas insertObject:pic atIndex:0];
    } else {
//        LKEditSceneCellModel *last = [_datas lastObject];
//        if (last.type==LKEditRowType_text&&last.data==nil) {
//             [_datas replaceObjectAtIndex:[_datas indexOfObject:last] withObject:pic];
//        } else {
            [_datas addObject:pic];
//        }
       
        
        LKEditSceneCellModel *text = [LKEditSceneCellModel new];
        text.type = LKEditRowType_text;
        [_datas addObject:text];
    }
    [_tableView reloadData];
    
    if (self.updateCellHeight) {
        self.updateCellHeight(_tableView.contentSize.height+_tableView.top);
    }
}



@end
