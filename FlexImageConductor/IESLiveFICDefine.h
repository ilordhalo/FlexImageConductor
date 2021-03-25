//
//  IESLiveFICDefine.h
//  FlexImageConductor
//
//  Created by zhangjiahao.me on 2021/3/4.
//  Copyright © 2021 张家豪. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef IESLIVEFICDEFINE_H_
#define IESLIVEFICDEFINE_H_

struct IESLiveFlexStruct {
    NSInteger top;
    NSInteger bottom;
    NSInteger left;
    NSInteger right;
};
typedef struct __attribute__((objc_boxable)) IESLiveFlexStruct IESLiveFlexStruct;

static inline IESLiveFlexStruct IESLiveFlexStructMake(NSInteger top, NSInteger bottom, NSInteger left, NSInteger right)
{
    IESLiveFlexStruct flex;
    flex.top = top;
    flex.bottom = bottom;
    flex.left = left;
    flex.right = right;
    return flex;
}

#endif
