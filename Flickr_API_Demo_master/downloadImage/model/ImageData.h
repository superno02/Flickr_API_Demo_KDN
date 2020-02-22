//
//  ImageData.h
//  downloadImage
//
//  Created by YEN HUNG I on 2019/7/25.
//  Copyright © 2019 YEN HUNG I. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JSONModelLib.h>
NS_ASSUME_NONNULL_BEGIN

@interface ImageData : JSONModel
@property(nonatomic,strong) NSNumber *farm;
@property(nonatomic,strong) NSString *id;
@property(nonatomic) BOOL isfamily;
@property(nonatomic) BOOL isfriend;
@property(nonatomic) BOOL ispublic;
@property(nonatomic,strong) NSString *owner;
@property(nonatomic,strong) NSString *secret;
@property(nonatomic,strong) NSString *server;
@property(nonatomic,strong) NSString *title;

@property(nonatomic,strong) NSURL<Optional> *photoURL;
@property(nonatomic,strong) UIImage<Optional> *image;

@end

NS_ASSUME_NONNULL_END
