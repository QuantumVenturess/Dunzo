//
//  CalendarViewController.h
//  Dunzo
//
//  Created by Tommy DANGerous on 9/16/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "DunzoViewController.h"
#import "TimesSquare.h"

@class Note;

@interface CalendarViewController : DunzoViewController 
<TSQCalendarViewDelegate>

@property (nonatomic, strong) TSQCalendarView *calendarView;
@property (nonatomic, weak) Note *note;

@end
