//
//  HJPhotoPickerView.m
//  HJPhotoPikerDemo
//
//  Created by 黄靖 on 16/3/26.
//  Copyright © 2016年 易工科技. All rights reserved.
//

#import "HJPhotoPickerView.h"
#import "ACMediaFrameConst.h"

#define IMAGE_SIZE (SCREENWIDTH - 60)/4
@implementation HJPhotoPickerView
- (NSMutableArray *)imageViews{
    if (!_imageViews) {
        _imageViews = [[NSMutableArray alloc]init];
    }
    return _imageViews;
}
- (instancetype)init
{
    self = [super init];
    if (self) {

        self.frame = CGRectMake(0, 0, SCREENWIDTH, IMAGE_SIZE + 20);
        _photoNum = 10;
        _addImage = [UIImage imageNamed:@"addPic"];
        NSMutableArray * images = [NSMutableArray arrayWithObjects:_addImage, nil];
        [self setSelectedImages:images];
    }
    return self;
}
- (void)setSelectedImages:(NSMutableArray *)selectedImages{
    _rowCount = 1;
     [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_selectedImages removeAllObjects];
    [_selectedImages addObjectsFromArray:selectedImages];
    int j = 0;
    
    for (int i = 1; i < selectedImages.count + 1; i ++) {
        if (i >= _photoNum)          return;
        
        if (i % (4*_rowCount + 1) == 0){
            _rowCount ++;
            j = 0;
            self.frame = CGRectMake(0, self.frame.origin.y, SCREENWIDTH, (IMAGE_SIZE + 10) * _rowCount);
            self.reloadTableViewBlock();
        }else{
            self.frame = CGRectMake(0, self.frame.origin.y, SCREENWIDTH, (IMAGE_SIZE + 10) * _rowCount);
        }
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(15 + (IMAGE_SIZE + 10) * j, (_rowCount - 1) * (IMAGE_SIZE + 10), IMAGE_SIZE, IMAGE_SIZE);
        button.tag = i ;
        [button setBackgroundImage:selectedImages[i - 1] forState:UIControlStateNormal];
        [self addSubview:button];
        [self.imageViews addObject:button];
        
        _deleteButton = [[UIButton alloc] init];
        [_deleteButton setBackgroundImage:[UIImage imageForResourcePath:@"ACMediaFrame.bundle/deleteButton" ofType:@"png" inBundle:[NSBundle bundleForClass:[self class]]] forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(button.bounds.size.width - ACMediaDeleteButtonWidth, 0, ACMediaDeleteButtonWidth, ACMediaDeleteButtonWidth);
        [_deleteButton addTarget:self action:@selector(clickDeleteButton) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.tag = 10;
        [button addSubview:_deleteButton];
        
        _videoImageView = [[UIImageView alloc] initWithImage:[UIImage imageForResourcePath:@"ACMediaFrame.bundle/ShowVideo" ofType:@"png" inBundle:[NSBundle bundleForClass:[self class]]]];
        _videoImageView.frame = CGRectMake(button.bounds.size.width/4, button.bounds.size.width/4, button.bounds.size.width/2, button.bounds.size.width/2);
        _videoImageView.tag  = 20;
        [button addSubview:_videoImageView];
        
        j ++;
    }
}

- (void)clickDeleteButton {
    !_ACMediaClickDeleteButton ?  :_ACMediaClickDeleteButton();
}

@end
