//
//  NoteDetailViewControllerTests.m
//  Dunzo
//
//  Created by Tommy DANGerous on 9/12/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "NoteDetailViewController.h"
#import "NoteDetailViewControllerTests.h"

@implementation NoteDetailViewControllerTests

- (void) setUp
{
  viewController = [[NoteDetailViewController alloc] init];
}

- (void) tearDown
{
  viewController = nil;
}

#pragma mark - Tests

- (void) testViewControllerAddingANoteShouldSetANote
{
  [viewController addNote];
  STAssertTrue(viewController.note != nil,
    @"NoteViewController must have a note");
}

@end
