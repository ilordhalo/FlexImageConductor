//
//  IESLiveFlexImageControllerViewModel.h
//  FlexImageConductor
//
//  Created by zhangjiahao.me on 2021/3/4.
//  Copyright © 2021 张家豪. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IESLiveFICDefine.h"

typedef NS_ENUM(NSInteger, IESLiveFlexImageControllerState) {
    IESLiveFlexImageControllerStateNormal,
    IESLiveFlexImageControllerStateDrawFlex,
    IESLiveFlexImageControllerStateDrawText
};

@interface IESLiveFlexImageControllerViewModel : NSObject

@property (nonatomic, assign) CGSize imageSize;

@property (nonatomic, assign, readonly) IESLiveFlexStruct flexSetting;
@property (nonatomic, assign, readonly) IESLiveFlexStruct textSetting;

@property (nonatomic, strong) dispatch_block_t dataSourceDidUpdate;

@property (nonatomic, assign, readonly) IESLiveFlexImageControllerState controllerState;

- (void)tapFlexButton;
- (void)tapTextButton;

- (void)updateWithFlexInfo:(IESLiveFlexStruct)flexInfo;
- (void)updateFlexInfoWithRect:(CGRect)rect;

@end
