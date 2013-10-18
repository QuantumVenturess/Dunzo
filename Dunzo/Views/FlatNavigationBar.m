//
//  FlatNavigationBar.m
//  SpadeTree
//
//  Created by Tommy DANGerous on 6/28/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "FlatNavigationBar.h"
#import "UIColor+Extensions.h"

@implementation FlatNavigationBar

#pragma mark - Override

- (void) drawRect: (CGRect) rect
{
  UIColor *color = [UIColor gray: 160 alpha: 0.8];
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColor(context, CGColorGetComponents([color CGColor]));
  CGContextFillRect(context, rect);
}

@end
