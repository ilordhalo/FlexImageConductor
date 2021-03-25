//
//  IESLiveFlexImageControllerViewModel.m
//  FlexImageConductor
//
//  Created by zhangjiahao.me on 2021/3/4.
//  Copyright © 2021 张家豪. All rights reserved.
//

#import "IESLiveFlexImageControllerViewModel.h"

@interface IESLiveFlexImageControllerViewModel ()

@property (nonatomic, assign, readwrite) IESLiveFlexStruct flexSetting;
@property (nonatomic, assign, readwrite) IESLiveFlexStruct textSetting;

@property (nonatomic, assign, readwrite) IESLiveFlexImageControllerState controllerState;

@end

@implementation IESLiveFlexImageControllerViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self resetFlexSetting];
        [self resetTextSetting];
    }
    return self;
}

- (void)tapFlexButton
{
    switch (self.controllerState) {
        case IESLiveFlexImageControllerStateNormal:
        {
            self.controllerState = IESLiveFlexImageControllerStateDrawFlex;
            break;
        }
        case IESLiveFlexImageControllerStateDrawFlex:
        {
            self.controllerState = IESLiveFlexImageControllerStateNormal;
            break;
        }
        case IESLiveFlexImageControllerStateDrawText:
        {
            self.controllerState = IESLiveFlexImageControllerStateDrawFlex;
            break;
        }
    }
}

- (void)tapTextButton
{
    switch (self.controllerState) {
        case IESLiveFlexImageControllerStateNormal:
        {
            self.controllerState = IESLiveFlexImageControllerStateDrawText;
            break;
        }
        case IESLiveFlexImageControllerStateDrawText:
        {
            self.controllerState = IESLiveFlexImageControllerStateNormal;
            break;
        }
        case IESLiveFlexImageControllerStateDrawFlex:
        {
            self.controllerState = IESLiveFlexImageControllerStateDrawText;
            break;
        }
    }
}

- (void)updateWithFlexInfo:(IESLiveFlexStruct)flexInfo
{
    switch (self.controllerState) {
        case IESLiveFlexImageControllerStateDrawFlex:
        {
            self.flexSetting = flexInfo;
            break;
        }
        case IESLiveFlexImageControllerStateDrawText:
        {
            self.textSetting = flexInfo;
            break;
        }
        default:
        {
            self.flexSetting = flexInfo;
            break;
        }
    }
}

- (void)updateFlexInfoWithRect:(CGRect)rect
{
    CGFloat width = self.imageSize.width;
    CGFloat height = self.imageSize.height;
    
    CGFloat left_a = rect.origin.x;
    CGFloat right_a = width - rect.origin.x - rect.size.width;
    CGFloat top_a = rect.origin.y;
    CGFloat bottom_a = height - rect.origin.y - rect.size.height;
    
    if (left_a < 0) {
        left_a = 0;
    }
    if (left_a > rect.size.width) {
        left_a = rect.size.width;
    }
    
    if (right_a < 0) {
        right_a = 0;
    }
    if (right_a > rect.size.width) {
        right_a = rect.size.width;
    }
    
    if (top_a < 0) {
        top_a = 0;
    }
    if (top_a > rect.size.height) {
        top_a = rect.size.height;
    }
    
    if (bottom_a < 0) {
        bottom_a = 0;
    }
    if (bottom_a > rect.size.height) {
        bottom_a = rect.size.height;
    }
    
    NSInteger top = (NSInteger)(top_a / height * 100 + 0.5);
    NSInteger bottom = (NSInteger)(bottom_a / height * 100 + 0.5);
    NSInteger left = (NSInteger)(left_a / width * 100 + 0.5);
    NSInteger right = (NSInteger)(right_a / width * 100 + 0.5);
    
    [self updateWithFlexInfo:IESLiveFlexStructMake(top, bottom, left, right)];
}

- (void)setFlexSetting:(IESLiveFlexStruct)flexSetting
{
    _flexSetting = flexSetting;
    !self.dataSourceDidUpdate ?: self.dataSourceDidUpdate();
}

- (void)setTextSetting:(IESLiveFlexStruct)textSetting
{
    _textSetting = textSetting;
    !self.dataSourceDidUpdate ?: self.dataSourceDidUpdate();
}

- (void)resetFlexSetting
{
    self.flexSetting = IESLiveFlexStructMake(0, 0, 0, 0);
    !self.dataSourceDidUpdate ?: self.dataSourceDidUpdate();
}

- (void)resetTextSetting
{
    self.textSetting = IESLiveFlexStructMake(0, 0, 0, 0);
    !self.dataSourceDidUpdate ?: self.dataSourceDidUpdate();
}

@end
