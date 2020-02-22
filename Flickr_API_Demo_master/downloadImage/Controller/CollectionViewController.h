//
//  CollectionViewController.h
//  downloadImage
//
//  Created by YEN HUNG I on 2019/7/25.
//  Copyright © 2019 YEN HUNG I. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewController : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSArray *imageDataArray;
@end

NS_ASSUME_NONNULL_END
