//
//  ViewController.m
//  FlexImageConductor
//
//  Created by 张家豪 on 2020/11/10.
//  Copyright © 2020 张家豪. All rights reserved.
//

#import "ViewController.h"

#import "IESLiveDropView.h"

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    IESLiveDropView *view = [[IESLiveDropView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:view];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
