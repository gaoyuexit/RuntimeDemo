//
//  NSMutableArray+Swizzling.m
//  runtime
//
//  Created by 郜宇 on 16/6/16.
//  Copyright © 2016年 郜宇. All rights reserved.
//

#import "NSMutableArray+Swizzling.h"
#import <objc/runtime.h>
#import "NSObject+Swizzling.h"
@implementation NSMutableArray (Swizzling)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        [self swizzleSelector:@selector(removeObject:) withSwizzledSelector:@selector(gy_safeRemoveObject:)];
        
        [objc_getClass("__NSArrayM") swizzleSelector:@selector(addObject:) withSwizzledSelector:@selector(gy_safeAddObject:)];
        
        [objc_getClass("__NSArrayM") swizzleSelector:@selector(objectAtIndex:) withSwizzledSelector:@selector(gy_safeObjectAtIndex:)];
        
        [objc_getClass("__NSArrayM") swizzleSelector:@selector(removeObjectAtIndex:) withSwizzledSelector:@selector(gy_safeRemoveObjectAtIndex:)];
        
        [objc_getClass("__NSArrayM") swizzleSelector:@selector(insertObject:atIndex:)
                                withSwizzledSelector:@selector(gy_safeInsertObject:atIndex:)];
        
    });
}


- (void)gy_safeRemoveObject:(id)obj
{
    if (obj == nil) {
        NSLog(@"%s call -removeObjcet:, but argument obj is nil", __FUNCTION__);
        return;
    }
    [self gy_safeRemoveObject:obj];
}


- (void)gy_safeAddObject:(id)obj
{
    if (obj == nil) {
        NSLog(@"%s can add nil object into NSMutableArray", __FUNCTION__);
    }else{
        [self gy_safeAddObject:obj];
    }
}

- (id)gy_safeObjectAtIndex:(NSUInteger)index
{
    if (self.count == 0) {
        NSLog(@"%s can't get any object from an empty array", __FUNCTION__);
        return nil;
    }
    if (index > self.count) {
        NSLog(@"%s index out of bounds in array", __FUNCTION__);
        return nil;
    }
    // 系统方法会自动调用很多次, 如果在这里面做复杂的判断, 结果可想而知....
//    NSLog(@"gy_safeObjectAtIndex");
    return [self gy_safeObjectAtIndex:index];
}


- (void)gy_safeRemoveObjectAtIndex:(NSUInteger)index
{
    if (self.count <= 0) {
        NSLog(@"%s can't get any object from an empty array", __FUNCTION__);
        return;
    }
    
    if (index >= self.count) {
        NSLog(@"%s index out of bound", __FUNCTION__);
        return;
    }
    [self gy_safeRemoveObjectAtIndex:index];
}


- (void)gy_safeInsertObject:(id)obj atIndex:(NSUInteger)index
{
    if (obj == nil) {
        NSLog(@"%s can't insert nil into NSMutableArray", __FUNCTION__);
    }else if (index > self.count){
        NSLog(@"%s index is invalid", __FUNCTION__);
    }else{
        [self gy_safeInsertObject:obj atIndex:index];
    }
}










@end
