//
//  IESLiveFlexImageControllerView.m
//  FlexImageConductor
//
//  Created by zhangjiahao.me on 2021/2/2.
//  Copyright © 2021 张家豪. All rights reserved.
//

#import "IESLiveFlexImageControllerView.h"

#import "IESLiveControllerAreaView.h"
#import "IESLiveControllerPreviewView.h"
#import "IESLiveFlexImageControllerViewModel.h"

@interface IESLiveFlexImageControllerView ()

@property (nonatomic, strong) IESLiveFlexImageControllerViewModel *viewModel;

@property (nonatomic, strong) NSView *contentView;

@property (nonatomic, strong) IESLiveControllerAreaView *flexArea;
@property (nonatomic, strong) IESLiveControllerAreaView *textArea;
@property (nonatomic, strong) IESLiveControllerPreviewView *previewView;

@end

@implementation IESLiveFlexImageControllerView

- (instancetype)initWithFrame:(CGRect)frame viewModel:(IESLiveFlexImageControllerViewModel *)viewModel
{
    self = [super initWithFrame:frame];
    if (self) {
        _viewModel = viewModel;
        
        [self setupUI];
        [self bindViewModel];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [[NSColor colorWithRed:42/255.f green:44/255.f blue:46/255.f alpha:1] setFill];
    NSRectFill(dirtyRect);
}

- (void)setupUI
{
    self.wantsLayer = YES;
    self.layer.borderWidth = 1.f;
    self.layer.borderColor = [NSColor blackColor].CGColor;
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.flexArea];
    [self.contentView addSubview:self.textArea];
    [self.contentView addSubview:self.previewView];
    
    [self setupLayout];
}

- (void)setupLayout
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.flexArea attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.flexArea attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.flexArea attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textArea attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.flexArea attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textArea attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textArea attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.previewView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.textArea attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.previewView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.previewView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
}

- (void)bindViewModel
{
    [self updateFlexInfoWithFlexSetting:self.viewModel.flexSetting];
    [self updateTextInfoWithFlexSetting:self.viewModel.textSetting];
    
    __weak typeof(self) weakSelf = self;
    self.viewModel.dataSourceDidUpdate = ^{
        __strong typeof(self) strongSelf = weakSelf;
        
        [strongSelf updateFlexInfoWithFlexSetting:strongSelf.viewModel.flexSetting];
        [strongSelf updateTextInfoWithFlexSetting:strongSelf.viewModel.textSetting];
    };
}

- (void)updateFlexInfoWithFlexSetting:(IESLiveFlexStruct)flexSetting
{
    self.flexArea.info = [NSString stringWithFormat:@"flex_setting: (%ld, %ld, %ld, %ld)", self.viewModel.flexSetting.top, self.viewModel.flexSetting.bottom, self.viewModel.flexSetting.left, self.viewModel.flexSetting.right];
}

- (void)updateTextInfoWithFlexSetting:(IESLiveFlexStruct)flexSetting
{
    self.textArea.info = [NSString stringWithFormat:@"text_setting: (%ld, %ld, %ld, %ld)", self.viewModel.textSetting.top, self.viewModel.textSetting.bottom, self.viewModel.textSetting.left, self.viewModel.textSetting.right];
}

- (NSView *)contentView
{
    if (!_contentView) {
        _contentView = [[NSView alloc] init];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _contentView;
}

- (IESLiveControllerAreaView *)flexArea
{
    if (!_flexArea) {
        _flexArea = [[IESLiveControllerAreaView alloc] init];
        _flexArea.translatesAutoresizingMaskIntoConstraints = NO;
        _flexArea.wantsLayer = YES;
        _flexArea.layer.borderWidth = 1.f;
        _flexArea.layer.borderColor = [NSColor colorWithRed:63/255.f green:65/255.f blue:66/255.f alpha:1].CGColor;
        _flexArea.title = @"图片拉伸区域(flex_setting)";
        _flexArea.buttonTitle = @"设置拉伸区域";
    }
    return _flexArea;
}

- (IESLiveControllerAreaView *)textArea
{
    if (!_textArea) {
        _textArea = [[IESLiveControllerAreaView alloc] init];
        _textArea.translatesAutoresizingMaskIntoConstraints = NO;
        _textArea.wantsLayer = YES;
        _textArea.layer.borderWidth = 1.f;
        _textArea.layer.borderColor = [NSColor colorWithRed:63/255.f green:65/255.f blue:66/255.f alpha:1].CGColor;
        _textArea.title = @"文字展示区域(text_setting)";
        _textArea.buttonTitle = @"设置文字区域";
    }
    return _textArea;
}

- (IESLiveControllerPreviewView *)previewView
{
    if (!_previewView) {
        _previewView = [[IESLiveControllerPreviewView alloc] init];
        _previewView.translatesAutoresizingMaskIntoConstraints = NO;
        _previewView.wantsLayer = YES;
        _previewView.layer.borderWidth = 1.f;
        _previewView.layer.borderColor = [NSColor colorWithRed:63/255.f green:65/255.f blue:66/255.f alpha:1].CGColor;
    }
    return _previewView;
}

@end
