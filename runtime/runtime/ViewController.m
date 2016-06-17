//
//  ViewController.m
//  runtime
//
//  Created by 郜宇 on 16/6/13.
//  Copyright © 2016年 郜宇. All rights reserved.
//

#import "ViewController.h"
#import "People.h"
#import "People+Associated.h"
#import "Model.h"
#import "NSMutableArray+Swizzling.h"
#import "UIButton+GYAddition.h"


#ifdef TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#import <objc/message.h>
#endif







@interface ViewController ()

@end

@implementation ViewController






- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /**************************************************************************/
    /*                          动态添加类和方法成员变量                          */
    /**************************************************************************/

    NSLog(@"--------------------动态添加类和方法成员变量--------------------------");
    // 动态创建对象, 创建一个person, 继承自 NSObject类
    Class Person = objc_allocateClassPair([NSObject class], "Person", 0);
    // 为该类添加NSString *_name成员变量
    class_addIvar(Person, "_name", sizeof(NSString*), log2(sizeof(NSString*)), @encode(NSString*));
    // 为该类添加int _age 成员变量
    class_addIvar(Person, "_age", sizeof(int), log2(sizeof(int)), @encode(int));
    // 注册方法名为say的方法
    SEL s = sel_registerName("say:");
    // 为该类添加名为say的方法
    /**
     *   其中types参数为"i@:@“，按顺序分别表示：
         i：返回值类型int，若是v则表示void, @表示返回 NSString*
         @：参数id(self)
         :：SEL(_cmd)
         @：id(str)
     */
    class_addMethod(Person, s, (IMP)sayFunction, "v@:@");
    
    
    // 注册该类
    objc_registerClassPair(Person);
    
    // 创建一个Person类的实例
    id peopleInstance = [[Person alloc] init];
    
    // KVC动态改变对象peopleInstance中的实例变量
    [peopleInstance setValue:@"东方未明" forKey:@"name"];
    // 从类中获取成员变量Ivar
    Ivar ageIvar = class_getInstanceVariable(Person, "_age");
    // 为peopleInstance的成员变量赋值
    object_setIvar(peopleInstance, ageIvar, @18);
    
    
    /**
     objc_msgSend()报错Too many arguments to function call ,expected 0,have3
     直接通过objc_msgSend(self, setter, value)是报错，说参数过多。
     
     请这样解决：
     
     Build Setting–> Apple LLVM 7.0 – Preprocessing–> Enable Strict Checking of objc_msgSend Calls 改为 NO
     */
    
    
    
    // 调用peopleInstance 对象中的 s 方法选择器对应的方法
//    objc_msgSend(peopleInstance, s, @"大家好");
    // 这个在不传递参数的时候,可以调用添加的方法
//    [peopleInstance performSelector:@selector(say:)];
    
    //强制转换objc_msgSend函数类型为带三个参数且返回值为void函数，然后才能传三个参数。
    ((void (*)(id, SEL, id))objc_msgSend)(peopleInstance, s, @"大家好");
    
    
    peopleInstance = nil; // 当Person类或者他的子类的实例还存在, 则不能调用objc_disposeClassPair这个方法；因此这里要先销毁实例对象后才能销毁类;
    
    // 销毁类
    objc_disposeClassPair(Person);
    
    
    
    /**************************************************************************/
    /*                          遍历类的属性,成员变量,方法                        */
    /**************************************************************************/
    
    People *people = [[People alloc] init];
    people.name = @"东方未明";
    people.age = 18;
    [people setValue:@"iOS开发工程师" forKey:@"occupation"];
    
    // 1. 获取所有的属性
    NSLog(@"------------获取所有的属性-----------------");
    NSDictionary *propertiesDic = [people allProperties];
    NSLog(@"%@", propertiesDic);
    // 2. 获取所有的成员
    NSLog(@"------------获取所有的成员-----------------");
    NSDictionary *ivarsDic = [people allIvars];
    NSLog(@"%@", ivarsDic);
    // 3. 获取所有的方法
    NSLog(@"------------获取所有的方法-----------------");
    [people allMethods];
    
    
    /**************************************************************************/
    /*                              给分类扩充属性                              */
    /**************************************************************************/
    
    people.associateBust = @(90);
    people.associateCallBack = ^(){
        NSLog(@"我要开始写代码了...");
    };
    people.associateCallBack();
    
    /**************************************************************************/
    /*                  运行时归档和反归档(参见Person.m)                      */
    /**************************************************************************/
    
    
    
    /**************************************************************************/
    /*                 运行时字典和模型互相转换(参见Model.m)                       */
    /**************************************************************************/
    NSLog(@"--------------------模型字典互换--------------------------");
    NSDictionary *dict = @{
                           @"name" : @"苍井空",
                           @"age"  : @18,
                           @"occupation" : @"老师",
                           @"nationality" : @"日本"
                           };
    // 字典转模型
    Model *model = [[Model alloc] initWithDictionary:dict];
    NSLog(@"字典转模型: %@-%@-%@-%@",model.name, model.age, model.occupation, model.nationality);
    // 模型转字典
    NSDictionary *covertDict = [model covertToDictionary];
    NSLog(@"模型转字典: %@", covertDict);
    
    
    
    /**************************************************************************/
    /*                             Method-Swizzle                             */
    /**************************************************************************/
    
    NSMutableArray *mutaArr = [NSMutableArray array];
    
    [mutaArr removeObject:nil];
    
    [mutaArr objectAtIndex:5];
    
    
    
    
    /**************************************************************************/
    /*                              给分类扩充属性                              */
    /**************************************************************************/
    
    UIButton *btn = [UIButton buttonWithImage:nil title:@"下一页" backgroundColor:[UIColor redColor] cornerRadius:10.0 superView:self.view action:^(UIButton *button) {
        
        NSLog(@"点击了下一页");
        
    }];
    btn.frame = CGRectMake(100, 200, 100, 100);
    
    
    
    
}





/**
 *  添加到Person类实现(IMP)实现
 */
void sayFunction(id self, SEL _cmd, id some)
{
    NSLog(@"%@岁的%@说：%@", object_getIvar(self, class_getInstanceVariable([self class], "_age")),[self valueForKey:@"name"],some);
}

@end
