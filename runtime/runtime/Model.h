//
//  Model.h
//  runtime
//
//  Created by 郜宇 on 16/6/14.
//  Copyright © 2016年 郜宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

@property (nonatomic, copy)     NSString *name;                     //姓名
@property (nonatomic, strong)   NSNumber *age;                      //年龄
@property (nonatomic, copy)     NSString *occupation;               //职业
@property (nonatomic, copy)     NSString *nationality;              //国籍



/**
 *  生成model
 */
- (instancetype)initWithDictionary:(NSDictionary *)dict;

/**
 *  转换成字典
 */
- (NSDictionary *)covertToDictionary;




@end
