//
//  UIButton+GYAddition.m
//  GYAddition
//
//  Created by 郜宇 on 16/5/31.
//  Copyright © 2016年 郜宇. All rights reserved.
//

#import "UIButton+GYAddition.h"
#import <objc/runtime.h>


const void *gy_btnActionKey = "gy_btnActionKey";
@implementation UIButton (GYAddition)

- (void)setButtonBlock:(ButtonActionBlock)buttonBlock
{
    objc_setAssociatedObject(self, gy_btnActionKey, buttonBlock, OBJC_ASSOCIATION_COPY);
    
    [self removeTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
    if (buttonBlock) {
        [self addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (ButtonActionBlock)buttonBlock
{
    return objc_getAssociatedObject(self, gy_btnActionKey);
}

- (void)touchUpInsideAction:(UIButton *)button
{
    ButtonActionBlock buttonAcitonBlock = self.buttonBlock;
    if (buttonAcitonBlock) {
        buttonAcitonBlock(button);
    }
}

+ (UIButton *)buttonWithImage:(UIImage *)image
              backgroundColor:(UIColor *)backgroundColor
                 cornerRadius:(float)cornerRadius
                    superView:(UIView *)superView
                       action:(ButtonActionBlock)buttonBlock
{
    return [self buttonWithImage:image title:nil backgroundColor:backgroundColor cornerRadius:cornerRadius superView:superView action:buttonBlock];
}


+ (UIButton *)buttonWithImage:(UIImage *)image
                        title:(NSString *)title
              backgroundColor:(UIColor *)backgroundColor
                 cornerRadius:(float)cornerRadius
                    superView:(UIView *)superView
                       action:(ButtonActionBlock)buttonBlock
{
    UIButton *button            = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor      = backgroundColor;
    button.layer.cornerRadius   = cornerRadius;
    button.layer.masksToBounds  = YES;
    button.buttonBlock          = buttonBlock;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (superView) {
        [superView addSubview:button];
    }
    return button;
}














@end
