//
//  DownloadManager.m
//  downloadImage
//
//  Created by YEN HUNG I on 2020/2/22.
//  Copyright © 2020 YEN HUNG I. All rights reserved.
//

#import "DownloadManager.h"
#import <AFNetworking.h>
#import "ImageDownloader.h"
#import <FlickrKit.h>
@interface DownloadManager()
///圖片下載進程
@property (nonatomic,strong) NSMutableDictionary *imageDownloadsInProgress;
@end
@implementation DownloadManager

+ (instancetype) sharedInstance
{
    static DownloadManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DownloadManager alloc] init];
        [[FlickrKit sharedFlickrKit] initializeWithAPIKey:@"4b8ef0be8e97cdc568e1ba6156677f66"
                                                sharedSecret:@"5328b93a382c305c"];
    });
    return instance;
}

-(void)getFlickrDataWith:(NSDictionary *)parameter{
    
    __weak typeof (self) weakSelf = self;

    FlickrKit *fk = [FlickrKit sharedFlickrKit];
    [fk call:@"flickr.photos.search" args:parameter maxCacheAge:FKDUMaxAgeOneHour completion:^(NSDictionary *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response) {
                NSMutableArray *userDataArray = [NSMutableArray array];

                NSError *imageDataError = nil;

                for (NSDictionary *photoData in [response valueForKeyPath:@"photos.photo"]) {

                    ImageData *userData = [[ImageData alloc] initWithDictionary:photoData
                                                          error:&imageDataError];

                    NSURL *url = [fk photoURLForSize:FKPhotoSizeSmall240 fromPhotoDictionary:photoData];
                    userData.photoURL = url;
                    [userDataArray addObject:userData];
                }
                weakSelf.DownloadDataArray = userDataArray;

                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter]postNotificationName:DownloadManagerDataLoaded
                                                                       object:weakSelf
                                                                     userInfo:[NSDictionary dictionaryWithObject:weakSelf.DownloadDataArray forKey:@"data"]];
                });
            }
        });
    }];
}
#pragma mark - Download Image

-(void)startImageDownloadForIndexPath:(NSIndexPath *)indexPath completion:(void(^)(NSIndexPath *indexPath))finish{

    ImageDownloader *imageDownloader=[self.imageDownloadsInProgress objectForKey:indexPath];
    //檢查下載進程存不存在
    if (imageDownloader==nil) {
        imageDownloader=[[ImageDownloader alloc] init];
        //填入需要下載的圖片位置
        imageDownloader.imageDate=[self.DownloadDataArray objectAtIndex:indexPath.row];
        
        __weak typeof (self) weakSelf = self;
        //下載完成callback
        imageDownloader.completionHandler=^(void){

            if(finish)finish(indexPath);
            //下載序列移除
            [weakSelf.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        };
        [self.imageDownloadsInProgress setObject:imageDownloader forKey:indexPath];
        [imageDownloader startDownload];
    }
}

-(void)loadImagesForOnScreenRows:(NSArray<NSIndexPath *>*)visiblePaths completion:(void(^)(NSIndexPath *indexPath))finish{
    if (self.DownloadDataArray.count>0) {
        for (NSIndexPath *indexPath in visiblePaths) {
            ImageData *oneRecord=[self.DownloadDataArray objectAtIndex:indexPath.row];
            //如果原本沒有圖片
            if (!oneRecord.image) {
                //下載圖片;
                [self startImageDownloadForIndexPath:indexPath completion:^(NSIndexPath * _Nonnull indexPath) {
                    finish(indexPath);
                }];
            }
        }
    }
}

@end
