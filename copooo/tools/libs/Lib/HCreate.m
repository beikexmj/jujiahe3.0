//
//  HCreate.m
//  Weizhi
//
//  Created by Jchy on 2017/5/18.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "HCreate.h"

@implementation HCreate

UIView *CreateView()
{
    return [[UIView alloc] init];
}

UILabel *CreateLabel()
{
    return [[UILabel alloc] init];
}

UIImageView *CreateImageview()
{
    return [[UIImageView alloc] init];
}

UIButton *CreateButton()
{
    return [UIButton buttonWithType:UIButtonTypeCustom];
}

@end
