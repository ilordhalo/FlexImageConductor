//
//  IESLiveControllerAreaView.h
//  FlexImageConductor
//
//  Created by zhangjiahao.me on 2021/2/8.
//  Copyright © 2021 张家豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface IESLiveControllerAreaView : NSView

@property (nonatomic, strong) NSColor *themeColor;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSString *buttonTitle;

@end
