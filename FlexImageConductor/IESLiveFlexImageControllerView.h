//
//  IESLiveFlexImageControllerView.h
//  FlexImageConductor
//
//  Created by zhangjiahao.me on 2021/2/2.
//  Copyright © 2021 张家豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@class IESLiveFlexImageControllerViewModel;
@interface IESLiveFlexImageControllerView : NSView

- (instancetype)initWithFrame:(CGRect)frame viewModel:(IESLiveFlexImageControllerViewModel *)viewModel;

@end
