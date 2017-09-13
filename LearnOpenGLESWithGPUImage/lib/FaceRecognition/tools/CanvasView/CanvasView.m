//
//  CanvasView.m
//  Created by sluin on 15/7/1.
//  Copyright (c) 2015年 SunLin. All rights reserved.
//

#import "CanvasView.h"
#import <Foundation/Foundation.h>

@interface CanvasView ()

//头部贴图
@property (nonatomic,strong) UIImageView *  headMapView;
//眼睛贴图
@property (nonatomic,strong) UIImageView * eyesMapView;
//鼻子贴图
@property (nonatomic,strong) UIImageView * noseMapView;
//嘴巴贴图
@property (nonatomic,strong) UIImageView * mouthMapView;
//面部贴图
@property (nonatomic,strong) UIImageView * facialTextureMapView;

@property (assign,nonatomic) CGPoint lastCenterPoint;
@property (strong,nonatomic) NSArray *lastArr;
@property (assign,nonatomic) CGPoint lastMiddlePoint;
@property (assign,nonatomic) CGFloat lastRotation;
@property (strong,nonatomic) UIImage *lastImage;

@property (strong,nonatomic) NSMutableArray *tenArr;
@end

@implementation CanvasView{
    CGContextRef context ;
}

-(UIImageView *) headMapView{
    if(_headMapView == nil){
        
        self.lastCenterPoint = CGPointZero;
        _headMapView = [[UIImageView alloc] init];
        [self addSubview:_headMapView];
//        self.headMapView.layer.anchorPoint = CGPointMake(0.5, 1);
        
    }
    return _headMapView;
}


-(void) setHeadMap:(UIImage *)headMap{
    if (_headMap != headMap) {
        _headMap = headMap;
        self.headMapView.image = _headMap;
    }
}

- (void)drawRect:(CGRect)rect {
    [self drawPointWithPoints:self.arrPersons] ;
}


#pragma mark - 人脸识别数据
 /*
 "landmark" : {
 "left_eye_left_corner" : {
 "x" : 292,
 "y" : 360
 },
 "left_eye_right_corner" : {
 "x" : 289,
 "y" : 306
 },
 "nose_left" : {
 "x" : 346,
 "y" : 315
 },
 "right_eye_right_corner" : {
 "x" : 296,
 "y" : 175
 },
 "nose_bottom" : {
 "x" : 354,
 "y" : 276
 },
 "mouth_left_corner" : {
 "x" : 417,
 "y" : 341
 },
 "mouth_middle" : {
 "x" : 411,
 "y" : 282
 },
 "right_eyebrow_right_corner" : {
 "x" : 267,
 "y" : 155
 },
 "mouth_lower_lip_bottom" : {
 "x" : 437,
 "y" : 283
 },
 "right_eye_center" : {
 "x" : 288,
 "y" : 202
 },
 "left_eye_center" : {
 "x" : 286,
 "y" : 334
 },
 "right_eyebrow_left_corner" : {
 "x" : 251,
 "y" : 236
 },
 "nose_top" : {
 "x" : 322,
 "y" : 276
 },
 "left_eyebrow_left_corner" : {
 "x" : 262,
 "y" : 372
 },
 "right_eye_left_corner" : {
 "x" : 291,
 "y" : 228
 },
 "nose_right" : {
 "x" : 350,
 "y" : 236
 },
 "right_eyebrow_middle" : {
 "x" : 247,
 "y" : 194
 },
 "left_eyebrow_middle" : {
 "x" : 247,
 "y" : 335
 },
 "left_eyebrow_right_corner" : {
 "x" : 252,
 "y" : 297
 },
 "mouth_upper_lip_top" : {
 "x" : 386,
 "y" : 279
 },
 "mouth_right_corner" : {
 "x" : 419,
 "y" : 226
 }
 }
 }
 ],
 "ret" : "0"
 */

-(void)drawPointWithPoints:(NSArray *)arrPersons{
    
    if (context) {
        CGContextClearRect(context, self.bounds) ;
    }
    context = UIGraphicsGetCurrentContext();
    
    //头部中点
    CGPoint midpoint = CGPointZero;
    CGFloat spacing = 60;
    double rotation = 0.0;
    
    for (NSDictionary *dicPerson in self.arrPersons) {
#pragma mark - 识别面部关键点
        /*
         识别面部关键点
         */
        if ([dicPerson objectForKey:POINTS_KEY]) {
#pragma mark - 取嘴角的点算头饰的旋转角度
            
            NSArray * strPoints = [dicPerson objectForKey:POINTS_KEY];
        
            
//            if (ABS(rotation) > 0.05) {
//                self.headMapView.transform = CGAffineTransformMakeRotation(rotation);
//            }
            
//           rotation = atan((strPoint3.x+strPoint4.x -strPoint1.x - strPoint2.x)/(strPoint3.y +strPoint4.y - strPoint1.y - strPoint2.y));
            
            
#pragma mark - 取眉毛的点算头部的位置
            //左边眉毛中间点
            CGPoint  eyebrowsPoint1 = CGPointFromString(((NSString *)strPoints[16]));
            CGContextAddEllipseInRect(context,CGRectMake(eyebrowsPoint1.x - 1 , eyebrowsPoint1.y - 1 , 2 , 2));
            
            //左边眉毛1号点
            CGPoint  eyebrowsPoint2 = CGPointFromString(((NSString *)strPoints[11]));
            CGContextAddEllipseInRect(context,CGRectMake(eyebrowsPoint2.x - 1 , eyebrowsPoint2.y - 1 , 2 , 2));
            
            //右边眉毛中间点
            CGPoint  eyebrowsPoint3 = CGPointFromString(((NSString *)strPoints[17]));
            CGContextAddEllipseInRect(context,CGRectMake(eyebrowsPoint3.x - 1 , eyebrowsPoint3.y - 1 , 2 , 2));
            
//            //右边眉毛一号点
            CGPoint eyebrowsPoint4 = CGPointFromString(((NSString *)strPoints[18]));
            CGContextAddEllipseInRect(context,CGRectMake(eyebrowsPoint4.x - 1 , eyebrowsPoint4.y - 1 , 2 , 2));
//
            CGFloat midpointX  = (spacing *(eyebrowsPoint4.x + eyebrowsPoint2.x - eyebrowsPoint3.x - eyebrowsPoint1.x) / (eyebrowsPoint4.y + eyebrowsPoint2.y - eyebrowsPoint3.y - eyebrowsPoint1.y) + (eyebrowsPoint1.x + eyebrowsPoint3.x)) / 2;
            CGFloat midpointY = eyebrowsPoint2.y - spacing;
            
            midpoint = CGPointMake(midpointX, midpointY);

//            if (self.tenArr.count < 5) {
//                [self.tenArr addObject:[NSValue valueWithCGPoint:midpoint]];
//            }else{
//                [self.tenArr removeObjectAtIndex:0];
//                [self.tenArr  addObject:[NSValue valueWithCGPoint:midpoint]];
//            }
//            
//            CGFloat sumX = 0;
//            CGFloat sumY = 0;
//            CGFloat maxX = 0;
//            CGFloat maxY = 0;
//            
//            CGFloat minX = 0;
//            CGFloat minY = 0;
//            for (int i = 0; i < _tenArr.count; i++) {
//                CGPoint point = [self.tenArr[i] CGPointValue];
//                sumX += point.x;
//                sumY += point.y;
//                
//                maxX = MAX(point.x, maxX);
//                maxY = MAX(point.y, maxY);
//
//                maxX = MIN(point.x, maxX);
//                maxY = MIN(point.y, maxY);
//            }
            
//            
            midpointX = (midpointX + 2 * self.lastMiddlePoint.x)/3.0;
            midpointY = (midpointY + 2 * self.lastMiddlePoint.y)/3.0;
            
            if (midpointX > 1000 || midpointX < -100) {
                midpointX = 0;
            }
            
            if (midpointY > 1000 || midpointY < -100) {
                midpointY = 0;
            }
            
            midpoint = CGPointMake(midpointX, midpointY);
            
            double xDist = (midpoint.x - _lastMiddlePoint.x);
            CGFloat yDist = (midpoint.y - _lastMiddlePoint.y);
            CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
            if (distance < 3) {
                midpoint = self.lastMiddlePoint;
                self.arrPersons = self.lastArr;
                arrPersons = self.lastArr;
            }else{
                self.lastMiddlePoint = midpoint;
                self.lastArr = self.arrPersons;
            }
        }
        
        
        BOOL isOriRect=NO;
        if ([dicPerson objectForKey:RECT_ORI]) {
            isOriRect=[[dicPerson objectForKey:RECT_ORI] boolValue];
        }
    
        NSDictionary *tmpDict = dicPerson;
        if (self.lastArr == self.arrPersons) {
            tmpDict = self.lastArr[0];
        }
        
        if ([tmpDict objectForKey:RECT_KEY]) {
            CGRect rect=CGRectFromString([tmpDict objectForKey:RECT_KEY]);

            
            //计算角度
            {
                NSArray * strPoints = [dicPerson objectForKey:POINTS_KEY];
                //左右相对于实际中的人
                
                //左边鼻孔
                CGPoint  nose_left = CGPointFromString(((NSString *)strPoints[2]));
                CGContextAddEllipseInRect(context,CGRectMake(nose_left.x - 1 , nose_left.y - 1 , 2 , 2));
                
                //右边鼻孔
                CGPoint  nose_right = CGPointFromString(((NSString *)strPoints[15]));
                CGContextAddEllipseInRect(context,CGRectMake(nose_right.x - 1 , nose_right.y - 1 , 2 , 2));
                
                //左边嘴角
                CGPoint  mouth_left_corner = CGPointFromString(((NSString *)strPoints[5]));
                CGContextAddEllipseInRect(context,CGRectMake(mouth_left_corner.x - 1 , mouth_left_corner.y - 1 , 2 , 2));
                
                //右边嘴角
                CGPoint mouth_right_corner = CGPointFromString(((NSString *)strPoints[20]));
                CGContextAddEllipseInRect(context,CGRectMake(mouth_right_corner.x - 1 , mouth_right_corner.y - 1 , 2 , 2));
                
                //左眼左中心
                CGPoint left_eye_left_corner =  CGPointFromString(((NSString *)strPoints[0]));
                
                //右眼右中心
                CGPoint right_eye_right_corner =  CGPointFromString(((NSString *)strPoints[3]));
                
                
//                double rotation0 = atan2(left_eye_left_corner.y - right_eye_right_corner.y, left_eye_left_corner.x - right_eye_right_corner.x);
//                double rotation1 = atan2(mouth_left_corner.y - mouth_right_corner.y, mouth_left_corner.x - mouth_right_corner.x);
//                rotation = (rotation0 + rotation1)/2.0;
//                
//                if (ABS(rotation - _lastRotation) > 0.01) {
//                    NSLog(@"rotation - _lastRotation == %f",rotation);
//
//                    self.lastRotation = rotation;
//                    self.headMapView.transform = CGAffineTransformMakeRotation(rotation);
//                }
//                else{
                    //贴图逻辑
                    if(self.headMap ){
                        
                        CGFloat scale =  (rect.size.width / self.headMap.size.width) + 0.25 ;
                        CGFloat headMapViewW = scale * self.headMap.size.width;
                        CGFloat headmapViewH = scale * self.headMap.size.height;
                        
//                        if (self.headMap == self.lastImage) {
//                            CGRect frame  = self.headMapView.frame;
//                            frame.origin =  CGPointMake(midpoint.x - (frame.size.width * 0.5), midpoint.y - rect.size.height * 0.5);
//                            self.headMapView.frame = frame;
//                        }else{
//                            self.lastImage = self.headMap;
                            CGRect frame  =  CGRectMake(midpoint.x - (headMapViewW * 0.5), midpoint.y - headMapViewW * 0.5, headMapViewW, headmapViewH);
                            
                            self.headMapView.frame = frame;
//                        }
                    }

//                }

            }
                //
        }
            
    }

//    [[UIColor greenColor] set];
//    CGContextSetLineWidth(context, 2);
//    CGContextStrokePath(context);
}

/*
- (CGFloat)findMinChangedDistance{
    for (int i = 0; i < self.arrPersons.count; i++) {
        NSDictionary *dicPerson = self.arrPersons[i];
        NSDictionary *dictPeson = self.lastArr[i];
        
        NSArray * strPoints = [dicPerson objectForKey:POINTS_KEY];
        //左眼左中心
        CGPoint left_eye_left_corner =  CGPointFromString(((NSString *)strPoints[0]));
        //右眼右中心
        CGPoint right_eye_right_corner =  CGPointFromString(((NSString *)strPoints[3]));
        //右边鼻孔
        CGPoint  nose_right = CGPointFromString(((NSString *)strPoints[15]));
        CGPoint  nose_left = CGPointFromString(((NSString *)strPoints[2]));
        
        NSArray * laststrPoints = [dicPerson objectForKey:POINTS_KEY];
        //左眼左中心
        CGPoint lastleft_eye_left_corner =  CGPointFromString(((NSString *)laststrPoints[0]));
        //右眼右中心
        CGPoint lastright_eye_right_corner =  CGPointFromString(((NSString *)laststrPoints[3]));
        //右边鼻孔
        CGPoint  lastnose_right = CGPointFromString(((NSString *)laststrPoints[15]));
        CGPoint  lastsnose_left = CGPointFromString(((NSString *)laststrPoints[2]));
        
        NSArray *xArr = @[@(left_eye_left_corner.x),@(right_eye_right_corner.x),@(nose_left.x),@(nose_right.x)];
        NSArray *xArrLast = @[@(lastleft_eye_left_corner.x),@(lastright_eye_right_corner.x),@(lastsnose_left.x),@(lastnose_right.x)];
        NSArray *yArr = @[@(left_eye_left_corner.y),@(right_eye_right_corner.y),@(nose_left.y),@(nose_right.y)];
        NSArray *yArrLast = @[@(lastleft_eye_left_corner.y),@(lastright_eye_right_corner.y),@(lastsnose_left.y),@(lastnose_right.y)];
        
        NSInteger indexX = 0;
        CGFloat minNumX = [xArr[0] floatValue];
        for (int i = 0; i < arr.count; i ++) {
            if (ABS(minNumX) < ABS([arr[i] floatValue])) {
                indexX = i;
            }
        }

        
//        CGFloat minX =

    }
    return 0.0;
}
*/


- (NSMutableArray *)tenArr{
    if (_tenArr== nil) {
        _tenArr = [NSMutableArray array];
    }
    return _tenArr;
}

@end
