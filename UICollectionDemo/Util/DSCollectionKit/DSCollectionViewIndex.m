//
//  DSCollectionViewIndex.m
//  UICollectionDemo
//
//  Created by YMY on 15/7/11.
//  Copyright (c) 2015年 YMY. All rights reserved.
//

#import "DSCollectionViewIndex.h"

#define RGB(r,g,b,a)  [UIColor colorWithRed:(double)r/255.0f green:(double)g/255.0f blue:(double)b/255.0f alpha:a]

@interface DSCollectionViewIndex(){
    
    BOOL _isLayedOut;
    CAShapeLayer *_shapeLayer;
    CGFloat _letterHeight;
}

@end

@implementation DSCollectionViewIndex

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(void)setCollectionDelegate:(id<DSCollectionViewIndexDelegate>)collectionDelegate{

    _collectionDelegate = collectionDelegate;
    _isLayedOut = NO;  //如果为yes就是超过此layer的部分都裁剪掉，使用圆角的时候常用到
    [self layoutSubviews];
}

/*---setNeedsDisplay会调用自动调用drawRect方法，这样可以拿到UIGraphicsGetCurrentContext，就可以画画了。而setNeedsLayout会默认调用layoutSubViews，就可以处理子视图中的一些数据。
 宗上所诉，setNeedsDisplay方便绘图，而layoutSubViews方便出来数据。  
 
 因为这两个方法都是异步执行的，所以一些元素还是直接绘制的好---*/


/*---使用CAShapeLayer与UIBezierPath可以实现不在view的drawRect方法中就画出一些想要的图形---*/

//UIView的setNeedsLayout时会执行此方法
-(void)layoutSubviews{
    
    [super layoutSubviews];
    [self setup];
    
    if (!_isLayedOut) {
        [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        
        /*----绘制边框线部分----*/
        _shapeLayer.frame = CGRectMake(CGPointZero.x, CGPointZero.y, self.layer.frame.size.width, self.layer.frame.size.height);
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointZero];
        [bezierPath addLineToPoint:CGPointMake(0, self.frame.size.height)];
        
        /*-----绘制文字部分------*/
        _letterHeight = 16;
        CGFloat fontSize = 12;
        [self.titleIndexes enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            CGFloat originY = idx * _letterHeight;
            CATextLayer *ctl = [self textLayerWithSize:fontSize
                                                string:obj
                                              andFrame:CGRectMake(0, originY, self.frame.size.width, _letterHeight)];

            [self.layer addSublayer:ctl];
            
            [bezierPath moveToPoint:CGPointMake(0, originY)];
            [bezierPath addLineToPoint:CGPointMake(ctl.frame.size.width, originY)];
        }];
        
        _shapeLayer.path = bezierPath.CGPath;
        
        if(_isFrameLayer){
            [self.layer addSublayer:_shapeLayer];
        }
        
        _isLayedOut = YES;
    }
    
}

#pragma mark- 私有方法

//绘制边框线
-(void)setup{
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.lineWidth = 1.0f;
    _shapeLayer.fillColor = [UIColor blackColor].CGColor;
    _shapeLayer.lineJoin = kCALineCapSquare;
    _shapeLayer.strokeColor = [[UIColor blackColor] CGColor];
    _shapeLayer.strokeEnd = 1.0f;
    
    self.layer.masksToBounds = NO;
}

//绘制字体
- (CATextLayer*)textLayerWithSize:(CGFloat)size string:(NSString*)string andFrame:(CGRect)frame{
    CATextLayer *tl = [CATextLayer layer];
    [tl setFont:@"ArialMT"];
    [tl setFontSize:size];
    [tl setFrame:frame];
    [tl setAlignmentMode:kCAAlignmentCenter];
    [tl setContentsScale:[[UIScreen mainScreen] scale]];
    [tl setForegroundColor:RGB(168, 168, 168, 1).CGColor];
    [tl setString:string];
    return tl;
}


//根据触摸事件的触摸点来算出点击的是第几个section
- (void)sendEventToDelegate:(UIEvent*)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self];
    
    NSInteger indx = ((NSInteger) floorf(point.y) / _letterHeight);
    
    if (indx< 0 || indx > self.titleIndexes.count - 1) {
        return;
    }
    
    [self.collectionDelegate collectionViewIndex:self didselectionAtIndex:indx withTitle:self.titleIndexes[indx]];
}
#pragma mark- response事件

//开始触摸
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self sendEventToDelegate:event];
    [self.collectionDelegate collectionViewIndexTouchesBegan:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    [self sendEventToDelegate:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.collectionDelegate collectionViewIndexTouchesEnd:self];
}
@end
