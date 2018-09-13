//
//  LKCitySearchView.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/11.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKCitySearchView.h"

static NSString *kLKSearchCityIdentify = @"kLKSearchCityIdentify";

@class LKCitySearchCell;
@interface LKCitySearchView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *datalists;

@end

@implementation LKCitySearchView

- (UITableView *)tableview{
    if(!_tableview){
        _tableview = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableview.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        _tableview.separatorColor = [UIColor clearColor];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [UIView new];
        [_tableview registerClass:[LKCitySearchCell class] forCellReuseIdentifier:kLKSearchCityIdentify];
    }
    return _tableview;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableview];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datalists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LKCitySearchCell *cell = [tableView dequeueReusableCellWithIdentifier:kLKSearchCityIdentify forIndexPath:indexPath];
    LKCityTagModel *item = [self.datalists objectAt:indexPath.row];
    if (item) {
        [cell configData:item];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [LKCitySearchCell getCellHeight:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LKCityTagModel *selectedItem = [self.datalists objectAt:indexPath.row];
    if (selectedItem && self.selectedBlock) {
        self.selectedBlock(selectedItem);
    }
    
    //重置其它行选择状态
    NSMutableArray *temp = [NSMutableArray array];
    for (LKCityTagModel *item in self.datalists) {
        if (item == selectedItem) {
            item.isSelected = YES;
        }else{
            item.isSelected = NO;
        }
        [temp addObject:item];
    }
    [self.tableview reloadData];
}

- (void)configData:(NSArray *)data{
    self.datalists = [NSArray getArray:data];
    self.tableview.height = self.height;
    [self.tableview reloadData];
}

@end

@interface LKCitySearchCell ()
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) LKCityTagModel *model;
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UIView *line;

@end

@implementation LKCitySearchCell

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.text = @"";
        _titleLab.font = [UIFont systemFontOfSize:14.0];
        _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLab.height = ceil(_titleLab.font.lineHeight);
        _titleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLab;
}

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
        _icon.image = [UIImage imageNamed:@"img_loading_choice"];
        _icon.hidden = YES;
    }
    return _icon;
}

- (void)createView{
    [super createView];
    
    [self.contentView addSubview:self.titleLab];
    
    [self.contentView addSubview:self.icon];
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    self.line.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [self.contentView addSubview:self.line];
}

- (void)configData:(id)data{
    [super configData:data];
    
    if (data && [data isKindOfClass:[LKCityTagModel class]]) {
        self.titleLab.left = 20;
        self.titleLab.centerY = self.height/2.0;
        
        self.icon.right = self.width -20;
        self.icon.centerY = self.height/2.0;
        self.line.bottom = self.height;
        
        _model = (LKCityTagModel *)data;
        self.titleLab.text = _model.title;
        
        self.icon.hidden = !_model.isSelected;
    }
  
}

+ (CGFloat)getCellHeight:(id)data{
    return 60;
}

@end
