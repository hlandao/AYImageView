//
//  SPMImageAsyncView.m
//  ImageDL
//
//  Created by Pierre Abi-aad on 21/03/2014.
//  Copyright (c) 2014 Pierre Abi-aad. All rights reserved.
//

#import "PAImageView.h"
#import "SDWebImageDownloader.h"
#import "SDImageCache.h"

#pragma mark - Utils

#define rad(degrees) ((degrees) / (180.0 / M_PI))
#define kLineWidth 3.f

@interface PAImageView ()

@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong, readwrite) UIImageView *containerImageView;
@property (nonatomic, strong) UIView      *progressContainer;

@property (nonatomic, strong) SDImageCache *cache;

@end

#pragma mark - SPMImageAsyncView


@implementation PAImageView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self commonInitWithFrame:self.frame
          backgroundProgressColor:[UIColor whiteColor]
                    progressColor:[UIColor blueColor]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [[PAImageView alloc] initWithFrame:frame
                      backgroundProgressColor:[UIColor whiteColor]
                                progressColor:[UIColor blueColor]];
}

- (id)initWithFrame:(CGRect)frame backgroundProgressColor:(UIColor *)backgroundProgresscolor progressColor:(UIColor *)progressColor
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInitWithFrame:frame
          backgroundProgressColor:backgroundProgresscolor
                    progressColor:progressColor];
    }
    return self;
}

- (void)commonInitWithFrame:(CGRect)frame backgroundProgressColor:(UIColor *)backgroundProgresscolor progressColor:(UIColor *)progressColor
{
    _backgroundProgresscolor = backgroundProgresscolor;
    _progressColor = progressColor;
    
    self.layer.cornerRadius     = CGRectGetWidth(self.bounds)/2.f;
    self.layer.masksToBounds    = NO;
    self.clipsToBounds          = YES;
    self.cacheEnabled               = YES;
    
    self.cache = [SDImageCache sharedImageCache];
    
    CGPoint arcCenter           = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius              = MIN(CGRectGetMidX(self.bounds) - 1, CGRectGetMidY(self.bounds)-1);
    
    UIBezierPath *circlePath    = [UIBezierPath bezierPathWithArcCenter:arcCenter
                                                                 radius:radius
                                                             startAngle:-rad(90)
                                                               endAngle:rad(360-90)
                                                              clockwise:YES];
    
    self.backgroundLayer = [CAShapeLayer layer];
    self.backgroundLayer.path           = circlePath.CGPath;
    self.backgroundLayer.strokeColor    = [backgroundProgresscolor CGColor];
    self.backgroundLayer.fillColor      = [[UIColor clearColor] CGColor];
    self.backgroundLayer.lineWidth      = kLineWidth;
    
    
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.path         = self.backgroundLayer.path;
    self.progressLayer.strokeColor  = [progressColor CGColor];
    self.progressLayer.fillColor    = self.backgroundLayer.fillColor;
    self.progressLayer.lineWidth    = self.backgroundLayer.lineWidth;
    self.progressLayer.strokeEnd    = 0.f;
    
    
    self.progressContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.progressContainer.layer.cornerRadius   = CGRectGetWidth(self.bounds)/2.f;
    self.progressContainer.layer.masksToBounds  = NO;
    self.progressContainer.clipsToBounds        = YES;
    self.progressContainer.backgroundColor      = [UIColor clearColor];
    
    self.containerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, frame.size.width-2, frame.size.height-2)];
    self.containerImageView.layer.cornerRadius = CGRectGetWidth(self.bounds)/2.f;
    self.containerImageView.layer.masksToBounds = NO;
    self.containerImageView.clipsToBounds = YES;
    self.containerImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.progressContainer.layer addSublayer:self.backgroundLayer];
    [self.progressContainer.layer addSublayer:self.progressLayer];
    
    [self addSubview:self.containerImageView];
    [self addSubview:self.progressContainer];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleSingleTap:)];
    [self addGestureRecognizer:tapRecognizer];
}

- (void)handleSingleTap:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(paImageViewDidTapped:)])
    {
        [self.delegate paImageViewDidTapped:self];
    }
}

- (void)setBackgroundProgresscolor:(UIColor *)backgroundProgresscolor
{
    _backgroundProgresscolor = backgroundProgresscolor;
    self.backgroundLayer.strokeColor = [backgroundProgresscolor CGColor];
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
    self.progressLayer.strokeColor  = [progressColor CGColor];
}

- (void)setPlaceHolderImage:(UIImage *)placeHolderImage
{
    [self setPlaceHolderImage:placeHolderImage force:NO];
}

- (void)setPlaceHolderImage:(UIImage *)placeHolderImage force:(BOOL)force
{
    _placeHolderImage = placeHolderImage;
    
    if (force)
    {
        self.containerImageView.image = placeHolderImage;
        return;
    }
    
    if (!self.containerImageView.image)
    {
        self.containerImageView.image = placeHolderImage;
    }
}

- (void)setImageURL:(NSURL *)imageURL cacheKey:(NSString *)key
{
    if (self.cacheEnabled)
    {
        __weak __typeof(self)weakSelf = self;
        [self.cache queryDiskCacheForKey:key
                                    done:^(UIImage *cachedImage, SDImageCacheType cacheType) {
                                        if(cachedImage)
                                        {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [weakSelf updateWithImage:cachedImage animated:NO];
                                            });
                                        }
                                        else
                                        {
                                            [weakSelf downloadImageWithUrl:imageURL
                                                                  cacheKey:key];
                                        }
                                    }];
    }
    else
    {
        [self downloadImageWithUrl:imageURL
                          cacheKey:key];
    }
}

- (void)setImageURL:(NSURL *)imageURL
{
    NSString *key = [imageURL absoluteString];
    [self setImageURL:imageURL cacheKey:key];
}

- (void)downloadImageWithUrl:(NSURL *)imageURL cacheKey:(NSString *)key
{
    __weak __typeof(self)weakSelf = self;
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:imageURL
                                                        options:0
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize)
     {
         // progression tracking code
         CGFloat progress = (CGFloat)receivedSize/(CGFloat)expectedSize;
         
         weakSelf.progressLayer.strokeEnd        = progress;
         weakSelf.backgroundLayer.strokeStart    = progress;
     }
                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
         if (image && finished)
         {
             // do something with image
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf updateWithImage:image animated:YES];
             });
             
             if(weakSelf.cacheEnabled)
             {
                 [weakSelf.cache storeImage:image forKey:key];
             }
         }
     }];
}

- (void)updateWithImage:(UIImage *)image animated:(BOOL)animated
{
    CGFloat duration    = (animated) ? 0.3 : 0.f;
    CGFloat delay       = (animated) ? 0.1 : 0.f;
    
    self.containerImageView.transform   = CGAffineTransformMakeScale(0, 0);
    self.containerImageView.alpha       = 0.f;
    self.containerImageView.image       = image;
    
    [UIView animateWithDuration:duration
                     animations:^{
                         self.progressContainer.transform    = CGAffineTransformMakeScale(1.1, 1.1);
                         self.progressContainer.alpha        = 0.f;
                         [UIView animateWithDuration:duration
                                               delay:delay
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              self.containerImageView.transform   = CGAffineTransformIdentity;
                                              self.containerImageView.alpha       = 1.f;
                                          } completion:nil];
                     } completion:^(BOOL finished) {
                         self.progressLayer.strokeColor = [self.backgroundProgresscolor CGColor];
                         [UIView animateWithDuration:duration
                                          animations:^{
                                              self.progressContainer.transform    = CGAffineTransformIdentity;
                                              self.progressContainer.alpha        = 1.f;
                                          }];
                     }];
}


@end
