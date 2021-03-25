//
//  ViewController.m
//  FlexImageConductor
//
//  Created by 张家豪 on 2020/11/10.
//  Copyright © 2020 张家豪. All rights reserved.
//

#import "ViewController.h"

#import "IESLiveDropView.h"
#import "IESLiveFlexImageControllerView.h"
#import "IESLiveColorView.h"
#import "IESLiveOperationView.h"
#import "IESLiveFlexImageControllerViewModel.h"

@interface ViewController () <IESLiveOperationViewDelegate>

@property (nonatomic, strong) IESLiveColorView *backgroundView;
@property (nonatomic, strong) NSView *workSpace;
@property (nonatomic, strong) NSImageView *imageView;
@property (nonatomic, strong) IESLiveDropView *dropView;
@property (nonatomic, strong) IESLiveFlexImageControllerView *controllerView;
@property (nonatomic, strong) IESLiveOperationView *operationView;

@property (nonatomic, assign) CGSize originImageSize;

@property (nonatomic, strong) IESLiveFlexImageControllerViewModel *flexImageControllerViewModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    IESLiveColorView *backgroundView = [[IESLiveColorView alloc] init];
    backgroundView.backgroundColor = [NSColor colorWithRed:29/255.f green:29/255.f blue:33/255.f alpha:1];
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:backgroundView];
    _backgroundView = backgroundView;
    
    NSView *workSpace = [[NSView alloc] init];
    workSpace.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:workSpace];
    _workSpace = workSpace;
    
    NSImageView *imageView = [[NSImageView alloc] initWithFrame:CGRectZero];
    imageView.imageScaling = NSImageScaleAxesIndependently;
    imageView.wantsLayer = YES;
    imageView.layer.borderColor = [NSColor grayColor].CGColor;
    imageView.layer.borderWidth = 1.f;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [workSpace addSubview:imageView];
    _imageView = imageView;

    IESLiveDropView *dropView = [[IESLiveDropView alloc] init];
    dropView.translatesAutoresizingMaskIntoConstraints = NO;
    [workSpace addSubview:dropView];
    _dropView = dropView;
    
    IESLiveOperationView *operationView = [[IESLiveOperationView alloc] init];
    operationView.delegate = self;
    operationView.translatesAutoresizingMaskIntoConstraints = NO;
    [workSpace addSubview:operationView];
    _operationView = operationView;
    
    IESLiveFlexImageControllerViewModel *ficViewModel = [[IESLiveFlexImageControllerViewModel alloc] init];
    _flexImageControllerViewModel = ficViewModel;
    
    IESLiveFlexImageControllerView *controllerView = [[IESLiveFlexImageControllerView alloc] initWithFrame:CGRectZero viewModel:ficViewModel];
    [self.view addSubview:controllerView];
    controllerView.translatesAutoresizingMaskIntoConstraints = NO;
    _controllerView = controllerView;
    
    [self addLayout];
    
    [self loadImage];
}

- (void)addLayout
{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.workSpace attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.workSpace attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.workSpace attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.workSpace attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.controllerView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.workSpace attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:440]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.workSpace attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.workSpace attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.dropView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.workSpace attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.dropView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.workSpace attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.dropView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.workSpace attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.dropView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.workSpace attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.operationView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.workSpace attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.operationView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.workSpace attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.operationView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.workSpace attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.operationView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.workSpace attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.controllerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.controllerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.controllerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:420]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.controllerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.controllerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:320]];
}

- (void)loadImage
{
    NSImage *image = [NSImage imageNamed:@"demo_tip"];
    self.originImageSize = image.size;
    self.flexImageControllerViewModel.imageSize = image.size;
    self.imageView.image = image;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

# pragma mark - IESLiveOperationViewDelegate

- (void)didZoomWithScale:(CGFloat)scale
{
    [self.view removeConstraints:self.view.constraints];

    [self addLayout];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:self.originImageSize.width + self.originImageSize.width * scale]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:self.originImageSize.height + self.originImageSize.height * scale]];
    
    [self.view updateConstraints];
    
    NSLog(@"IESLiveDropScale:%f", scale);
}

- (void)didUpdateSelectRect:(CGRect)rect
{
    NSLog(@"IESLiveDropRect:(%f, %f, %f, %f)", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    CGRect selectRect = CGRectIntersection(rect, self.imageView.frame);
    selectRect.origin.x -= self.imageView.frame.origin.x;
    selectRect.origin.y -= self.imageView.frame.origin.y;
    NSLog(@"IESLiveDropRect-select:(%f, %f, %f, %f)", selectRect.origin.x, selectRect.origin.y, selectRect.size.width, selectRect.size.height);
    
    self.flexImageControllerViewModel.imageSize = self.imageView.bounds.size;
    [self.flexImageControllerViewModel updateFlexInfoWithRect:selectRect];
}

@end
