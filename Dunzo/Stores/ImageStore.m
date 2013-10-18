//
//  ImageStore.m
//  Dunzo
//
//  Created by Tommy DANGerous on 9/25/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "ImageStore.h"
#import "UIImage+Resize.h"

@implementation ImageStore

@synthesize images = _images;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    _images = [NSMutableDictionary dictionary];
    // Checkmark
    UIImage *checkmark = [UIImage image: [UIImage imageNamed: @"checkmark.png"]
      size: CGSizeMake(40, 40)];
    [_images setObject: checkmark forKey: @"checkmark"];
    // Lightning
    UIImage *lightning = [UIImage image: 
      [UIImage imageNamed: @"lightning_white.png"] size: CGSizeMake(40, 40)];
    [_images setObject: lightning forKey: @"lightning"];
  }
  return self;
}

#pragma mark - Methods

+ (ImageStore *) sharedStore
{
  static ImageStore *store = nil;
  if (!store)
    store = [[ImageStore alloc] init];
  return store;
}

@end
