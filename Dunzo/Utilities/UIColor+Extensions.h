//
//  UIColor+Extensions.h
//  Bite
//
//  Created by Tommy DANGerous on 6/9/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extensions)

+ (UIColor *) black;
+ (UIColor *) blackAlpha: (float) value;
+ (UIColor *) blue;
+ (UIColor *) gray;
+ (UIColor *) grayAlpha: (float) value;
+ (UIColor *) gray: (float) grayValue;
+ (UIColor *) gray: (float) grayValue alpha: (float) value;
+ (UIColor *) green;
+ (UIColor *) greenAlpha: (float) value;
+ (UIColor *) red;
+ (UIColor *) redAlpha: (float) value;
+ (UIColor *) white;
+ (UIColor *) whiteAlpha: (float) value;
+ (UIColor *) yellow;

@end
