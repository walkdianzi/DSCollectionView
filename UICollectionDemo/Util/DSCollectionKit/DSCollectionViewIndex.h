//
//  DSCollectionViewIndex.h
//  UICollectionDemo
//
//  Created by YMY on 15/7/11.
//  Copyright (c) 2015年 YMY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSCollectionViewIndex;
@protocol DSCollectionViewIndexDelegate <NSObject>

/**
 *  触摸到索引时的反应
 *
 *  @param collectionViewIndex 触发的对象
 *  @param index               触发的索引的下标
 *  @param title               触发的索引的文字
 */
-(void)collectionViewIndex:(DSCollectionViewIndex *)collectionViewIndex didselectionAtIndex:(NSInteger)index withTitle:(NSString *)title;

/**
 *  开始触摸索引
 *
 *  @param tableViewIndex 触发tableViewIndexTouchesBegan对象
 */
- (void)collectionViewIndexTouchesBegan:(DSCollectionViewIndex *)collectionViewIndex;


/**
 *  触摸索引结束
 *
 *  @param tableViewIndex
 */
- (void)collectionViewIndexTouchesEnd:(DSCollectionViewIndex *)collectionViewIndex;


@end

@interface DSCollectionViewIndex : UIView

/**
 *  是否有边框线
 */
@property(nonatomic, assign)BOOL isFrameLayer;
/**
 *  索引内容数组
 */
@property(nonatomic, strong)NSArray *titleIndexes;

@property(nonatomic, weak)id<DSCollectionViewIndexDelegate>collectionDelegate;

@end
