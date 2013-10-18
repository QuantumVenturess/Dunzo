//
//  DunzoTableViewController.h
//  Dunzo
//
//  Created by Tommy DANGerous on 9/9/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "DunzoViewController.h"

@class Note;

@interface DunzoTableViewController : DunzoViewController
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *table;

#pragma mark - Methods

- (void) reloadTable;
- (void) removeDoneNote: (Note *) note;

@end
