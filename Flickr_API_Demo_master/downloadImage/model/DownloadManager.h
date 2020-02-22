//
//  DownloadManager.h
//  downloadImage
//
//  Created by YEN HUNG I on 2020/2/22.
//  Copyright © 2020 YEN HUNG I. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageData.h"
NS_ASSUME_NONNULL_BEGIN

@interface DownloadManager : NSObject
@property (nonatomic, strong) NSArray<ImageData *> *DownloadDataArray;      //初始資料
@property (nonatomic,strong) NSMutableDictionary *imageDownloadsInProgress; //圖片下載進程
+ (instancetype) sharedInstance;
- (void)GetData:(NSString *)url;                                            //取得初始資料
- (void)getFlickrDataWith:(NSDictionary *)parameter;
//單一圖片下載
-(void)startImageDownloadForIndexPath:(NSIndexPath *)indexPath completion:(void(^)(NSIndexPath *indexPath))finish;
//陣列圖片下載
-(void)loadImagesForOnScreenRows:(NSArray*)visiblePaths completion:(void(^)(NSIndexPath *indexPath))finish;
@end

NS_ASSUME_NONNULL_END
