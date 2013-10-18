//
//  DunzoTableViewController.m
//  Dunzo
//
//  Created by Tommy DANGerous on 9/9/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "DunzoTableViewController.h"
#import "Note.h"
#import "UIColor+Extensions.h"

@implementation DunzoTableViewController

@synthesize table = _table;

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
  CGRect screen          = [[UIScreen mainScreen] bounds];
  _table                 = [[UITableView alloc] init];
  _table.backgroundColor = [UIColor black];
  _table.dataSource      = self;
  _table.delegate        = self;
  _table.frame           = screen;
  _table.scrollsToTop    = YES;
  _table.separatorColor  = [UIColor clearColor];
  _table.separatorStyle  = UITableViewCellSeparatorStyleNone;
  _table.showsVerticalScrollIndicator = NO;
  self.view = _table;
}

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return [[UITableViewCell alloc] init];
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  return 0;
}

#pragma mark - Methods

- (void) reloadTable
{
  // Subclasses will implement this
}

- (void) removeDoneNote: (Note *) note
{
  // Subclasses will implement this
}

@end
