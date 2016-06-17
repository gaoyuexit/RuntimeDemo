//
//  People.h
//  runtime
//
//  Created by 郜宇 on 16/6/14.
//  Copyright © 2016年 郜宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface People : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign)NSUInteger age;


- (NSDictionary *)allProperties;
- (NSDictionary *)allIvars;
- (void)allMethods;


@end
