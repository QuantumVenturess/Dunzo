//
//  ImageStore.h
//  Dunzo
//
//  Created by Tommy DANGerous on 9/25/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageStore : NSObject

@property (nonatomic, strong) NSMutableDictionary *images;

#pragma mark - Methods

+ (ImageStore *) sharedStore;

@end
