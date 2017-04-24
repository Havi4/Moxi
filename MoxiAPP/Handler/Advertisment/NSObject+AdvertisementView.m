//
//  NSObject+AdvertisementView.m
//  BaseAppStruct
//
//  Created by Havi on 16/6/27.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "NSObject+AdvertisementView.h"

@implementation NSObject (AdvertisementView)

/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    if (imageName) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES);
        NSString *adversement = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Adversement"];
        NSString *imageFile = [adversement stringByAppendingPathComponent:imageName];

        return imageFile;
    }
    
    return nil;
}

/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}

/**
 *  删除旧图片
 */
- (void)deleteOldImage
{
    NSString *imageName = [kUserDefaults valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

/**
 *  初始化广告页面
 */
- (void)getAdvertisingImage
{
    
    // TODO 请求广告接口
    
    // 这里原本采用美团的广告接口，现在了一些固定的图片url代替
//    NSString *imageUrl = [[publicGet objectForKey:@"data"] objectForKey:@"homeImg"];
    NSString *imageUrl = @"http://down.pch18.cn/moxi.jpg?v=123";   // 获取图片名:43-130P5122Z60-50.jpg
    NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
    NSRange range = [stringArr.lastObject rangeOfString:@"?"];
    NSString *imageName = [stringArr.lastObject substringToIndex:range.location];
    
    // 拼接沙盒路径
    NSString *filePath = [self getFilePathWithImageName:imageName];//图片
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
        [self downloadAdImageWithUrl:imageUrl imageName:imageName];
        
    }
    
}

/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    UIImage *image = [UIImage imageWithData:data];

    NSArray *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *document = [path objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [NSString stringWithFormat:@"%@/Adversement", document];
        // 创建目录
    BOOL isDir = [fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    if (isDir) {
        DeBugLog(@"文件夹ok");
    }else{
        DeBugLog(@"出错%@",testDirectory);
    }

    NSString *testPath = [testDirectory stringByAppendingPathComponent:imageName];
    BOOL isFile = [fileManager createFileAtPath:testPath contents:data attributes:nil];

    if (isFile) {// 保存成功
        DeBugLog(@"保存成功");
        [self deleteOldImage];
        [kUserDefaults setValue:imageName forKey:adImageName];
        [kUserDefaults synchronize];
            // 如果有广告链接，将广告链接也保存下来
    }else{
        DeBugLog(@"保存失败");
    }
}


@end
