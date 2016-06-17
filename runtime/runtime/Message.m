//
//  Message.m
//  runtime
//
//  Created by 郜宇 on 16/6/15.
//  Copyright © 2016年 郜宇. All rights reserved.
//

#import "Message.h"

#if TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#import <objc/message.h>
#endif

@implementation Message





@end
