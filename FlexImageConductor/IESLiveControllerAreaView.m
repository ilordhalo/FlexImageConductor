//
//  IESLiveControllerAreaView.m
//  FlexImageConductor
//
//  Created by zhangjiahao.me on 2021/2/8.
//  Copyright © 2021 张家豪. All rights reserved.
//

#import "IESLiveControllerAreaView.h"

@interface IESLiveControllerAreaView ()

@property (nonatomic, strong) NSView *area;
@property (nonatomic, strong) NSTextField *titleField;
@property (nonatomic, strong) NSTextField *infoField;
@property (nonatomic, strong) NSButton *button;

@end

@implementation IESLiveControllerAreaView

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
    [self addSubview:self.infoField];
    [self addSubview:self.button];
    
    [self setupLayout];
}

- (void)setupLayout
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleField attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.infoField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleField attribute:NSLayoutAttributeBottom multiplier:1 constant:26]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.infoField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.infoField attribute:NSLayoutAttributeBottom multiplier:1 constant:12]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:148]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:32]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-26]];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleField.stringValue = title;
}

- (void)setInfo:(NSString *)info
{
    _info = info;
    self.infoField.stringValue = info;
}

- (void)setButtonTitle:(NSString *)buttonTitle
{
    _buttonTitle = buttonTitle;
    [self.button setTitle:buttonTitle];
}

- (NSView *)area
{
    if (!_area) {
        _area = [[NSView alloc] init];
        _area.translatesAutoresizingMaskIntoConstraints = NO;
        _area.wantsLayer = YES;
        _area.layer.borderWidth = 1.f;
        _area.layer.borderColor = [NSColor colorWithRed:63/255.f green:65/255.f blue:66/255.f alpha:1].CGColor;
    }
    return _area;
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
        [_titleField sizeToFit];
    }
    return _titleField;
}

- (NSTextField *)infoField
{
    if (!_infoField) {
        _infoField = [[NSTextField alloc] init];
        _infoField.font = [NSFont systemFontOfSize:20];
        _infoField.textColor = [NSColor colorWithRed:159/255.f green:160/255.f blue:161/255.f alpha:1];
        _infoField.translatesAutoresizingMaskIntoConstraints = NO;
        _infoField.editable = NO;
        _infoField.bezeled = NO;
        _infoField.backgroundColor = [NSColor clearColor];
        [_infoField sizeToFit];
    }
    return _infoField;
}

- (NSButton *)button
{
    if (!_button) {
        _button = [[NSButton alloc] init];
        [_button setFont:[NSFont systemFontOfSize:14]];
        _button.translatesAutoresizingMaskIntoConstraints = NO;
        _button.bezelStyle = NSBezelStyleRounded;
    }
    return _button;
}

@end
