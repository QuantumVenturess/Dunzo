//
//  NoteDoneGroup.h
//  Dunzo
//
//  Created by Tommy DANGerous on 9/12/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteDoneGroup : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSMutableArray *notes;

#pragma mark - Methods

- (NSString *) dateString;

@end
