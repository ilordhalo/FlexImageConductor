//
//  IESLiveOperationView.m
//  FlexImageConductor
//
//  Created by zhangjiahao.me on 2021/2/8.
//  Copyright © 2021 张家豪. All rights reserved.
//

#import "IESLiveOperationView.h"

#import "IESLivePathView.h"

@interface IESLiveOperationView ()

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;

@property (nonatomic, assign) CGFloat zoomScale;

@end

@implementation IESLiveOperationView

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _zoomScale = 1.f;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

//    CGFloat width = self.endPoint.x - self.startPoint.x;
//    CGFloat height = self.endPoint.y - self.startPoint.y;
//    CGPoint originPoint = self.startPoint;
//    CGRect mappedRect = CGRectMake(originPoint.x, originPoint.y, width, height);
//    NSBezierPath *path;
//    path = [NSBezierPath bezierPathWithRect:mappedRect];
//    CGFloat dash[] = {5, 5, 5};
//    [path setLineDash:dash count:3 phase:0];
//    [path setLineWidth:1.f];
//    [[NSColor colorWithRed:0 green:86/255.f blue:198/255.f alpha:1] set];
//    [path stroke];
//
//    [self.delegate didUpdateSelectRect:[self selectRectFromStartPoint:self.startPoint endPoint:self.endPoint]];
}

- (void)mouseDown:(NSEvent *)event
{
    NSPoint tvarMousePointInWindow = [event locationInWindow];
    NSPoint tvarMousePointInView   = [self convertPoint:tvarMousePointInWindow fromView:nil];
    
    self.startPoint = tvarMousePointInView;
    
    IESLivePathView *pathView = [IESLivePathView drawWithStartPoint:self.startPoint];
    [self addSubview:pathView];
    [self setNeedsDisplay:YES];
}

- (void)mouseDragged:(NSEvent *)event
{
    if (!CGPointEqualToPoint(self.startPoint, CGPointZero)) {
        NSPoint tvarMousePointInWindow = [event locationInWindow];
        NSPoint tvarMousePointInView   = [self convertPoint:tvarMousePointInWindow fromView:nil];
        
        self.endPoint = tvarMousePointInView;
    }
     
     [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)event
{
    if (!CGPointEqualToPoint(self.startPoint, CGPointZero)) {
        NSPoint tvarMousePointInWindow = [event locationInWindow];
        NSPoint tvarMousePointInView   = [self convertPoint:tvarMousePointInWindow fromView:nil];
        
        self.endPoint = tvarMousePointInView;
    }

    [self setNeedsDisplay:YES];
}

- (void)magnifyWithEvent:(NSEvent *)event
{
    [super magnifyWithEvent:event];
    
    if (event.phase == NSEventPhaseChanged) {
        self.zoomScale += event.deltaZ;
    } else if (event.phase == NSEventPhaseBegan) {
    } else if (event.phase == NSEventPhaseEnded) {
    }
}

- (void)setZoomScale:(CGFloat)zoomScale
{
    _zoomScale = zoomScale;
    
    [self setNeedsDisplay:YES];
    [self.delegate didZoomWithScale:zoomScale / 800.f];
}

- (CGRect)selectRectFromStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    BOOL negativeH = NO;
    BOOL negativeP = NO;
    
    if (endPoint.x < startPoint.x) {
        negativeH = YES;
    }
    if (endPoint.y < startPoint.y) {
        negativeP = YES;
    }
    
    CGPoint point = CGPointZero;
    CGSize size = CGSizeZero;
    if (negativeH) {
        point.x = endPoint.x;
        size.width = startPoint.x - endPoint.x;
    } else {
        point.x = startPoint.x;
        size.width = endPoint.x - startPoint.x;
    }
    
    if (negativeP) {
        point.y = endPoint.y;
        size.height = startPoint.y - endPoint.y;
    } else {
        point.y = startPoint.y;
        size.height = endPoint.y - startPoint.y;
    }
    
    // point为左下角坐标
    return CGRectMake(point.x, self.bounds.size.height - size.height - point.y, size.width, size.height);
}

@end
