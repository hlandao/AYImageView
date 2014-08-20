//
//  SPMImageAsyncView.h
//  ImageDL
//
//  Created by Pierre Abi-aad on 21/03/2014.
//  Copyright (c) 2014 Pierre Abi-aad. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AYImageViewDelegate <NSObject>
@optional
- (void)ayImageViewDidTapped:(id)view;
@end

@interface AYImageView : UIView

@property (nonatomic, weak) id<AYImageViewDelegate> delegate;

@property (nonatomic, assign, getter = isCacheEnabled) BOOL cacheEnabled;
@property (nonatomic, strong) UIImage *placeHolderImage;
@property (nonatomic, strong, readonly) UIImageView *containerImageView;

@property (nonatomic, strong) UIColor *backgroundProgresscolor;
@property (nonatomic, strong) UIColor *progressColor;

- (id)initWithFrame:(CGRect)frame backgroundProgressColor:(UIColor *)backgroundProgresscolor progressColor:(UIColor *)progressColor;
- (void)setImageURL:(NSURL *)imageURL;
- (void)setImageURL:(NSURL *)imageURL cacheKey:(NSString *)key;
- (void)setPlaceHolderImage:(UIImage *)placeHolderImage;
- (void)setHTTPHeaderValues:(NSDictionary *)header;

@end
