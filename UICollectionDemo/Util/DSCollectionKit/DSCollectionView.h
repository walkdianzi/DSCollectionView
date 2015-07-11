//
//  DSCollectionView.h
//  UICollectionDemo
//
//  Created by YMY on 15/7/8.
//  Copyright (c) 2015年 YMY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSCollectionView;
@protocol DSCollectionViewDelegate <UICollectionViewDataSource,UICollectionViewDelegate>

- (NSArray *)sectionIndexTitlesForDSCollectionView:(DSCollectionView *)tableView;

@end

@interface DSCollectionView : UIView

@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, weak)id<DSCollectionViewDelegate>delegate;

-(void)reloadData;

@end
