//
//  IESLiveDropView.m
//  FlexImageConductor
//
//  Created by 张家豪 on 2020/11/10.
//  Copyright © 2020 张家豪. All rights reserved.
//

#import "IESLiveDropView.h"

@interface myPoint : NSObject {
    NSPoint myNSPoint;
}
- (id) initWithNSPoint:(NSPoint)pNSPoint;
- (NSPoint) myNSPoint;
- (float)x;
- (float)y;

@end

@implementation myPoint

- (id) initWithNSPoint:(NSPoint)pNSPoint;
{
    if ((self = [super init]) == nil) {
        return self;
    } // end if
    
    myNSPoint.x = pNSPoint.x;
    myNSPoint.y = pNSPoint.y;
    
    return self;
    
} // end initWithNSPoint

- (NSPoint) myNSPoint;
{
    return myNSPoint;
} // end myNSPoint

- (float)x;
{
    return myNSPoint.x;
} // end x

- (float)y;
{
    return myNSPoint.y;
} // end y

@end

@interface IESLiveDropView ()

@property (retain) NSMutableArray  * myMutaryOfBrushStrokes;
@property (retain) NSMutableArray  * myMutaryOfPoints;

@end

@implementation IESLiveDropView

//MARK: - life cycle
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

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    
    // colour the background white
    [[NSColor blackColor] set];        // this is Cocoa
    NSRectFill( dirtyRect );
    
    for (int i = 0; i < self.myMutaryOfPoints.count; i++) {
        
        // setup basic size and color properties
        float dm = 25;
        float rd = dm * 0.50;
        //   float qt = dm * 0.25;
        
        NSColor * white = [NSColor whiteColor];
     //   NSColor * black = [NSColor blackColor];
        
        NSBezierPath *path1;
        
        // find the center of the view
        float center = [self.myMutaryOfPoints[i] x];
        float middle = [self.myMutaryOfPoints[i] y];
        
        // create a rect in the center
        NSPoint origin  = { center - rd, middle - rd };
        NSRect mainOval = { origin.x, origin.y, dm, dm };
        
        // create a oval bezier path using the rect
        path1 = [NSBezierPath bezierPathWithOvalInRect:mainOval];
        [path1 setLineWidth:2.18];
        
        // draw the path
        [white set];[path1 fill];
       // [black set];[path1 stroke];
    
    //     NSRect myWhitePoint = NSMakeRect([myMutaryOfPoints[i] x], [myMutaryOfPoints[i] y], 10, 10);
    //    [[NSColor blueColor] set];
    //    NSRectFill(myWhitePoint);
    }
}

- (void)mouseDown:(NSEvent *)event
{
    if (!self.myMutaryOfPoints) {
           self.myMutaryOfPoints = [[NSMutableArray alloc]init];
       }
       
       [self.myMutaryOfBrushStrokes addObject:self.myMutaryOfPoints];
       
       NSPoint tvarMousePointInWindow = [event locationInWindow];
       NSPoint tvarMousePointInView   = [self convertPoint:tvarMousePointInWindow fromView:nil];
       myPoint * tvarMyPointObj       = [[myPoint alloc]initWithNSPoint:tvarMousePointInView];
       
       [self.myMutaryOfPoints addObject:tvarMyPointObj];
      //  NSLog(@"myMutaryOfPoints:%@",myMutaryOfPoints);
}

- (void)mouseDragged:(NSEvent *)event
{
    NSPoint tvarMousePointInWindow = [event locationInWindow];
     NSPoint tvarMousePointInView   = [self convertPoint:tvarMousePointInWindow fromView:nil];
     myPoint * tvarMyPointObj       = [[myPoint alloc]initWithNSPoint:tvarMousePointInView];
     
     [self.myMutaryOfPoints addObject:tvarMyPointObj];
     
     [self setNeedsDisplay:YES];
     
    // NSLog(@"myMutaryOfPoints:%@",myMutaryOfPoints);
}

- (void)mouseUp:(NSEvent *)event
{
    NSPoint tvarMousePointInWindow = [event locationInWindow];
       NSPoint tvarMousePointInView   = [self convertPoint:tvarMousePointInWindow fromView:nil];
       myPoint * tvarMyPointObj       = [[myPoint alloc]initWithNSPoint:tvarMousePointInView];
       
       [self.myMutaryOfPoints addObject:tvarMyPointObj];
       
       [self setNeedsDisplay:YES];
       
    //   NSPoint *locationData = (__bridge NSPoint *)([myMutaryOfPoints objectAtIndex:0]);
       
       NSLog(@"myMutaryOfPoints:%lu",(unsigned long)self.myMutaryOfPoints.count);
      // NSLog(@"myMutaryOfPoints:%f - %f",tvarMyPointObj.x,tvarMyPointObj.y);
       
      //  NSLog(@"myMutaryOfPoints:%f",[myMutaryOfPoints[0] x]);
}

@end
