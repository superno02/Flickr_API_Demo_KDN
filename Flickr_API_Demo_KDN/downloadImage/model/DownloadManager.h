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
///NSNotification name 通知 DownloadManager 資料已更新
static NSString *DownloadManagerDataLoaded = @"DownloadManagerDataLoaded";

@interface DownloadManager : NSObject
/// 下載後的資料
@property (nonatomic, strong) NSArray<ImageData *> *DownloadDataArray;
+ (instancetype) sharedInstance;
/// 單一圖片下載
/// @param parameter key:per_page 為顯示的數量 key:text:為搜尋的文字
///  ex:@{@"per_page":@"15",@"text":@"dog"}
- (void)getFlickrDataWith:(NSDictionary *)parameter;
/// 單一圖片下載
/// @param indexPath 下載圖片的位置
/// @param finish 下載完畢後 callback 回傳下載圖片的位置
- (void)startImageDownloadForIndexPath:(NSIndexPath *)indexPath completion:(void(^)(NSIndexPath *indexPath))finish;
/// 使用陣列下載圖片
/// @param visiblePaths 須下載的圖片陣列
/// @param finish 下載完畢的回呼，會多次呼叫。
- (void)loadImagesForOnScreenRows:(NSArray<NSIndexPath *>*)visiblePaths completion:(void(^)(NSIndexPath *indexPath))finish;
@end

NS_ASSUME_NONNULL_END
