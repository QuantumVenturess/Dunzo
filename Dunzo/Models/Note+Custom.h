//
//  Note+Custom.h
//  Dunzo
//
//  Created by Tommy DANGerous on 9/12/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "Note.h"

@interface Note (Custom)

#pragma mark - Methods

- (NSString *) doneDateString;
- (NSString *) doneTimeString;
- (NSString *) dueDateString;
- (NSString *) dueDateStringLong;
- (NSDate *) doneDateWithoutTime;
- (BOOL) isEmpty;
- (BOOL) isDone;

@end
