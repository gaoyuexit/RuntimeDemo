//
//  People.m
//  runtime
//
//  Created by 郜宇 on 16/6/14.
//  Copyright © 2016年 郜宇. All rights reserved.
//

#import "People.h"

#ifdef TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#import <objc/message.h>
#endif

@interface People () <NSCoding>
{
    NSString *_occupation; // 职业
    NSString *_nationality;// 国籍
}


@end




@implementation People

- (NSDictionary *)allProperties
{
    
    unsigned int count = 0;
    // 获取类的所有属性, 如果没有属性,count就为0
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionaryWithCapacity:count];
    
    for (NSUInteger i = 0; i < count; i++) {
        
        // 获取属性的名称和值
        const char *propertyName = property_getName(properties[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        id propertyValue = [self valueForKey:name];
        
        if (propertyValue) {
            resultDict[name] = propertyValue;
        }else{
            resultDict[name] = @"该属性对应的值为空";
        }
    }
    
    // 这里properties是一个数组指针, 我们需要使用free函数来释放内存
    free(properties);
    return resultDict;
}

- (NSDictionary *)allIvars
{
    
    unsigned int count = 0;
    
    Ivar *ivars = class_copyIvarList([self class], &count);
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithCapacity:count];
    
    for (NSUInteger i = 0; i < count; i++) {
        const char *ivarName = ivar_getName(ivars[i]);
        NSString *name = [NSString stringWithUTF8String:ivarName];
        id ivarValue = [self valueForKey:name];
        if (ivarValue) {
            resultDic[name] = ivarValue;
        }else{
            resultDic[name] = @"该成员变量对应的值为空";
        }
    }
    free(ivars);
    return resultDic;
    
}

- (void)allMethods
{
    unsigned int count = 0;
    Method *methods = class_copyMethodList([self class], &count);
    for (NSUInteger i = 0; i < count; i++) {
        
        // 取得方法
        Method method = methods[i];
        
        // 获取方法名称
        SEL methodSEL = method_getName(method);
        // 也可以获取方法名称
//        NSString *name = NSStringFromSelector(methodSEL);
        const char *methodName = sel_getName(methodSEL);
        NSString *name = [NSString stringWithUTF8String:methodName];
        NSLog(@"----------- 方法名 :%@ ------------", name);
        
        // 获取方法的参数类型(前两个参数为 id self, SEL _cmd)
        
        // 获取参数个数(包含 id self, SEL _cmd)
        unsigned int argumentsCount = method_getNumberOfArguments(method);
        char argName[512] = {};
        for (unsigned int j = 0; j < argumentsCount; j++) {
            // 获得该参数的类型
            method_getArgumentType(method, j, argName, 512);
            NSLog(@"第%u个参数类型为: %s",j,argName);
            // 字符串数组清零
            memset(argName, '\0', strlen(argName));
        }
        
        char returnType[512] = {};
        // 获取方法的返回值类型
        method_getReturnType(method, returnType, 512);
        NSLog(@"返回值类型: %s", returnType);
        
        // 获取方法的type encoding
        NSLog(@"TypeEncoding: %s", method_getTypeEncoding(method));  
    }
    free(methods);
}



/**************************************************************************/
/*                  运行时归档和反归档(遵循NSCoding协议)                      */
/**************************************************************************/

/**
 *  归档
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        const char *ivarName = ivar_getName(ivars[i]);
        NSString *name = [NSString stringWithUTF8String:ivarName];
        id value = [self valueForKey:name];
        [aCoder encodeObject:value forKey:name];
    }
    free(ivars);
}


/**
 *  解档
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (unsigned int i = 0; i < count; i++) {
            const char *ivarName = ivar_getName(ivars[i]);
            NSString *name = [NSString stringWithUTF8String:ivarName];
            id value = [aDecoder decodeObjectForKey:name];
            [self setValue:value forKey:name];
        }
        free(ivars);
    }
    return self;
}










@end
