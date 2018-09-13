//
//  LKSelectCityMainView.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/8.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSelectCityMainView.h"
#import "LKSearchBarView.h"
#import "LKCityTagView.h"
#import "LKCitySearchView.h"

@interface LKSelectCityMainView ()<UISearchBarDelegate>
@property (nonatomic,strong) LKSearchBarView *searchBarView;
@property (nonatomic,strong) LKCityTagView *tagView;
@property (nonatomic,strong) LKCitySearchView *searchListView;

@property (nonatomic,strong) UIButton *sureBut;
@property (nonatomic,strong) UIButton *skipBut;

///选择的城市
@property (nonatomic,strong) LKCityTagModel *selected_city;

@property (nonatomic,assign) BOOL isChoose;

@end

@implementation LKSelectCityMainView

- (LKSearchBarView *)searchBarView{
    if (!_searchBarView) {
        _searchBarView = [[LKSearchBarView alloc] initWithFrame:CGRectMake(20, kStatusBarHeight, self.width-20*2, 27)];
        _searchBarView.canClick = YES;
        _searchBarView.delegate = self;
        _searchBarView.searchItemStyle = LKSearchItemStyle_location;
        _searchBarView.placeholderColor = [UIColor colorWithHexString:@"#c8c8c8"];
        _searchBarView.placeholder = @"为了您给客户提供精准的服务，请选择您提供服务的城市";
        _searchBarView.layer.cornerRadius = 4.0;
        _searchBarView.layer.masksToBounds = YES;
    }
    return _searchBarView;
}

- (UIButton *)sureBut{
    if (!_sureBut) {
        _sureBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBut.frame = CGRectMake(0, 0, 0,50);
        [_sureBut setTitle:@"确认" forState:UIControlStateNormal];
        _sureBut.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_sureBut setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [_sureBut addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        UIImage *bgImage =[UIImage imageNamed:@"btn_loading_get_none"];
        bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 10, 5, 10) resizingMode:UIImageResizingModeStretch];
        [_sureBut setBackgroundImage:bgImage forState:UIControlStateNormal];
        [_sureBut setBackgroundImage:bgImage forState:UIControlStateHighlighted];
    }
    return _sureBut;
}

- (UIButton *)skipBut{
    if (!_skipBut) {
        _skipBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipBut.frame = CGRectMake(0, 0, 0,50);
        [_skipBut setTitle:@"跳过" forState:UIControlStateNormal];
        _skipBut.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_skipBut setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [_skipBut addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
        UIImage *bgImage =[UIImage imageNamed:@"btn_loading_skip_none"];
        bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 10, 5, 10) resizingMode:UIImageResizingModeStretch];
        [_skipBut setBackgroundImage:bgImage forState:UIControlStateNormal];
        [_skipBut setBackgroundImage:bgImage forState:UIControlStateHighlighted];
    }
    return _skipBut;
}

- (LKCityTagView *)tagView{
    if (!_tagView) {
        _tagView = [[LKCityTagView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }
    return _tagView;
}

- (LKCitySearchView *)searchListView{
    if (!_searchListView) {
        _searchListView = [[LKCitySearchView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }
    return _searchListView;
}

- (void)sureAction{
    if (self.selected_city==nil && !self.isChoose) {
        [LKUtils showMessage:@"请选择城市"];
        return;
    }
    if (self.sureBlock) {
        self.sureBlock(self.selected_city.tag_id,self.selected_city.title);
    }
}

- (void)skipAction{
    if (self.skipBlock) {
        self.skipBlock();
    }
}

- (instancetype)initWithFrame:(CGRect)frame isChoose:(BOOL)isChoose
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.isChoose = isChoose;
        [self addSubview:self.searchBarView];
        
        self.skipBut.left = 42;
        self.skipBut.bottom = self.height -20;
        self.skipBut.width = self.width - self.skipBut.left*2;
        [self addSubview:self.skipBut];
        
        self.sureBut.left = self.skipBut.left;
        self.sureBut.width = self.skipBut.width;
        [self addSubview:self.sureBut];
        
        if (self.isChoose) {
            self.skipBut.hidden = YES;
            self.sureBut.bottom = self.height -20;
        }else{
            self.skipBut.hidden = NO;
            self.sureBut.bottom = self.skipBut.top -20;
        }
        
        
        self.tagView.top = self.searchBarView.bottom;
        self.tagView.height = self.sureBut.top -20 - self.tagView.top;
        [self addSubview:self.tagView];
        
        self.searchListView.top = self.searchBarView.bottom;
        self.searchListView.height = self.sureBut.top -20 - self.tagView.top;
        self.searchListView.hidden = YES;
        [self addSubview:self.searchListView];
        
        @weakify(self);
        self.tagView.selectedBlock = ^(LKCityTagModel *item) {
            @strongify(self);
            self.selected_city = item;
        };
        
        self.searchListView.selectedBlock = ^(LKCityTagModel *item) {
            @strongify(self);
            self.selected_city = item;
        };
        
    }
    return self;
}


#pragma mark - - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{

    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{

    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBarView.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self showListView:(searchText.length==0)];
    
    if (searchText.length>0) {
        [self refreshData];
        if (self.searchBlock) {
            self.searchBlock(searchText);
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBarView.searchBar resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchBarView.searchBar resignFirstResponder];
}

- (void)showListView:(BOOL)isShow{
    self.searchListView.hidden = isShow;
    self.tagView.hidden = !isShow;
}

- (void)refreshData{
    [self.tagView configData:self.server.model.tags];
    [self.searchListView configData:self.server.model.searchResult];
}

@end
