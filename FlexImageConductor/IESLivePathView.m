//
//  IESLivePathView.m
//  FlexImageConductor
//
//  Created by zhangjiahao.me on 2021/3/14.
//  Copyright © 2021 张家豪. All rights reserved.
//

#import "IESLivePathView.h"

#import "IESLiveColorView.h"

const CGFloat dotSize = 10;

typedef NS_ENUM(NSInteger, IESLivePathViewControlSignal) {
    IESLivePathViewControlSignalPress,
    IESLivePathViewControlSignalPan,
    IESLivePathViewControlSignalCancel
};

@interface IESLivePathDotView : IESLiveColorView

@property (nonatomic, strong) NSCursor *cursor;

@end

@implementation IESLivePathDotView

- (instancetype)initWithFrame:(NSRect)frame cursor:(NSCursor *)cursor
{
    self = [super initWithFrame:frame];
    if (self) {
        _cursor = cursor;
        self.wantsLayer = YES;
        self.layer.cornerRadius = self.bounds.size.width / 2.f;
        self.backgroundColor = [NSColor colorWithRed:54.f/255.f green:116.f/255.f blue:197.f/255.f alpha:1];
        self.layer.borderColor = [NSColor whiteColor].CGColor;
        self.layer.borderWidth = 1.f;
    }
    return self;
}

- (void)resetCursorRects
{
    [super resetCursorRects];
    [self addCursorRect:[self bounds] cursor:self.cursor];
}

@end

@interface IESLivePathView ()

@property (nonatomic, assign, readwrite) CGPoint startPoint;
@property (nonatomic, assign, readwrite) CGPoint endPoint;

@property (nonatomic, assign, readwrite) IESLivePathViewState state;
@property (nonatomic, weak) NSView *panView;

@property (nonatomic, strong) IESLivePathDotView *leftTopDot;
@property (nonatomic, strong) IESLivePathDotView *leftDot;
@property (nonatomic, strong) IESLivePathDotView *leftBottomDot;
@property (nonatomic, strong) IESLivePathDotView *rightTopDot;
@property (nonatomic, strong) IESLivePathDotView *rightDot;
@property (nonatomic, strong) IESLivePathDotView *rightBottomDot;
@property (nonatomic, strong) IESLivePathDotView *topDot;
@property (nonatomic, strong) IESLivePathDotView *bottomDot;

@property (nonatomic, strong) NSView *linePath;

@property (nonatomic, assign) CGRect originFrame;

@end

@implementation IESLivePathView

+ (instancetype)drawWithStartPoint:(CGPoint)startPoint
{
    return [[self alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y, dotSize * 1.5, dotSize * 1.5)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI
{
    self.wantsLayer = YES;
    self.layer.masksToBounds = NO;
    
    self.leftTopDot = [self createDotViewWithCursor:[[NSCursor alloc] initWithImage:[NSImage imageNamed:@"resize_cursor_b"] hotSpot:CGPointMake(8, 8)]];
    self.leftDot = [self createDotViewWithCursor:[NSCursor resizeLeftRightCursor]];
    self.leftBottomDot = [self createDotViewWithCursor:[[NSCursor alloc] initWithImage:[NSImage imageNamed:@"resize_cursor_a"] hotSpot:CGPointMake(8, 8)]];
    self.rightTopDot = [self createDotViewWithCursor:[[NSCursor alloc] initWithImage:[NSImage imageNamed:@"resize_cursor_a"] hotSpot:CGPointMake(8, 8)]];
    self.rightDot = [self createDotViewWithCursor:[NSCursor resizeLeftRightCursor]];
    self.rightBottomDot = [self createDotViewWithCursor:[[NSCursor alloc] initWithImage:[NSImage imageNamed:@"resize_cursor_b"] hotSpot:CGPointMake(8, 8)]];
    self.topDot = [self createDotViewWithCursor:[NSCursor resizeUpDownCursor]];
    self.bottomDot = [self createDotViewWithCursor:[NSCursor resizeUpDownCursor]];
    
    self.linePath = [[NSView alloc] init];
    self.linePath.translatesAutoresizingMaskIntoConstraints = NO;
    self.linePath.wantsLayer = YES;
    self.linePath.layer.borderColor = [NSColor whiteColor].CGColor;
    self.linePath.layer.borderWidth = 1.f;
    
    [self addSubview:self.linePath];
    [self addSubview:self.leftTopDot];
    [self addSubview:self.leftDot];
    [self addSubview:self.leftBottomDot];
    [self addSubview:self.topDot];
    [self addSubview:self.bottomDot];
    [self addSubview:self.rightTopDot];
    [self addSubview:self.rightDot];
    [self addSubview:self.rightBottomDot];
    
    NSPanGestureRecognizer *leftTopPan = [[NSPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.leftTopDot addGestureRecognizer:leftTopPan];
    
    NSPanGestureRecognizer *leftPan = [[NSPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.leftDot addGestureRecognizer:leftPan];
    
    NSPanGestureRecognizer *leftBottomPan = [[NSPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.leftBottomDot addGestureRecognizer:leftBottomPan];
    
    NSPanGestureRecognizer *rightPan = [[NSPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.rightDot addGestureRecognizer:rightPan];
    
    NSPanGestureRecognizer *rightTopPan = [[NSPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.rightTopDot addGestureRecognizer:rightTopPan];
    
    NSPanGestureRecognizer *rightBottomPan = [[NSPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.rightBottomDot addGestureRecognizer:rightBottomPan];
    
    NSPanGestureRecognizer *topPan = [[NSPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.topDot addGestureRecognizer:topPan];
    
    NSPanGestureRecognizer *bottomPan = [[NSPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.bottomDot addGestureRecognizer:bottomPan];
    
    NSPanGestureRecognizer *pan = [[NSPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:pan];
}

- (void)setupLayout
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftTopDot attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant: -dotSize / 2.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftTopDot attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant: -dotSize / 2.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftTopDot attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:dotSize]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftTopDot attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:dotSize]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftDot attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-dotSize / 2.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftDot attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftDot attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:dotSize]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftDot attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:dotSize]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftBottomDot attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-dotSize / 2.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftBottomDot attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:dotSize / 2.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftBottomDot attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:dotSize]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftBottomDot attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:dotSize]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightTopDot attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:dotSize / 2.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightTopDot attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:-dotSize / 2.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightTopDot attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:dotSize]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightTopDot attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:dotSize]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightDot attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:dotSize / 2.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightDot attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightDot attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:dotSize]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightDot attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:dotSize]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightBottomDot attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:dotSize / 2.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightBottomDot attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:dotSize / 2.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightBottomDot attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:dotSize]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightBottomDot attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:dotSize]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.topDot attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:-dotSize / 2.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.topDot attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.topDot attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:dotSize]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.topDot attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:dotSize]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomDot attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:dotSize / 2.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomDot attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomDot attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:dotSize]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomDot attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:dotSize]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.linePath attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.linePath attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.linePath attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.linePath attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}

- (void)resetCursorRects
{
    [super resetCursorRects];
    
    switch (self.state) {
        case IESLivePathViewStateNormal:
        {
            [self removeCursorRect:[self bounds] cursor:[NSCursor closedHandCursor]];
            [self addCursorRect:[self bounds] cursor:[NSCursor openHandCursor]];
            break;
        }
        case IESLivePathViewStatePress:
        case IESLivePathViewStateMove:
        {
            [self removeCursorRect:[self bounds] cursor:[NSCursor openHandCursor]];
            [self addCursorRect:[self bounds] cursor:[NSCursor closedHandCursor]];
            break;
        }
        case IESLivePathViewStateResize:
        {
            [self removeCursorRect:[self bounds] cursor:[NSCursor openHandCursor]];
            [self removeCursorRect:[self bounds] cursor:[NSCursor closedHandCursor]];
            break;
        }
        default:
            break;
    }
}

- (NSView *)hitTest:(NSPoint)point
{
    [self handleSignal:IESLivePathViewControlSignalPress];
    
    NSView *view = [super hitTest:point];
    CGPoint pointToTest = [self convertPoint:point fromView:self.superview];
    if (!view) {
        for (NSView *subView in self.subviews) {
            CGRect subFrame = subView.frame;
            if (CGRectContainsPoint(subFrame, pointToTest)) {
                view = subView;
            }
        }
    }
    
    return view;
}

- (void)handleSignal:(IESLivePathViewControlSignal)signal
{
    switch (self.state) {
        case IESLivePathViewStateNormal:
        {
            if (signal == IESLivePathViewControlSignalPress) {
                self.state = IESLivePathViewStatePress;
            }
        }
            break;
        case IESLivePathViewStatePress:
        {
            if (signal == IESLivePathViewControlSignalPan) {
                if (self.panView != self) {
                    self.state = IESLivePathViewStateResize;
                } else {
                    self.state = IESLivePathViewStateMove;
                }
            } else if (signal == IESLivePathViewControlSignalCancel) {
                self.state = IESLivePathViewStateNormal;
            }
        }
            break;
        case IESLivePathViewStateMove:
        {
            if (signal == IESLivePathViewControlSignalCancel) {
                self.state = IESLivePathViewStateNormal;
            }
        }
            break;
        case IESLivePathViewStateResize:
        {
            if (signal == IESLivePathViewControlSignalCancel) {
                self.state = IESLivePathViewStateNormal;
            }
        }
            break;
        default:
            break;
    }
}

- (void)setState:(IESLivePathViewState)state
{
    if (self.state != state) {
        _state = state;
        
        [self resetCursorRects];
        [self setNeedsDisplay:YES];
    }
}

- (IESLivePathDotView *)createDotViewWithCursor:(NSCursor *)cursor
{
    IESLivePathDotView *view = [[IESLivePathDotView alloc] initWithFrame:CGRectMake(0, 0, dotSize, dotSize) cursor:cursor];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

- (void)handlePan:(NSPanGestureRecognizer *)pan
{
    if (pan.state == NSGestureRecognizerStateBegan) {
        self.panView = pan.view;
        [self handleSignal:IESLivePathViewControlSignalPan];
        
        self.originFrame = self.frame;
        
        [self resetCursorRects];
        
    } else if (pan.state == NSGestureRecognizerStateChanged) {
        [self handleSignal:IESLivePathViewControlSignalPan];
        
        CGPoint panPoint = [pan translationInView:self];
        
        CGFloat x = self.originFrame.origin.x;
        CGFloat y = self.originFrame.origin.y;
        CGFloat w = self.originFrame.size.width;
        CGFloat h = self.originFrame.size.height;
        
        CGFloat tx = x;
        CGFloat ty = y;
        CGFloat tw = w;
        CGFloat th = h;
        
        if (pan.view == self.rightBottomDot) {
            tx = x;
            ty = y + panPoint.y;
            tw = w + panPoint.x;
            th = h - panPoint.y;
        } else if (pan.view == self.rightTopDot) {
            tx = x;
            ty = y;
            tw = w + panPoint.x;
            th = h + panPoint.y;
        } else if (pan.view == self.rightDot) {
            tx = x;
            ty = y;
            tw = w + panPoint.x;
            th = h;
        } else if (pan.view == self.leftBottomDot) {
            tx = x + panPoint.x;
            ty = y + panPoint.y;
            tw = w - panPoint.x;
            th = h - panPoint.y;
        } else if (pan.view == self.leftDot) {
            tx = x + panPoint.x;
            ty = y;
            tw = w - panPoint.x;
            th = h;
        } else if (pan.view == self.leftTopDot) {
            tx = x + panPoint.x;
            ty = y;
            tw = w - panPoint.x;
            th = h + panPoint.y;
        } else if (pan.view == self.topDot) {
            tx = x;
            ty = y;
            tw = w;
            th = h + panPoint.y;
        } else if (pan.view == self.bottomDot) {
            tx = x;
            ty = y + panPoint.y;
            tw = w;
            th = h - panPoint.y;
        } else if (pan.view == self) {
            tx = x + panPoint.x;
            ty = y + panPoint.y;
            tw = w;
            th = h;
        }
        
        self.frame = [self convertFromFrame:CGRectMake(tx, ty, tw, th)];
        
        NSLog(@"ILDPan:(pan.x:%lf, pan.y:%lf)", panPoint.x, panPoint.y);
        NSLog(@"ILDPan:frame(%lf, %lf, %lf, %lf)", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        
        [self setNeedsDisplay:YES];
        [self layoutSubtreeIfNeeded];
    } else {
        self.panView = nil;
        [self handleSignal:IESLivePathViewControlSignalCancel];
        
        [self resetCursorRects];
    }
    
    NSLog(@"ILDPan:state:%ld", self.state);
}

- (CGRect)convertFromFrame:(CGRect)frame
{
    CGFloat x = frame.origin.x;
    CGFloat y = frame.origin.y;
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;
    
    CGFloat tx = x;
    CGFloat ty = y;
    CGFloat tw = w;
    CGFloat th = h;
    
    if (w < 0) {
        tw = -w;
        tx = x + w;
    }
    
    if (h < 0) {
        th = -h;
        ty = y + h;
    }
    
    return CGRectMake(tx, ty, tw, th);
}

@end
