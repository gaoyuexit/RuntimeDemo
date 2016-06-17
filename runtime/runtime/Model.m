//
//  Model.m
//  runtime
//
//  Created by 郜宇 on 16/6/14.
//  Copyright © 2016年 郜宇. All rights reserved.
//

#import "Model.h"

#if TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#import <objc/message.h>
#endif
@implementation Model


/**
 *  生成model
 */
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
//        [self setValuesForKeysWithDictionary:dict];
        for (NSString *key in dict.allKeys) {
            id value = dict[key];
            
            // 找到每个字典key对应的setter方法, 并执行setter方法给该类赋值
            SEL setter = [self propertySetterByKey:key];
            if (setter) {
//                objc_msgSend();
                
                // 这里还可以使用NSInvocation或者method_invoke
                // 前两个是默认参数, 最后一个id是自定义的参数
                ((void(*)(id, SEL, id))objc_msgSend)(self, setter, value);
                
            }
        }
    }
    return self;
}

/**
 *  转换成字典
 */
- (NSDictionary *)covertToDictionary
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    if (count != 0) {
        NSMutableDictionary *resultDict = [NSMutableDictionary dictionaryWithCapacity:count];
        for (unsigned int i = 0; i < count; i++) {
            const char *propertyName = property_getName(properties[i]);
            NSString *name = [NSString stringWithUTF8String:propertyName];
            // 根据模型的属性,找到该属性的getter方法,执行getter方法,取得属性值,然后转化成字典
            SEL getter = [self propertyGetterByKey:name];
            if (getter) {
                id value = ((id(*)(id, SEL))objc_msgSend)(self, getter);
                if (value) {
                    resultDict[name] = value;
                }else{
                    resultDict[name] = @"该key对应的值为空";
                }
                
            }
        }
        free(properties);
        return resultDict;
        
    }
    
    free(properties);
    return nil;
}


#pragma mark - private methods


// 生成setter方法
- (SEL)propertySetterByKey:(NSString *)key
{
    // setter方法时, set后面的属性的首字母是大写的
    NSString *propertySetterName = [NSString stringWithFormat:@"set%@:", key.capitalizedString];
    SEL setter = NSSelectorFromString(propertySetterName);
    if ([self respondsToSelector:setter]) {
        return setter;
    }
    return nil;
}

// 生成getter方法
- (SEL)propertyGetterByKey:(NSString *)key
{
    SEL getter = NSSelectorFromString(key);
    if ([self respondsToSelector:getter]) {
        return getter;
    }
    return nil;
}








@end
