//
//  IESLiveControllerPreviewView.m
//  FlexImageConductor
//
//  Created by zhangjiahao.me on 2021/2/8.
//  Copyright © 2021 张家豪. All rights reserved.
//

#import "IESLiveControllerPreviewView.h"

@interface IESLiveControllerPreviewView ()

@property (nonatomic, strong) NSTextField *titleField;
@property (nonatomic, strong) NSView *editArea;
@property (nonatomic, strong) NSTextField *descField;
@property (nonatomic, strong) NSTextView *contentTextView;
@property (nonatomic, strong) NSButton *button;

@end

@implementation IESLiveControllerPreviewView

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self addSubview:self.titleField];
    [self addSubview:self.editArea];
    [self.editArea addSubview:self.descField];
    [self.editArea addSubview:self.contentTextView];
    [self addSubview:self.button];
    
    [self setupLayout];
}

- (void)setupLayout
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleField attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.editArea attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleField attribute:NSLayoutAttributeBottom multiplier:1 constant:28]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.editArea attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.descField attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.editArea attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.descField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.editArea attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.descField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.editArea attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentTextView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.descField attribute:NSLayoutAttributeTrailing multiplier:1 constant:4]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentTextView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.editArea attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentTextView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:128]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.editArea attribute:NSLayoutAttributeBottom multiplier:1 constant:12]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:148]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:32]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-26]];
}

- (NSTextField *)titleField
{
    if (!_titleField) {
        _titleField = [[NSTextField alloc] init];
        _titleField.font = [NSFont systemFontOfSize:11 weight:NSFontWeightMedium];
        _titleField.textColor = [NSColor whiteColor];
        _titleField.translatesAutoresizingMaskIntoConstraints = NO;
        _titleField.editable = NO;
        _titleField.bezeled = NO;
        _titleField.backgroundColor = [NSColor clearColor];
        _titleField.stringValue = @"拉伸效果预览";
        [_titleField sizeToFit];
    }
    return _titleField;
}

- (NSTextField *)descField
{
    if (!_descField) {
        _descField = [[NSTextField alloc] init];
        _descField.font = [NSFont systemFontOfSize:14];
        _descField.textColor = [NSColor whiteColor];
        _descField.translatesAutoresizingMaskIntoConstraints = NO;
        _descField.editable = NO;
        _descField.bezeled = NO;
        _descField.backgroundColor = [NSColor clearColor];
        _descField.stringValue = @"内容：";
        [_descField sizeToFit];
    }
    return _descField;
}

- (NSTextView *)contentTextView
{
    if (!_contentTextView) {
        _contentTextView = [[NSTextView alloc] init];
        _contentTextView.font = [NSFont systemFontOfSize:14];
        _contentTextView.textColor = [NSColor grayColor];
        _contentTextView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _contentTextView;
}

- (NSButton *)button
{
    if (!_button) {
        _button = [[NSButton alloc] init];
        [_button setFont:[NSFont systemFontOfSize:14]];
        _button.translatesAutoresizingMaskIntoConstraints = NO;
        _button.bezelStyle = NSBezelStyleRounded;
        [_button setTitle:@"打开效果预览"];
    }
    return _button;
}

- (NSView *)editArea
{
    if (!_editArea) {
        _editArea = [[NSView alloc] init];
        _editArea.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _editArea;
}

@end
