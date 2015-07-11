//
//  ViewController.m
//  UICollectionDemo
//
//  Created by YMY on 15/7/8.
//  Copyright (c) 2015年 YMY. All rights reserved.
//

#import "ViewController.h"
#import "StickyHeaderLayout.h"
#import "DSCollectionView.h"


#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define kScreenHeight [[UIScreen mainScreen]bounds].size.height
#define kScreenWidth [[UIScreen mainScreen]bounds].size.width

#define kStateBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavigationBarHeight self.navigationController.navigationBar.bounds.size.height

#define kFontSmall [UIFont fontWithName:@"Helvetica" size:12]

#define kColorStringBlack 0x333333

static const CGFloat kHeaderHeight      = 40;


//section的头部
@interface MyHeadView : UICollectionReusableView

@property (strong, nonatomic) UILabel *label;

-(void)setLabelText:(NSString *)text;
@end

@implementation MyHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:0.9];
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 20)];
        self.label.font = kFontSmall;
        [self.label setTextColor:UIColorFromRGB(kColorStringBlack)];
        [self addSubview:self.label];
    }
    return self;
}

- (void) setLabelText:(NSString *)text
{
    self.label.text = text;
    [self.label sizeToFit];
}

@end


@implementation JingPinCell

@synthesize lblTitle,icon;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIImage *img = [UIImage imageNamed:@"nan_shi_nei_yi"];
        icon = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-img.size.width)/2, (frame.size.height-img.size.height-20)/2+7.5, img.size.width, img.size.width)];
        [icon setImage:img];
        [icon setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:icon];
        
        lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, icon.frame.origin.y+icon.frame.size.height+5, self.frame.size.width, 20)];
        [lblTitle setNumberOfLines:0];
        [lblTitle setFont:kFontSmall];
        [lblTitle setTextColor:UIColorFromRGB(kColorStringBlack)];
        [lblTitle setBackgroundColor:[UIColor clearColor]];
        [lblTitle setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:lblTitle];
    }
    return self;
}

@end

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,DSCollectionViewDelegate>{
    
    UICollectionViewFlowLayout *flowLayout;
    DSCollectionView           *_collectionView;
    NSArray *sections;
    NSArray *rows;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sections = @[@"A", @"D", @"F", @"M", @"N", @"O", @"Z"];
    
    rows = @[@[@"adam", @"alfred", @"ain", @"abdul", @"anastazja", @"angelica"],
             @[@"dennis" , @"deamon", @"destiny", @"dragon", @"dry", @"debug", @"drums"],
             @[@"Fredric", @"France", @"friends", @"family", @"fatish", @"funeral"],
             @[@"Mark", @"Madeline"],
             @[@"Nemesis", @"nemo", @"name"],
             @[@"Obama", @"Oprah", @"Omen", @"OMG OMG OMG", @"O-Zone", @"Ontario"],
             @[@"Zeus", @"Zebra", @"zed"]];

    
    [self initMenu];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)initMenu{
    
    
    flowLayout=[[StickyHeaderLayout alloc] init];
    flowLayout.itemSize=CGSizeMake(self.view.frame.size.width/3,self.view.frame.size.width/3);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing=0;
    
    _collectionView = [[DSCollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width,kScreenHeight-kStateBarHeight-kNavigationBarHeight)];
    _collectionView.delegate=self;
    [_collectionView.collectionView setCollectionViewLayout:flowLayout];
    _collectionView.collectionView.alwaysBounceVertical=YES;
    [_collectionView.collectionView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    [_collectionView.collectionView setBackgroundColor:[UIColor whiteColor]];
    
    [_collectionView.collectionView registerClass:[JingPinCell class] forCellWithReuseIdentifier:@"com.zhefengle.jingPinCellId"];
    [_collectionView.collectionView registerClass:[MyHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    [self.view addSubview:_collectionView];
}

#pragma mark - UICollectionViewDataSource



-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    CGSize size = {kScreenWidth,kHeaderHeight};
    return size;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
        
    MyHeadView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        MyHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        NSString *title = @"";
        
        title = [sections objectAtIndex:indexPath.section];
        
        
        [headerView setLabelText:title];
        reusableview = headerView;
    }
    return reusableview;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView

{
    return [sections count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return [[rows objectAtIndex:section] count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *collectionCellID = @"com.zhefengle.jingPinCellId";
    JingPinCell *cell = (JingPinCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    

    [cell.lblTitle setText:[[rows objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    return cell;
}

-(NSArray *)sectionIndexTitlesForDSCollectionView:(DSCollectionView *)tableView{
    
    return sections;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
