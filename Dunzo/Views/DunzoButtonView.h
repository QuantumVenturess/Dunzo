//
//  DunzoButtonView.h
//  Dunzo
//
//  Created by Tommy DANGerous on 9/19/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "DunzoButton.h"
#import "UIColor+Extensions.h"
#import "UIImage+Resize.h"

@class DunzoButton;

@interface DunzoButtonView : UIView

@property (nonatomic, strong) DunzoButton *button;

#pragma mark - Methods

- (void) fadeBackground;
- (void) restoreBackground;
- (void) tapped: (UIGestureRecognizer *) gesture;

@end
