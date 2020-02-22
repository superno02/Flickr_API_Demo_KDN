//
//  ImageDownloader.h
//  downloadImage
//
//  Created by YEN HUNG I on 2019/7/25.
//  Copyright © 2019 YEN HUNG I. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageData.h"
NS_ASSUME_NONNULL_BEGIN

@interface ImageDownloader : NSObject
@property(nonatomic,strong)ImageData *imageDate;
@property(nonatomic,copy)void(^completionHandler)(void);
-(void)startDownload;
-(void)cancelDownload;
@end

NS_ASSUME_NONNULL_END
