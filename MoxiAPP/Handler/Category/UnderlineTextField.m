//
//  UnderlineTextField.m
//  MoxiAPP
//
//  Created by HaviLee on 2017/2/26.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import "UnderlineTextField.h"

@implementation UnderlineTextField

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), 1));
}

@end
