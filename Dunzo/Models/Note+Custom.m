//
//  Note+Custom.m
//  Dunzo
//
//  Created by Tommy DANGerous on 9/12/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "Note+Custom.h"

@implementation Note (Custom)

#pragma mark - Methods

- (NSString *) doneDateString
{
  if (self.doneDate) {
    // Jan 05, 13
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMM d, yy";
    return [dateFormatter stringFromDate: self.doneDate];
  }
  return nil;
}

- (NSString *) doneTimeString
{
  if (self.doneDate) {
    // 4:53 pm
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"h:mm a";
    return [[dateFormatter stringFromDate: self.doneDate] lowercaseString];
  }
  return nil;
}

- (NSString *) dueDateString
{
  if (self.dueDate) {
    // 8-12-13
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"M-d-yy";
    return [dateFormatter stringFromDate: self.dueDate];
  }
  return nil;
}

- (NSString *) dueDateStringLong
{
  if (self.dueDate) {
    // 8-12-13
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEEE MMMM d, yyyy";
    return [dateFormatter stringFromDate: self.dueDate];
  }
  return nil;
}

- (NSDate *) doneDateWithoutTime
{
  if (self.doneDate) {
    // Return a NSDate made from NSDateComponents without specific time
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // July 25, 13
    NSDateComponents *components = [calendar components:
      (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit)
        fromDate: self.doneDate];
    NSInteger day   = [components day];
    NSInteger month = [components month];
    NSInteger year  = [components year];
    NSDateComponents *componentsForNewDate = [[NSDateComponents alloc] init];
    [componentsForNewDate setDay: day];
    [componentsForNewDate setMonth: month];
    [componentsForNewDate setYear: year];
    
    return [calendar dateFromComponents: componentsForNewDate];
  }
  return nil;
}

- (BOOL) isEmpty
{
  NSString *text = [self.content stringByTrimmingCharactersInSet: 
    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if (text.length == 0) {
    return YES;
  }
  return NO;
}

- (BOOL) isDone
{
  return [self.done isEqualToNumber: [NSNumber numberWithBool: YES]];
}

@end
