//
//  HColor.h
//  Weizhi
//
//  Created by hy on 17/2/15.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>

#define WZBackgroundGrayColor RGBA(0xF2F6F9, 1.0f)
#define WZTableViewGray RGBA(0xF2F4F7, 1.0f)

typedef void (^LoadImageWithVedioCompleted)(UIImage * _Nullable image);


@interface HColor : NSObject

#pragma mark 颜色

+ (UIColor * _Nullable )colorOfPoint:(CGPoint)point onView:(UIView * _Nullable )onView;

#pragma mark image
//纯色Image
UIImage * _Nullable CreateImageWithColor(UIColor * _Nullable color, CGSize size);
UIImage * _Nullable CreateRoundedRectImage(UIImage * _Nullable image, CGSize size, CGFloat r);
UIImage * _Nullable ImageFromCMSampleBuffer(CMSampleBufferRef _Nullable sampleBuffer, BOOL mirrored);
CMSampleBufferRef _Nullable SampleBufferRefFromCIImage(CIImage * _Nullable ciImage, CMSampleBufferRef _Nullable sampleBuffer);
UIImage * _Nullable blurredImageWithRadius(CGFloat radius, NSUInteger iterations, UIColor * _Nullable tintColor, UIImage * _Nullable oriImage);
UIImage * _Nullable GetCenterSubImageWithImage(UIImage * _Nullable image, CGSize size);
UIImage * _Nullable GetImageWithView(UIView * _Nullable view);
UIImage * _Nullable GetImageBoundsWithView(UIView * _Nullable view);
UIImage * _Nullable ImageWithImageSimple(UIImage * _Nullable image,CGSize newSize);
void ImageAsyncWithMediaURL(NSURL * _Nullable url,CGSize size, LoadImageWithVedioCompleted _Nullable completed);
UIColor * _Nonnull RGBA(NSInteger rgbValue, CGFloat alpha);
UIColor *_Nonnull ColorWithHexString(NSString * _Nullable color);

/**
 *  重新绘制图片
 *
 *  @param color 填充色
 *
 *  @return UIImage
 */
UIImage * _Nullable imageWithColor(UIImage * _Nullable image, UIColor *_Nullable color);

/*
 @return 返回一张带边框的图片
 */
UIImage * _Nullable imageDashedWithSize(CGSize size,UIColor * _Nullable color,CGFloat borderWidth);
/*
 @borderType 1.  horizontalLine   2. verticalLine
 @return 返回一张带边框的图片
 */
UIImage * _Nullable imageDashedLineWithSize(CGSize size,UIColor *_Nullable color,CGFloat borderWidth,int borderType);
;
void imageDashedWithView(UIView *_Nullable view,UIColor * _Nullable color,CGFloat borderWidth);

//两张图合成叠加
UIImage *_Nullable addImage(UIImage * _Nullable image1,UIImage * _Nullable image2);

CGSize getSizeimage(UIImage * _Nullable image,CGFloat maxWidth);



@end
