//
//  CollectionViewController.m
//  downloadImage
//
//  Created by YEN HUNG I on 2019/7/25.
//  Copyright © 2019 YEN HUNG I. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import "DownloadManager.h"
@interface CollectionViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CollectionViewController
-(void)setImageDataArray:(NSArray *)imageDataArray{
    _imageDataArray=imageDataArray;
    [self.collectionView reloadData];
}
- (void)viewDidLoad {
    
    self.imageDataArray = [DownloadManager sharedInstance].DownloadDataArray;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updataUI:) name:@"DownloadManagerDataLoaded" object:nil];
    
    [super viewDidLoad];
    
}
- (void)updataUI:(NSNotification *)notification{
    self.imageDataArray = [notification.userInfo objectForKey:@"data"];
    [self.collectionView reloadData];
    NSLog(@"updataUI:%li",[self.imageDataArray count]);
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSUInteger cellCount = 1;
    
    if (self.imageDataArray) {
        cellCount = [self.imageDataArray count];
    }
    
    return cellCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* loadingCell=@"collectionViewCell";
    static NSString* showDataCell=@"collectionViewCell";

    NSUInteger nodeCount=self.imageDataArray.count;
    // 這裡是 如果資料還沒下載 就先 顯示 預設的圖片
    if (indexPath.row==0 && nodeCount==0) {
        CollectionViewCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:loadingCell forIndexPath:indexPath];
        cell.title.text=@"Loading";
        return cell;
    }else if(indexPath.row>0 && nodeCount==0){
        CollectionViewCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:showDataCell forIndexPath:indexPath];
        return cell;
    }
    //以下是 如果有資料 就執行以下的程式
    CollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:showDataCell forIndexPath:indexPath];
    
    ImageData *oneRecord = self.imageDataArray[indexPath.row];

    cell.title.text = oneRecord.title;
    if (!oneRecord.image) {
        //dragging是滑動中 decelerating 是 減速中的滑動
        if (collectionView.dragging==NO && self.collectionView.decelerating==NO){
            //下載圖片 這裡是為了 如果你一開始沒有亂動  也是要下載圖片的(不能等你觸發scrollViewDidEndDecelerating: 才下載圖片吧)
            __weak CollectionViewCell *weakCell = cell;
            [[DownloadManager sharedInstance]startImageDownloadForIndexPath:indexPath completion:^(NSIndexPath * _Nonnull indexPath) {
                __strong CollectionViewCell *strongCell = weakCell;
                if (!strongCell) return;
                strongCell.imageView.image = oneRecord.image;
            }];
        }
        //cell.imageView.image=[UIImage imageNamed:@"Placeholder.png"]; //預設圖片
    }else{
        cell.imageView.image=oneRecord.image;
    }
    
    return cell;
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.bounds.size.width/2,(collectionView.bounds.size.width/2)+44);
}


#pragma mark - UIScrollViewDelegate
//減速移動停止後才會呼叫的方法 (保括.dragging .decelerating 都是停止 才會呼叫 只呼叫一次)
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
     [self callManagerDownloadImage];
}
//手指滑動停止後才會呼叫的方法 (如果手指離開時 沒有滑動 就不會觸發減速移動事件) decelerate是指手指離開
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self callManagerDownloadImage];
    }
}
#pragma mark - callManagerDownloadImage
-(void)callManagerDownloadImage{
    __weak typeof (self) weakSelf = self;
    [[DownloadManager sharedInstance] loadImagesForOnScreenRows:[self.collectionView indexPathsForVisibleItems] completion:^(NSIndexPath * _Nonnull indexPath) {
        __strong typeof (self) strongSelf = weakSelf;
        if(!strongSelf) return ;

        CollectionViewCell *cell=(CollectionViewCell*)[strongSelf.collectionView cellForItemAtIndexPath:indexPath];
        ImageData *oneRecord = weakSelf.imageDataArray[indexPath.row];
        cell.imageView.image = oneRecord.image;
        
    }];
}


@end
