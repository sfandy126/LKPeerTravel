//
//  LKDialogViewController.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/14.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKDialogViewController.h"

#import "LKAlertPresentDelegate.h"

#import "MOKORecordButton.h"
#import "MOKORecorderTool.h"
#import <YYTextView.h>

#define kTFTag 100

@interface LKDialogViewController ()<UITextViewDelegate,MOKOSecretTrainRecorderDelegate,YYTextViewDelegate>

@property (nonatomic, strong) LKAlertPresentDelegate *presentDelegate;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *selectedGentleBtn;

@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, strong) NSMutableArray *selectedDatas;
@property (nonatomic, strong) MOKORecorderTool *recorder;
@property (nonatomic, strong) MOKORecordButton *recordButton;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *retryBtn;

@end

@implementation LKDialogViewController

+ (instancetype)alertWithDialogType:(LKDialogType)type title:(NSString *)title {
    LKDialogViewController *vc = [[LKDialogViewController alloc] init];
    vc.type = type;
    vc.titleStr = title;
    return vc;
}

- (instancetype)init {
    self = [super init];
    self.transitioningDelegate = self.presentDelegate;
    self.modalPresentationStyle = UIModalPresentationCustom;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
}

- (void)dismissAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareUI {
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [self.view addSubview:self.contentView];
    
    [self.view g_addTapWithTarget:self action:@selector(dismissAction)];
    
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.text = self.titleStr;
    
    CGFloat top = 0;
    if (self.type==LKDialogType_language||self.type==LKDialogType_wishLabel||self.type==LKDialogType_job||self.type==LKDialogType_hobby) {
        top = [self setupLanguageUI];
    } else if (self.type==LKDialogType_budget||self.type==LKDialogType_person||self.type==LKDialogType_nickname){
        top = [self setupSingleInputUI];
    } else if (self.type==LKDialogType_gentle) {
        top = [self setupGentleViewUI];
    } else if (self.type==LKDialogType_desc) {
        top = [self setupDescUI];
    } else if (self.type==LKDialogType_record) {
        top = [self setupRecordUI];
    }
    self.cancelBtn.top = top;
    self.sureBtn.top = top;
    [self.contentView addSubview:self.cancelBtn];
    [self.contentView addSubview:self.sureBtn];
    self.contentView.height = self.sureBtn.bottom;
    self.contentView.centerY = kScreenHeight*0.5;
}

/// 设置多标签选择UI
- (CGFloat)setupLanguageUI {
    [self.contentView addSubview:self.scrollView];
    self.scrollView.top = self.titleLabel.bottom+20;
    self.scrollView.height = 44*3+16*2;
    
    CGFloat top = self.scrollView.bottom+16;
    CGFloat width = (self.contentView.width-40-16)*0.5;
    
    id type = @"2";
    NSString *urlStr = @"tx/cif/customer/get/label/list";
    NSString *dataStr= @"hobbyList";
    NSString *typeStr = @"labelType";
    NSDictionary *dict = @{typeStr:type};
    NSString *descStr = @"codLabelName";
    if (self.type == LKDialogType_wishLabel) {
        LKPageInfo *page = [[LKPageInfo alloc] init];
        page.pageNum = 1;
        
        type = @(0);
        typeStr = @"pointType";
        urlStr = @"tx/cif/CosDestinationPoint/list";
        dataStr = @"dataList";
        dict = @{typeStr:type,@"page":[page modelToJSONObject],@"type":@(2)}; //@{@"pointType":@(self.point_type),@"customerNumber":self.customNum?self.customNum:[LKUserInfoUtils getUserNumber],@"page":[self.page modelToJSONObject]}
        descStr = @"codDestinationPointName";
    } else if (self.type == LKDialogType_job) {
        type = @"3";
        dict = @{typeStr:type};
    } else if (self.type==LKDialogType_hobby) {
        type = @"1";
        dict = @{typeStr:type};
    } else if (self.type==LKDialogType_language) {
        type = @"2";
        dict = @{typeStr:type};
    }
     @weakify(self);
    [LKHttpClient POST:urlStr parameters:dict progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        LKResult *result = [[LKResult alloc] initWithDict:responseObject];
        if (result.success) {
            NSArray *dataList = [NSArray getArray:result.data[dataStr]];
            CGFloat rows = ceil(dataList.count/2.0);
            self.scrollView.contentSize = CGSizeMake(0, rows*60);
            self.dataList = dataList;
            for (int i=0; i<dataList.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.layer.cornerRadius = 5;
                btn.layer.masksToBounds = YES;
                btn.frame = CGRectMake(20+i%2*(width+16), i/2*(44+16), width, 44);
                btn.backgroundColor = kColorGray6;
                [btn setTitleColor:kColorGray1 forState:UIControlStateNormal];
                btn.titleLabel.font = kFont(14);
                NSDictionary *dict = dataList[i];
                btn.tag = 10+i;
                [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitle:dict[descStr] forState:UIControlStateNormal];
                [self.scrollView addSubview:btn];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
    return top;
}

/// 单行输入框
- (CGFloat)setupSingleInputUI {
    CGFloat top = 0;
    CGFloat width = self.contentView.width-40;
    CGFloat originX = 20;
    CGFloat originY = self.titleLabel.bottom+20;
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, width, 44)];
    bg.backgroundColor = kColorGray6;
    bg.layer.cornerRadius = 3;
    bg.layer.masksToBounds = YES;
    [self.contentView addSubview:bg];
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(originX+5, originY, width-10, 44)];
    tf.font = kFont(14);
    tf.textColor = kColorGray1;
    tf.tag = kTFTag;
    if (self.type==LKDialogType_budget||self.type==LKDialogType_person) {
        tf.keyboardType = UIKeyboardTypeNumberPad;
    }
    originX = bg.right+16;
    [self.contentView addSubview:tf];
    
    top = bg.bottom;
    return top;
}

/// 设置性别
- (CGFloat)setupGentleViewUI {
    CGFloat top = 0;
    CGFloat width = (self.contentView.width-40-16)*0.5;;

    NSArray *titles = @[@"女",@"男"];
    for (NSString *title in titles) {
        NSUInteger i = [titles indexOfObject:title];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.frame = CGRectMake(20+i%2*(width+16), i/2*(44+16)+self.titleLabel.bottom+20, width, 44);
        btn.backgroundColor = kColorGray6;
        [btn setTitleColor:kColorGray1 forState:UIControlStateNormal];
        btn.titleLabel.font = kFont(14);
        btn.tag = i+1;
        [btn addTarget:self action:@selector(gentleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:title forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
        
        top = btn.bottom;
    }
    return top;
}

/// 自我介绍输入
- (CGFloat)setupDescUI {
    CGFloat top = self.titleLabel.bottom;
    CGFloat width = self.contentView.width-40;
    CGFloat originX = 20;
    CGFloat originY = self.titleLabel.bottom+20;
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, width, 150)];
    bg.backgroundColor = kColorGray6;
    bg.layer.cornerRadius = 3;
    bg.layer.masksToBounds = YES;
    [self.contentView addSubview:bg];
    
    UITextView *tf = [[UITextView alloc] initWithFrame:CGRectMake(originX+5, originY, width-10, 150)];
    tf.font = kFont(14);
    tf.textColor = kColorGray1;
    tf.tag = kTFTag;
    tf.delegate = self;
    tf.backgroundColor = [UIColor clearColor];
    tf.returnKeyType = UIReturnKeyDone;

    originX = bg.right+16;
    [self.contentView addSubview:tf];
    
    top = bg.bottom;
    return top;
}

- (CGFloat )setupRecordUI {
    CGFloat top = self.titleLabel.bottom;
    
    MOKORecordButton *recordBtn = [MOKORecordButton buttonWithType:UIButtonTypeCustom];
    recordBtn.frame = CGRectMake(0, self.titleLabel.bottom+48, 120, 120);
    recordBtn.layer.cornerRadius = recordBtn.height*0.5;
    recordBtn.layer.masksToBounds = YES;
    recordBtn.backgroundColor = [UIColor colorWithHexString:@"#007cff"];
    [recordBtn setTitle:@"长按录音" forState:UIControlStateNormal];
    [recordBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    recordBtn.titleLabel.font = kBFont(18);
    recordBtn.centerX = self.contentView.width*0.5;
    [self.contentView addSubview:recordBtn];
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame = CGRectMake(0, self.titleLabel.bottom+48, 120, 120);
    playBtn.layer.cornerRadius = playBtn.height*0.5;
    playBtn.layer.masksToBounds = YES;
    playBtn.backgroundColor = kColorYellow1;
    [playBtn setTitle:@"点击试听" forState:UIControlStateNormal];
    [playBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    playBtn.titleLabel.font = kBFont(18);
    playBtn.centerX = self.contentView.width*0.5;
    [self.contentView addSubview:playBtn];
    self.playBtn = playBtn;
    playBtn.hidden = YES;
    
    top = recordBtn.bottom+48;
    self.recordButton = recordBtn;
    
    UIButton *retryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    retryBtn.frame = CGRectMake(0, 0, 30, 20);
    [self.contentView addSubview:retryBtn];
    retryBtn.hidden = YES;
    
    UIImageView *retryIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_vedio_return_none"]];
    retryIV.frame = CGRectMake(6, 0, 18, 17);
    [retryBtn addSubview:retryIV];
    
    UILabel *label = [UILabel new];
    label.font = kFont(12);
    label.textColor = kColorGray2;
    label.frame = CGRectMake(0, retryIV.bottom, 30, ceil(label.font.lineHeight));
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"重试";
    [retryBtn addSubview:label];
    retryBtn.height = label.bottom;
    
    retryBtn.centerY = recordBtn.centerY;
    retryBtn.right = self.contentView.width-70;
    
    self.retryBtn = retryBtn;
    [retryBtn addTarget:self action:@selector(retryRecordAction) forControlEvents:UIControlEventTouchUpInside];
    
    [playBtn addTarget:self action:@selector(playRecordAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.recorder = [MOKORecorderTool sharedRecorder];
    self.recorder.delegate = self;
    
    [self toDoRecord];
    return top;
}

- (void)retryRecordAction {
    self.recordButton.hidden = NO;
    self.playBtn.hidden = YES;
    self.retryBtn.hidden = YES;
}

- (void)playRecordAction {
    [self.recorder playRecordingFile];
}

-(void)toDoRecord
{
    __weak typeof(self) weak_self = self;
    //手指按下
    self.recordButton.recordTouchDownAction = ^(MOKORecordButton *sender){
        //如果用户没有开启麦克风权限,不能让其录音
        if (![weak_self canRecord]) return;
        
        NSLog(@"开始录音");
        if (sender.highlighted) {
            sender.highlighted = YES;
            [sender setButtonStateWithRecording];
        }
        [weak_self.recorder startRecording];
//        weak_self.currentRecordState = MOKORecordState_Recording;
//        [weak_self dispatchVoiceState];
    };
    
    //手指抬起
    self.recordButton.recordTouchUpInsideAction = ^(MOKORecordButton *sender){
        NSLog(@"完成录音");
        [sender setButtonStateWithNormal];
        [weak_self.recorder stopRecording];
        weak_self.recordButton.hidden = YES;
        weak_self.playBtn.hidden = NO;
        weak_self.retryBtn.hidden = NO;
//        weak_self.currentRecordState = MOKORecordState_Normal;
//        [weak_self dispatchVoiceState];
    };
    
    //手指滑出按钮
    self.recordButton.recordTouchUpOutsideAction = ^(MOKORecordButton *sender){
        NSLog(@"取消录音");
        [sender setButtonStateWithNormal];
//        weak_self.currentRecordState = MOKORecordState_Normal;
//        [weak_self dispatchVoiceState];
    };
    
    //中间状态  从 TouchDragInside ---> TouchDragOutside
    self.recordButton.recordTouchDragExitAction = ^(MOKORecordButton *sender){
//        weak_self.currentRecordState = MOKORecordState_ReleaseToCancel;
//        [weak_self dispatchVoiceState];
    };
    
    //中间状态  从 TouchDragOutside ---> TouchDragInside
    self.recordButton.recordTouchDragEnterAction = ^(MOKORecordButton *sender){
        NSLog(@"继续录音");
//        weak_self.currentRecordState = MOKORecordState_Recording;
//        [weak_self dispatchVoiceState];
    };
}

//判断是否允许使用麦克风7.0新增的方法requestRecordPermission
-(BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                bCanRecord = YES;
            }
            else {
                bCanRecord = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:nil
                                                message:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"
                                               delegate:nil
                                      cancelButtonTitle:@"关闭"
                                      otherButtonTitles:nil] show];
                });
            }
        }];
    }
    return bCanRecord;
}

- (LKAlertPresentDelegate *)presentDelegate {
    if (!_presentDelegate) {
        _presentDelegate = [[LKAlertPresentDelegate alloc] init];
    }
    return _presentDelegate;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.frame = CGRectMake(20, 0, kScreenWidth-40, 0);
        [_contentView g_addTapWithTarget:self action:@selector(noAction)];
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kBFont(16);
        _titleLabel.textColor = kColorGray1;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.frame = CGRectMake(0, 20, _contentView.width, ceil(_titleLabel.font.lineHeight));
    }
    return _titleLabel;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.titleLabel.font = kFont(14);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:kColorGray4 forState:UIControlStateNormal];
        _cancelBtn.frame = CGRectMake(0, 0, _contentView.width*0.5, 40+ceil(kFont(14).lineHeight));
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.titleLabel.font = kBFont(14);
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:kColorYellow1 forState:UIControlStateNormal];
        _sureBtn.frame = CGRectMake(_contentView.width*0.5, 0, _contentView.width*0.5, 40+ceil(kFont(14).lineHeight));
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _sureBtn;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _contentView.width, 0)];
    }
    return _scrollView;
}

- (NSMutableArray *)selectedDatas {
    if (!_selectedDatas) {
        _selectedDatas = [NSMutableArray array];
    }
    return _selectedDatas;
}

- (void)cancelAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sureAction {
    if (self.type==LKDialogType_language||self.type==LKDialogType_wishLabel||self.type==LKDialogType_job||self.type==LKDialogType_hobby) {
        if (self.selectedDatas.count==0) {
            NSString *message = @"请选择语言";
            if (self.type==LKDialogType_wishLabel) {
                message = @"请选择心愿";
            } else if (self.type==LKDialogType_hobby) {
                message = @"请选择特长";
            }
            [LKUtils showMessage:message];
            return;
        }
        if (self.selectedLanguageBlock) {
            self.selectedLanguageBlock([NSArray arrayWithArray:self.selectedDatas]);
        }
    } else if (self.type==LKDialogType_person||self.type==LKDialogType_budget||self.type==LKDialogType_nickname||self.type==LKDialogType_desc) {
        NSString *text;
        if (self.type==LKDialogType_desc) {
            UITextView *tv = [self.contentView viewWithTag:kTFTag];
            text = tv.text;
        } else {
            UITextField *tf = [self.contentView viewWithTag:kTFTag];
            text = tf.text;
        }
        if (text.length==0) {
            [LKUtils showMessage:@"请输入内容"];
            return;
        }
        if (text.length>0) {
            if (self.sureBlock) {
                self.sureBlock(text);
            }
        }
    } else if (self.type==LKDialogType_gentle) {
        if (!_selectedGentleBtn) {
            [LKUtils showMessage:@"请选择性别"];
            return;
        }
        if (self.gentleBlock) {
            self.gentleBlock(_selectedGentleBtn.tag);
        }
    } else if (self.type==LKDialogType_record) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [path stringByAppendingPathComponent:MOKOSecretTrainRecordFielName];
        if (self.recordFinishBlock) {
            self.recordFinishBlock(filePath);
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)noAction{
    [self.view endEditing:YES];
}


- (void)btnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        sender.backgroundColor = kColorYellow1;
    } else {
        sender.backgroundColor = kColorGray6;
    }
    
    NSDictionary *dict = [self.dataList objectAt:sender.tag-10];
    if (dict) {
        if (sender.selected) {
            [self.selectedDatas addObject:dict];
        } else {
            [self.selectedDatas removeObject:dict];
        }
    }
}

- (void)gentleBtnAction:(UIButton *)sender {
    _selectedGentleBtn.backgroundColor = kColorGray6;
    sender.backgroundColor = kColorYellow1;
    _selectedGentleBtn = sender;
    
}

#pragma mark - - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"] && self.type==LKDialogType_desc) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
