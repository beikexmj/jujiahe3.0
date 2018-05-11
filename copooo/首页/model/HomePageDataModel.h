//
//  HomePageDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2018/1/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HomePageForm,Advertisement_data,Advertisement_dataArr,
Broadcast_dataArr,Daily_word_data,Menu_dataArr,Template_dataArr,Activity_formArr,NeighborhoodFormArr,NeighborhoodForm;
@interface HomePageDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HomePageForm *form;

@end
@interface HomePageForm : NSObject

@property (nonatomic, strong) Advertisement_data *advertisement_data;
@property (nonatomic, strong) NSArray<Broadcast_dataArr *> *broadcast_data;
@property (nonatomic, strong) Daily_word_data *daily_word_data;

@property (nonatomic, strong) NSArray<Menu_dataArr *> *menu_data;

@property (nonatomic, strong) NSMutableArray<Template_dataArr *> *template_data;

@end

@interface Advertisement_data : NSObject

@property (nonatomic, strong) NSArray <Advertisement_dataArr *> *data;
@property (nonatomic, copy) NSString *roll_time;

@end

@interface Advertisement_dataArr : NSObject

@property (nonatomic, copy) NSString *file_type;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *url;

@end

@interface Broadcast_dataArr : NSObject

@property (nonatomic, copy) NSString *file_type;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *type_name;

@property (nonatomic, copy) NSString *url;

@end
@interface Daily_word_data : NSObject

@property (nonatomic, copy) NSString *background_image;

@property (nonatomic, copy) NSString *file_type;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *ids;


@end
@interface Menu_dataArr : NSObject

@property (nonatomic, copy) NSString *file_type;

@property (nonatomic, assign) NSInteger hot;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *ids;


@end

@interface Template_dataArr : NSObject

@property (nonatomic, copy) NSString *ids;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *goodsTypeId;

@end

@interface Activity_form : NSObject

@property (nonatomic, strong) NSArray <Activity_formArr *> *form;

@end

@interface Activity_formArr : NSObject

@property (nonatomic, copy) NSString *activity_price;

@property (nonatomic, copy) NSString *file_type;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, assign) NSInteger is_main;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *goodsTypeId;


@end

@interface NeighborhoodForm :NSObject

@property (nonatomic, strong) NSArray <NeighborhoodFormArr *> *form;

@end

@interface NeighborhoodFormArr :NSObject

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *ids;

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger userType;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) NSInteger anon;

@end
