//
//  People+Associated.m
//  runtime
//
//  Created by 郜宇 on 16/6/14.
//  Copyright © 2016年 郜宇. All rights reserved.
//

#import "People+Associated.h"

#if TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#import <objc/message.h>
#endif

@implementation People (Associated)

- (void)setAssociateBust:(NSNumber *)associateBust
{
    // 设置关联对象
    // 因为@selector(associateBust),方法名就是字符串, 所以这里用来隐式的字符串key来记录,方法名就是_cmd
    objc_setAssociatedObject(self, @selector(associateBust), associateBust, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (NSNumber *)associateBust
{
    // 得到关联对象
    return objc_getAssociatedObject(self, @selector(associateBust));
}

- (void)setAssociateCallBack:(CodingCallBack)associateCallBack
{
    objc_setAssociatedObject(self, @selector(associateCallBack), associateCallBack, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CodingCallBack)associateCallBack
{
    return objc_getAssociatedObject(self, @selector(associateCallBack));
}






@end
