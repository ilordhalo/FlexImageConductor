//
//  IESLiveOperationView.h
//  FlexImageConductor
//
//  Created by zhangjiahao.me on 2021/2/8.
//  Copyright © 2021 张家豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@protocol IESLiveOperationViewDelegate <NSObject>

- (void)didZoomWithScale:(CGFloat)scale;
- (void)didUpdateSelectRect:(CGRect)rect;

@end

@interface IESLiveOperationView : NSView

@property (nonatomic, assign, readonly) CGFloat zoomScale;

@property (nonatomic, weak) id<IESLiveOperationViewDelegate> delegate;

@end
