//
//  LKImageBrowseViewController.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/2.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKImageBrowseViewController.h"
#import "LKImageBrowseCollectionViewCell.h"
#import "LKImageBrowseServer.h"
#import "LKBottomToolView.h"

@interface LKImageBrowseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *datalists;
@property (nonatomic,strong) LKImageBrowseServer *server;
@property (nonatomic,strong) LKBottomToolView *toolView;

@end

@implementation LKImageBrowseViewController

- (void)setParams:(NSDictionary *)params{
    _params = params;
    
    NSArray *imagesDicArr = [NSArray getArray:[params valueForKey:@"images"]];
    NSString *footprintNo = [NSString stringValue:[params valueForKey:@"foot_id"]];
    NSString *content = [NSString stringValue:[params valueForKey:@"content"]];
    self.server.model.curIndex = [[NSString stringValue:[params valueForKey:@"curIndex"]] integerValue];
    self.server.model.footprintNo = footprintNo;
    
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *imageDic in imagesDicArr) {
        LKImageBrowseSingleModel *item = [LKImageBrowseSingleModel modelWithDict:imageDic];
        if (item.footprintNo.length==0) {
            item.footprintNo = footprintNo;
        }
        item.content=content;
        [temp addObject:item];
    }
    self.server.model.list = [NSArray getArray:[temp copy]];
}

- (LKBottomToolView *)toolView{
    if (!_toolView) {
        _toolView = [[LKBottomToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        _toolView.backgroundColor = [UIColor blackColor];
    }
    return _toolView;
}

- (LKImageBrowseServer *)server{
    if (!_server) {
        _server = [[LKImageBrowseServer alloc] init];
    }
    return _server;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight);
        layout.minimumInteritemSpacing = CGFLOAT_MIN;
        layout.minimumLineSpacing = CGFLOAT_MIN;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#000000"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;

        [_collectionView registerClass:[LKImageBrowseCollectionViewCell class] forCellWithReuseIdentifier:kLKImageBrowseCollectionViewCellIdentify];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.collectionView];
    
    self.toolView.bottom = kScreenHeight;
    [self.view addSubview:self.toolView];
    
    @weakify(self);
    self.toolView.clickedBlcok = ^(LKBottomToolViewType type) {
        @strongify(self);
        if (type == LKBottomToolViewType_back) {
            [self.navigationController popViewControllerAnimated:NO];
        }
        if (type == LKBottomToolViewType_comment) {
            [self editContent];
        }
    };
    
    [self doneLoading];
    
    if (self.server.model.curIndex>0) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.server.model.curIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

- (void)editContent{
    LKDialogViewController *vc = [LKDialogViewController alertWithDialogType:LKDialogType_desc title:@"我要评论"];
    @weakify(self);
    vc.sureBlock = ^(NSString *inputStr) {
        @strongify(self);
        [self addComment:inputStr];
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}

///新增评论
- (void)addComment:(NSString *)intputStr{
    [self showLoadingView];
    @weakify(self);
    [self.server addCommentWithParams:@{@"commentCustomerNumber":[LKUserInfoUtils getUserNumber],@"footprintNo":[NSString stringValue:self.server.model.footprintNo],@"commentContent":[NSString stringValue:intputStr]} finishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
        [self doneLoading];
        [LKUtils showMessage:item.replyText];
        
    } failedBlock:^(NSError *error) {
        @strongify(self);
        [self hideLoadingView];
        [self doneLoading];
        [LKUtils showMessage:@"上传失败，请检查网络"];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datalists.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LKImageBrowseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLKImageBrowseCollectionViewCellIdentify forIndexPath:indexPath];
    LKImageBrowseSingleModel *item = [self.datalists objectAt:indexPath.item];
    [cell configData:item];
    return cell;
}

- (void)doneLoading{
    self.datalists = [NSArray getArray:self.server.model.list];
    [self.collectionView reloadData];
    [self.collectionView endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
