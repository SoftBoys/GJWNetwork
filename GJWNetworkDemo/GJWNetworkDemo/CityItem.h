//
//  CityItem.h
//  GJWNetworkDemo
//
//  Created by dfhb@rdd on 16/8/12.
//  Copyright © 2016年 guojunwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityItem : NSObject
/** 城市id */
@property (nonatomic, assign) NSInteger city_id;
/** 城市名字 */
@property (nonatomic, copy) NSString *name;
/** 城市英文名字 */
@property (nonatomic, copy) NSString *enname;

@end
