//
//  IESLiveDropView.m
//  FlexImageConductor
//
//  Created by 张家豪 on 2020/11/10.
//  Copyright © 2020 张家豪. All rights reserved.
//

#import "IESLiveDropView.h"

@interface IESLiveDropView ()

@end

@implementation IESLiveDropView

- (id)initWithFrame:(NSRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //注册文件拖动事件
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSPasteboardTypeFileURL, nil]];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    //注册文件拖动事件
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSPasteboardTypeFileURL, nil]];
}

- (void)dealloc {
    [self unregisterDraggedTypes];
}

//MARK: - private methods
//当文件被拖动到界面触发
- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
    
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
    if ( [[pboard types] containsObject:NSPasteboardTypeFileURL] ) {
        if (sourceDragMask & NSDragOperationLink) {
            return NSDragOperationLink;//拖动变成箭头
        } else if (sourceDragMask & NSDragOperationCopy) {
            return NSDragOperationCopy;//拖动会变成+号
        }
    }
    return NSDragOperationNone;
}

//当文件在界面中放手
-(BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender{
    NSPasteboard *zPasteboard = [sender draggingPasteboard];
    // 判断是否是单文件
//    if (zPasteboard.pasteboardItems.count <= 1) {
//        NSURL *url = [NSURL URLFromPasteboard:zPasteboard];
//        if (url && self.delegate) {
//            [self.delegate receivedFileUrl:url];
//        }
//    } else {
//        //多文件
//        NSArray *list = [zPasteboard propertyListForType:NSFilenamesPboardType];
//        NSMutableArray *urlList = [NSMutableArray array];
//        for (NSString *str in list) {
//            NSURL *url = [NSURL fileURLWithPath:str];
//            [urlList addObject:url];
//        }
//        if (urlList.count && self.delegate) {
//            [self.delegate receivedFileUrlList:urlList];
//        }
//    }
    return YES;
}

@end
