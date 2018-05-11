//
//  HColor.m
//  Weizhi
//
//  Created by hy on 17/2/15.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "HColor.h"
#import <ImageIO/ImageIO.h>
#import <Accelerate/Accelerate.h>
#import <AVFoundation/AVFoundation.h>

@implementation HColor

#pragma mark 颜色
+ (UIColor * _Nullable )colorOfPoint:(CGPoint)point onView:(UIView * _Nullable )onView
{
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (uint32_t)kCGImageAlphaPremultipliedLast);
    CGContextTranslateCTM(context, -point.x, -point.y);
    [onView.layer renderInContext:context];
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    return color;
}

#pragma mark image
//纯色Image
UIImage * _Nullable CreateImageWithColor(UIColor * _Nullable color, CGSize size)
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw,fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}


UIImage * _Nullable CreateRoundedRectImage(UIImage * _Nullable image, CGSize size, CGFloat r) //由外部释放
{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, 2/*kCGImageAlphaPremultipliedFirst*/);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}

UIImage * _Nullable ImageFromCMSampleBuffer(CMSampleBufferRef _Nullable sampleBuffer, BOOL mirrored)
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    //CGContextConcatCTM(context, CGAffineTransformMakeRotation(-PI_PI_PI/4));
    
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    //UIImage *image = [UIImage imageWithCGImage:quartzImage];
    //int frontCameraImageOrientation = UIImageOrientationLeftMirrored;
    //int backCameraImageOrientation = UIImageOrientationRight;
    UIImageOrientation orientation = UIImageOrientationRight;
    if (mirrored) {
        orientation = UIImageOrientationLeftMirrored;
    }
    UIImage *image = [[UIImage alloc] initWithCGImage:quartzImage scale:2 orientation:orientation];
    image = GetCenterSubImageWithImage(image, CGSizeMake(480.0, 480.0));
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

static CIContext *ciContext = nil;

CMSampleBufferRef _Nullable SampleBufferRefFromCIImage(CIImage * _Nullable ciImage, CMSampleBufferRef _Nullable sampleBuffer)
{
    CVPixelBufferRef pixelBuffer;
    CVPixelBufferCreate(kCFAllocatorSystemDefault, 640, 480, kCVPixelFormatType_32BGRA, NULL, &pixelBuffer);
    
    CVPixelBufferLockBaseAddress( pixelBuffer, 0 );
    
    if (!ciContext) {
        ciContext = [CIContext contextWithOptions: nil];
    }
    [ciContext render:ciImage toCVPixelBuffer:pixelBuffer];
    CVPixelBufferUnlockBaseAddress( pixelBuffer, 0 );
    
    CMSampleTimingInfo sampleTime = {
        .duration = CMSampleBufferGetDuration(sampleBuffer),
        .presentationTimeStamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer),
        .decodeTimeStamp = CMSampleBufferGetDecodeTimeStamp(sampleBuffer)
    };
    
    CMVideoFormatDescriptionRef videoInfo = NULL;
    CMVideoFormatDescriptionCreateForImageBuffer(kCFAllocatorDefault, pixelBuffer, &videoInfo);
    
    CMSampleBufferRef oBuf;
    CMSampleBufferCreateForImageBuffer(kCFAllocatorDefault, pixelBuffer, true, NULL, NULL, videoInfo, &sampleTime, &oBuf);
    CVPixelBufferRelease(pixelBuffer);
    
    return oBuf;
}


UIImage * _Nullable blurredImageWithRadius(CGFloat radius, NSUInteger iterations, UIColor * _Nullable tintColor, UIImage * _Nullable oriImage)
{
    //image must be nonzero size
    if (floorf(oriImage.size.width) * floorf(oriImage.size.height) <= 0.0f) return oriImage;
    
    //boxsize must be an odd integer
    uint32_t boxSize = (uint32_t)(radius * oriImage.scale);
    if (boxSize % 2 == 0) boxSize ++;
    
    //create image buffers
    CGImageRef imageRef = oriImage.CGImage;
    vImage_Buffer buffer1, buffer2;
    buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
    buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
    buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
    size_t bytes = buffer1.rowBytes * buffer1.height;
    buffer1.data = malloc(bytes);
    buffer2.data = malloc(bytes);
    
    //create temp buffer
    void *tempBuffer = malloc((size_t)vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
                                                                 NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));
    
    //copy image data
    CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
    CFRelease(dataSource);
    
    for (NSUInteger i = 0; i < iterations; i++)
    {
        //perform blur
        vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        //swap buffers
        void *temp = buffer1.data;
        buffer1.data = buffer2.data;
        buffer2.data = temp;
    }
    
    //free buffers
    free(buffer2.data);
    free(tempBuffer);
    
    //create image context from buffer
    CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
                                             8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
                                             CGImageGetBitmapInfo(imageRef));
    
    //apply tint
    if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0f)
    {
        CGContextSetFillColorWithColor(ctx, [tintColor colorWithAlphaComponent:0.25].CGColor);
        CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
        CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
    }
    
    //create image from context
    imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:oriImage.scale orientation:oriImage.imageOrientation];
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    free(buffer1.data);
    return image;
}

//截取图片中间部分
UIImage * _Nullable GetCenterSubImageWithImage(UIImage * _Nullable image, CGSize size) {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.image = image;
    
    return GetImageWithView(imageView);
}

UIImage * _Nullable GetImageWithView(UIView * _Nullable view) {
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 2);
    
    //获取图像
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //    if (image.size.width > 320) {
    //        UIImage *imageTemp = ImageWithImageSimple(image,CGSizeMake(660, 660));
    //        return imageTemp;
    //    }
    
    return image;
}

UIImage * _Nullable GetImageBoundsWithView(UIView * _Nullable view) {
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0);
    //获取图像
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

UIImage * _Nullable ImageWithImageSimple(UIImage * _Nullable image,CGSize newSize) {
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

void ImageAsyncWithMediaURL(NSURL * _Nullable url,CGSize size,  LoadImageWithVedioCompleted _Nullable completed)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                         forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        // 初始化媒体文件
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
        // 根据asset构造一张图
        AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
        // 设定缩略图的方向
        // 如果不设定，可能会在视频旋转90/180/270°时，获取到的缩略图是被旋转过的，而不是正向的（自己的理解）
        generator.appliesPreferredTrackTransform = YES;
        // 设置图片的最大size(分辨率)
        generator.maximumSize = size;
        // 初始化error
        NSError *error = nil;
        // 根据时间，获得第N帧的图片
        // CMTimeMake(a, b)可以理解为获得第a/b秒的frame
        CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(1, 1) actualTime:NULL error:&error];
        // 构造图片
        UIImage *image = [UIImage imageWithCGImage: img];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completed)
                completed(image);
        });
    });
}

UIColor * _Nonnull RGBA(NSInteger rgbValue, CGFloat alpha) {
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
                           green:((rgbValue & 0xFF00) >> 8)/255.0
                            blue:(rgbValue & 0xFF)/255.0
                           alpha:alpha];
}

UIColor *_Nonnull ColorWithHexString(NSString * _Nullable color)
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

/**
 *  重新绘制图片
 *
 *  @param color 填充色
 *
 *  @return UIImage
 */
UIImage * _Nullable imageWithColor(UIImage * _Nullable image, UIColor * _Nullable color)
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/*
 @return 返回一张带边框的图片
 */
UIImage * _Nullable imageDashedWithSize(CGSize size,UIColor *_Nullable color,CGFloat borderWidth)
{
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [[UIColor clearColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGFloat lengths[] = { 3, 2};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, size.width, 0.0);
    CGContextAddLineToPoint(context, size.width, size.height);
    CGContextAddLineToPoint(context, 0, size.height);
    CGContextAddLineToPoint(context, 0.0, 0.0);
    CGContextStrokePath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/*
 @borderType 1.  horizontalLine   2. verticalLine
 @return 返回一张带边框的图片
 */
UIImage * _Nullable imageDashedLineWithSize(CGSize size,UIColor *_Nullable color,CGFloat borderWidth,int borderType)
{
    //borderType 1. topLine   2. downLine  3. leftLine  4. rightLine
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [[UIColor clearColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGFloat lengths[] = { 3, 2};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextMoveToPoint(context, 0.0, 0.0);

    if (borderType == 1) {
        CGContextAddLineToPoint(context, size.width, 0.0);
    }else {
        CGContextAddLineToPoint(context, 0, size.height);
    }

    CGContextStrokePath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

void imageDashedWithView(UIView *_Nullable view,UIColor *_Nullable color,CGFloat borderWidth)
{
    CAShapeLayer *border = [CAShapeLayer layer];
    //  线条颜色
    border.strokeColor = color.CGColor;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    border.frame = view.bounds;
    // 不要设太大 不然看不出效果
    border.lineWidth = borderWidth;
    border.lineCap = @"square";
    //  第一个是 线条长度   第二个是间距    nil时为实线
    border.lineDashPattern = @[@9, @4];
    [view.layer addSublayer:border];
}

//两张图合成叠加
UIImage *_Nullable addImage(UIImage * _Nullable image1,UIImage * _Nullable image2)
{
    UIGraphicsBeginImageContext(image1.size);
    
    // Draw image1
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    // Draw image2
    [image2 drawInRect:CGRectMake(image1.size.width/2 - image2.size.width/2, image1.size.height/2 - image2.size.height/2, image2.size.width, image2.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

CGSize getSizeimage(UIImage * _Nullable image,CGFloat maxWidth)
{
    CGFloat maxHeight = maxWidth;
    CGFloat widthRatio = (maxWidth) / image.size.width;
    CGFloat heightRatio = (maxHeight) / image.size.height;
    CGFloat scale = MIN(widthRatio, heightRatio);
    if (scale > 1) {
        scale = 0.6;
    }
    CGFloat width = scale * image.size.width;
    CGFloat height = scale * image.size.height;
    CGRect imgFrame = CGRectMake((maxWidth - width) / 2, (maxHeight - height) / 2, width, height);
    return CGSizeMake(imgFrame.size.width, imgFrame.size.height);
}


@end
