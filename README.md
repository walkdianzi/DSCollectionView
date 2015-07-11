# DSCollectionView

![索引.gif](http://upload-images.jianshu.io/upload_images/101810-eccbc31c99b9e006.gif)


![索引2.gif](http://upload-images.jianshu.io/upload_images/101810-eca734cf61b56e11.gif)
----------------
索引条部分使用UIView 的 layoutSubviews绘制字母和边框线

setNeedsDisplay会调用自动调用drawRect方法，这样可以拿到UIGraphicsGetCurrentContext，就可以画画了。而setNeedsLayout会默认调用layoutSubViews，就可以处理子视图中的一些数据。
 宗上所诉，setNeedsDisplay方便绘图，而layoutSubViews方便出来数据。  
 
 因为这两个方法都是异步执行的，所以一些元素还是直接绘制的好

使用CAShapeLayer与UIBezierPath可以实现不在view的drawRect方法中就画出一些想要的图形，在这里使用CAShapeLayer绘制索引表的边框线

--------------

**根据手势来判断显示中间的索引块**

//开始触摸
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent \*)event{}

//手势移动
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent\*)event{}

//手势结束
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent \*)event{}



**根据触摸事件的触摸点位置来算出点击的是第几个section**
 
    -(void)sendEventToDelegate:(UIEvent*)event{
        UITouch *touch = [[event allTouches] anyObject];       
        CGPoint point = [touch locationInView:self]；
        NSInteger indx = ((NSInteger) floorf(point.y) / _letterHeight);    
        if (indx< 0 || indx > self.titleIndexes.count - 1) {return;}
        [self.collectionDelegate collectionViewIndex:self didselectionAtIndex:indx withTitle:self.titleIndexes[indx]];
    }
