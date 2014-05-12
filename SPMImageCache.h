//
//  SPMImageCache.h
//  DevPAImageView
//
//  Created by Andrey Yastrebov on 12.05.14.
//  Copyright (c) 2014 Andrey Yastrebov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPMImageCache : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSString      *cachePath;
@property (nonatomic, strong) NSFileManager *fileManager;

- (void)setImage:(UIImage *)image forURL:(NSURL *)URL;
- (UIImage *)imageForURL:(NSURL *)URL;

- (void)setImage:(UIImage *)image forKey:(NSString *)Key pathExtension:(NSString *)pathExtension;
- (UIImage *)imageforKey:(NSString *)Key pathExtension:(NSString *)pathExtension;

@end
