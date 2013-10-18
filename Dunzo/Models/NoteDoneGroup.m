//
//  NoteDoneGroup.m
//  Dunzo
//
//  Created by Tommy DANGerous on 9/12/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "NoteDoneGroup.h"

@implementation NoteDoneGroup

@synthesize date;
@synthesize notes;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    self.notes = [NSMutableArray array];
  }
  return self;
}

#pragma mark - Methods

- (NSString *) dateString
{
  // Jan 05, 13
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"MMM d, yy";
  return [dateFormatter stringFromDate: self.date];
}

@end
