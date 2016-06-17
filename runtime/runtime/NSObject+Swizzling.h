//
//  NSObject+Swizzling.h
//  runtime
//
//  Created by 郜宇 on 16/6/15.
//  Copyright © 2016年 郜宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzling)


/**
 *  给基类添加一个通用的Swizzle方法
 *
 *  @param originalSelector 原始方法
 *  @param swizzledSelector 交换的方法
 */
+ (void)swizzleSelector:(SEL)originalSelector withSwizzledSelector:(SEL)swizzledSelector;


@end
