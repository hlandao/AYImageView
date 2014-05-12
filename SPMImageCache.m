//
//  SPMImageCache.m
//  DevPAImageView
//
//  Created by Andrey Yastrebov on 12.05.14.
//  Copyright (c) 2014 Andrey Yastrebov. All rights reserved.
//

#import "SPMImageCache.h"

NSString * const spm_identifier = @"spm.imagecache.tg";

@implementation SPMImageCache

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        NSArray  *paths         = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *rootCachePath = [paths firstObject];
        
        self.fileManager    = [NSFileManager defaultManager];
        self.cachePath      = [rootCachePath stringByAppendingPathComponent:spm_identifier];
        
        if(![self.fileManager fileExistsAtPath:spm_identifier])
        {
            [self.fileManager createDirectoryAtPath:self.cachePath withIntermediateDirectories:NO attributes:nil error:nil];
        }
    }
    return self;
}

- (void)setImage:(UIImage *)image forURL:(NSURL *)URL
{
    NSString *fileExtension = [URL pathExtension];
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)URL.hash];
    
    [self setImage:image
            forKey:key
     pathExtension:fileExtension];
}

- (UIImage *)imageForURL:(NSURL *)URL
{
    NSString *fileExtension = [URL pathExtension];
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)URL.hash];
    
    return [self imageforKey:key
               pathExtension:fileExtension];
}

- (void)setImage:(UIImage *)image forKey:(NSString *)Key pathExtension:(NSString *)pathExtension
{
    NSData   *imageData = nil;
    
    if([pathExtension isEqualToString:@"png"])
    {
        imageData       = UIImagePNGRepresentation(image);
    }
    else if([pathExtension isEqualToString:@"jpg"] || [pathExtension isEqualToString:@"jpeg"])
    {
        imageData       = UIImageJPEGRepresentation(image, 1.f);
    }
    else
        return;
    
    [imageData writeToFile:[self.cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", Key, pathExtension]] atomically:YES];
}

- (UIImage *)imageforKey:(NSString *)Key pathExtension:(NSString *)pathExtension
{
    NSString *path = [self.cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", Key, pathExtension]];
    if([self.fileManager fileExistsAtPath:path])
    {
        return [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
    }
    return nil;
}

@end
