//
//  IESLivePathView.h
//  FlexImageConductor
//
//  Created by zhangjiahao.me on 2021/3/14.
//  Copyright © 2021 张家豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSInteger, IESLivePathViewState) {
    IESLivePathViewStateNormal,
    IESLivePathViewStatePress,
    IESLivePathViewStateMove,
    IESLivePathViewStateResize
};

@interface IESLivePathView : NSView

@property (nonatomic, assign, readonly) CGPoint startPoint;
@property (nonatomic, assign, readonly) CGPoint endPoint;

@property (nonatomic, assign, readonly) IESLivePathViewState state;

+ (instancetype)drawWithStartPoint:(CGPoint)startPoint;

@end
