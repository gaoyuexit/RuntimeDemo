//
//  UIButton+GYAddition.h
//  GYAddition
//
//  Created by 郜宇 on 16/5/31.
//  Copyright © 2016年 郜宇. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ButtonActionBlock)(UIButton *button);


@interface UIButton (GYAddition)

@property (nonatomic, copy) ButtonActionBlock buttonBlock;



+ (UIButton *)buttonWithImage:(UIImage *)image
              backgroundColor:(UIColor *)backgroundColor
                 cornerRadius:(float)cornerRadius
                    superView:(UIView *)superView
                       action:(ButtonActionBlock)buttonBlock;


+ (UIButton *)buttonWithImage:(UIImage *)image
                        title:(NSString *)title
              backgroundColor:(UIColor *)backgroundColor
                 cornerRadius:(float)cornerRadius
                    superView:(UIView *)superView
                       action:(ButtonActionBlock)buttonBlock;



@end
