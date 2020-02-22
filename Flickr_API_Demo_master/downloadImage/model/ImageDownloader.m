//
//  ImageDownloader.m
//  downloadImage
//
//  Created by YEN HUNG I on 2019/7/25.
//  Copyright © 2019 YEN HUNG I. All rights reserved.
//
#import "ImageDownloader.h"
#import <AFNetworking.h>
@interface ImageDownloader ()
@property(nonatomic,strong) AFHTTPSessionManager *session;
@end
@implementation ImageDownloader
-(void)startDownload{
    
    NSURL *URL = self.imageDate.photoURL;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes =  [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"image/png",nil]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    __weak typeof (self) weakSelf = self;
    
    [manager GET:URL.absoluteString
      parameters:nil
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
        
        __strong typeof (self) strongSelf = weakSelf;
        if (!strongSelf) return ;
        UIImage *image = [[UIImage alloc]initWithData:responseObject];
        strongSelf.imageDate.image = [strongSelf drawImageForDevice:image];
        //self.imageDate.image = image;
        strongSelf.session = nil;
        if (self.completionHandler) {
            self.completionHandler();
        }
        
    }
         failure:^(NSURLSessionTask *operation, NSError *error) {
        
    }];
}
-(void)cancelDownload{
    
}

-(UIImage *)drawImageForDevice:(UIImage *)image{
    
    //暫設螢幕寬度 1/4 為需要的圖片大小
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat ImageSize = screenWidth/2;
    
    if (image.size.width>ImageSize || image.size.height>ImageSize)
        //先判斷 網路下載的圖片的size 是否是我們需要的
    {
        CGSize size=CGSizeMake(ImageSize, ImageSize);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        [image drawInRect:CGRectMake(0, 0, ImageSize, ImageSize)];
        image=UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    return image;
    
}

@end
