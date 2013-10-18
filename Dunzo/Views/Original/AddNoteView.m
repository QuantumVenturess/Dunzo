//
//  AddNoteView.m
//  Dunzo
//
//  Created by Tommy DANGerous on 9/11/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "AddNoteView.h"

@implementation AddNoteView

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    int dimension = 70;
    int padding   = 15;

    CGRect screen        = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor whiteAlpha: 0.6];
    self.frame = CGRectMake((screen.size.width - dimension), 
      (screen.size.height - (dimension + 20)), dimension, dimension);
    self.layer.borderWidth   = 1;
    self.layer.borderColor   = [UIColor green].CGColor;
    self.layer.cornerRadius  = dimension / 2;
    self.layer.masksToBounds = YES;

    // Plus shape
    int imageDimension = dimension - (padding * 2);
    horizontalBar = [[UIView alloc] init];
    horizontalBar.backgroundColor = [UIColor green];
    horizontalBar.frame = CGRectMake(padding, ((dimension - 2) / 2.0), 
      imageDimension, 2);
    [self addSubview: horizontalBar];
    verticalBar = [[UIView alloc] init];
    verticalBar.backgroundColor = [UIColor green];
    verticalBar.frame = CGRectMake(((dimension - 2) / 2.0), padding, 
      2, imageDimension);
    [self addSubview: verticalBar];
  }
  return self;
}

#pragma mark - Methods

- (void) fadeBackground 
{
  void (^animations) (void) = ^(void) {
    float opacity                 = 0.4;
    self.backgroundColor          = [UIColor whiteAlpha: opacity];
    self.layer.borderColor        = [UIColor greenAlpha: opacity].CGColor;
    UIColor *fadedColor           = [UIColor greenAlpha: opacity];
    horizontalBar.backgroundColor = fadedColor;
    verticalBar.backgroundColor   = fadedColor;
  };
  [UIView animateWithDuration: 0.15 delay: 0
    options: UIViewAnimationOptionCurveLinear animations: animations
      completion: nil];
}

- (void) restoreBackground 
{
  void (^animations) (void) = ^(void) {
    self.backgroundColor          = [UIColor whiteAlpha: 0.6];
    self.layer.borderColor        = [UIColor green].CGColor;
    horizontalBar.backgroundColor = [UIColor green];
    verticalBar.backgroundColor   = [UIColor green];
  };
  [UIView animateWithDuration: 0.15 delay: 0
    options: UIViewAnimationOptionCurveLinear animations: animations
      completion: nil];
}

- (void) tapped: (UIGestureRecognizer *) gesture
{
  void (^animations) (void) = ^(void) {
    self.backgroundColor          = [UIColor green];
    horizontalBar.backgroundColor = [UIColor white];
    verticalBar.backgroundColor   = [UIColor white];
  };
  void (^completion) (BOOL) = ^(BOOL finisheD) {
    [self restoreBackground];
  };
  [UIView animateWithDuration: 0.2 delay: 0
    options: UIViewAnimationOptionCurveLinear animations: animations
      completion: completion];
}

@end
