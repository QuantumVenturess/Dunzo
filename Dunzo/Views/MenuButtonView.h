//
//  MenuButtonView.h
//  Dunzo
//
//  Created by Tommy DANGerous on 9/11/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DunzoButtonView.h"

@interface MenuButtonView : DunzoButtonView
{
  UIView *bar1;
  UIView *bar2;
  UIView *bar3;
  UIImageView *imageView;
  UIImage *normalImage;
  UIImage *selectedImage;
}

@end
