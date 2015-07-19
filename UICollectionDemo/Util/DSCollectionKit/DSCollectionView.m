//
//  DSCollectionView.m
//  UICollectionDemo
//
//  Created by YMY on 15/7/8.
//  Copyright (c) 2015年 YMY. All rights reserved.
//

#import "DSCollectionView.h"
#import "DSCollectionViewIndex.h"
#import "StickyHeaderLayout.h"

@interface DSCollectionView()<DSCollectionViewIndexDelegate>{
    
    UICollectionViewFlowLayout *flowLayout;
    
    UILabel                 * _flotageLabel;          //中间显示的背景框
    DSCollectionViewIndex   * _collectionViewIndex;   //右边索引条
}

@end

@implementation DSCollectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        flowLayout=[[StickyHeaderLayout alloc] init];
        flowLayout.itemSize=CGSizeMake(frame.size.width/2,frame.size.width/2);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing=0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        [self addSubview:_collectionView];
        
        _collectionViewIndex = [[DSCollectionViewIndex alloc] initWithFrame:CGRectMake(self.bounds.size.width-20, 0, 20, self.bounds.size.height)];
        [self addSubview:_collectionViewIndex];
        
        _flotageLabel = [[UILabel alloc] initWithFrame:(CGRect){(self.bounds.size.width - 64 ) / 2,(self.bounds.size.height - 64) / 2,64,64}];
        _flotageLabel.backgroundColor = [UIColor blackColor];
        _flotageLabel.hidden = YES;
        [_flotageLabel.layer  setCornerRadius:32];
        _flotageLabel.layer.masksToBounds = YES;
        _flotageLabel.textAlignment = NSTextAlignmentCenter;
        _flotageLabel.textColor = [UIColor whiteColor];
        [self addSubview:_flotageLabel];
    }
    return self;
}

-(void)setDelegate:(id<DSCollectionViewDelegate>)delegate{
    
    _delegate = delegate;
    _collectionView.delegate = delegate;
    _collectionView.dataSource = delegate;
    _collectionViewIndex.titleIndexes = [self.delegate sectionIndexTitlesForDSCollectionView:self];
    
    CGRect rect = _collectionViewIndex.frame;
    rect.size.height = _collectionViewIndex.titleIndexes.count * 16;
    rect.origin.y = (self.bounds.size.height - rect.size.height) / 2;
    _collectionViewIndex.frame = rect;
    _collectionViewIndex.isFrameLayer = YES;    //是否有边框线
    _collectionViewIndex.collectionDelegate = self;
}

-(void)reloadData{
    
    [_collectionView reloadData];
    
    UIEdgeInsets edgeInsets = _collectionView.contentInset;
    
    _collectionViewIndex.titleIndexes = [self.delegate sectionIndexTitlesForDSCollectionView:self];
    CGRect rect = _collectionViewIndex.frame;
    rect.size.height = _collectionViewIndex.titleIndexes.count * 16;
    rect.origin.y = (self.bounds.size.height - rect.size.height - edgeInsets.top - edgeInsets.bottom) / 2 + edgeInsets.top + 20;
    _collectionViewIndex.frame = rect;
    _collectionViewIndex.collectionDelegate = self;
}

#pragma mark- 

-(void)collectionViewIndex:(DSCollectionViewIndex *)collectionViewIndex didselectionAtIndex:(NSInteger)index withTitle:(NSString *)title{
    
    if ([_collectionView numberOfSections]>index&&index>-1) {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        _flotageLabel.text = title;
    }
}

-(void)collectionViewIndexTouchesBegan:(DSCollectionViewIndex *)collectionViewIndex{
    
    _flotageLabel.alpha = 1;
    _flotageLabel.hidden = NO;
}

-(void)collectionViewIndexTouchesEnd:(DSCollectionViewIndex *)collectionViewIndex{
    
    void (^animation)() = ^{
        _flotageLabel.alpha = 0;
    };
    
    [UIView animateWithDuration:0.4 animations:animation completion:^(BOOL finished) {
        _flotageLabel.hidden = YES;
    }];
}

@end
