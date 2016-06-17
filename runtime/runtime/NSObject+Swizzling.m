//
//  NSObject+Swizzling.m
//  runtime
//
//  Created by 郜宇 on 16/6/15.
//  Copyright © 2016年 郜宇. All rights reserved.
//

#import "NSObject+Swizzling.h"

#if TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#import <objc/message.h>
#endif

@implementation NSObject (Swizzling)

+ (void)swizzleSelector:(SEL)originalSelector withSwizzledSelector:(SEL)swizzledSelector
{
    Class class = [self class];
    
    Method originalMehod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethd = class_getInstanceMethod(class, swizzledSelector);
    // 若已经存在, 则添加会失败
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethd), method_getTypeEncoding(swizzledMethd));
    
    // 若原来的方法方法并不存在, 则添加即可
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMehod), method_getTypeEncoding(originalMehod));
        
    }else{
        method_exchangeImplementations(originalMehod, swizzledMethd);
    }
}

/**
 *  因为这个方法可能不是在这个类里, 可能是在其父类中才有实现, 因此先尝试添加方法的实现, 若添加成功了, 则直接替换一下实现即可. 若添加失败了, 说明已经存在这个方法的实现了, 则只需要交换这两个方法的实现就可以了
 */











@end
