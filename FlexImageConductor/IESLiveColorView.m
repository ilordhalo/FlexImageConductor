//
//  IESLiveColorView.m
//  FlexImageConductor
//
//  Created by zhangjiahao.me on 2021/2/8.
//  Copyright © 2021 张家豪. All rights reserved.
//

#import "IESLiveColorView.h"

@implementation IESLiveColorView

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    if (self.backgroundColor) {
        [self.backgroundColor setFill];
    } else {
        [[NSColor whiteColor] setFill];
    }
    
    NSRectFill(dirtyRect);
}

@end
