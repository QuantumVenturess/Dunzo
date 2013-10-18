//
//  UIColor+Extensions.m
//  Bite
//
//  Created by Tommy DANGerous on 6/9/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "UIColor+Extensions.h"

@implementation UIColor (Extensions)

+ (UIColor *) black
{
  return [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
}

+ (UIColor *) blackAlpha: (float) value
{
  return [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: value];
}

+ (UIColor *) blue
{
  return [UIColor colorWithRed: 1/255.0 green: 121/255.0 blue: 243/255.0 
    alpha: 1];
}

+ (UIColor *) gray
{
  return [UIColor colorWithRed: 160/255.0 green: 160/255.0 blue: 160/255.0
    alpha: 1];
}

+ (UIColor *) grayAlpha: (float) value
{
  return [UIColor colorWithRed: 160/255.0 green: 160/255.0 blue: 160/255.0
    alpha: value];
}

+ (UIColor *) gray: (float) greyValue
{
  return [UIColor colorWithRed: (greyValue / 255.0) green: (greyValue / 255.0) 
    blue: (greyValue / 255.0) alpha: 1];
}

+ (UIColor *) gray: (float) greyValue alpha: (float) value
{
  return [UIColor colorWithRed: (greyValue / 255.0) green: (greyValue / 255.0) 
    blue: (greyValue / 255.0) alpha: value];
}

+ (UIColor *) green
{
  return [UIColor colorWithRed: 119/255.0 green: 221/255.0 blue: 119/255.0 
    alpha: 1];
}

+ (UIColor *) greenAlpha: (float) value
{
  return [UIColor colorWithRed: 119/255.0 green: 221/255.0 blue: 119/255.0 
    alpha: value];
}

+ (UIColor *) red
{
  return [UIColor colorWithRed: 1 green: 105/255.0 blue: 97/255.0 alpha: 1];
}

+ (UIColor *) redAlpha: (float) value
{
  return [UIColor colorWithRed: 1 green: 105/255.0 blue: 97/255.0 alpha: value];
}

+ (UIColor *) white
{
  return [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
}

+ (UIColor *) whiteAlpha: (float) value
{
  return [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: value];
}

+ (UIColor *) yellow
{
  return [UIColor colorWithRed: 253/255.0 green: 253/255.0 blue: 150/255.0 
    alpha: 1];
}

@end
