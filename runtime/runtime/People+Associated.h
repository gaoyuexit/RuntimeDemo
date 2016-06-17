//
//  People+Associated.h
//  runtime
//
//  Created by 郜宇 on 16/6/14.
//  Copyright © 2016年 郜宇. All rights reserved.
//  分类的关联

#import "People.h"

typedef void(^CodingCallBack)();

@interface People (Associated)

@property (nonatomic, strong) NSNumber *associateBust;              // 胸围
@property (nonatomic, copy  ) CodingCallBack associateCallBack;     // 写代码


@end
