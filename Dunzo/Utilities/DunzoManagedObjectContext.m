//
//  DunzoManagedObjectContext.m
//  Dunzo
//
//  Created by Tommy DANGerous on 9/13/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "DunzoManagedObjectContext.h"

@implementation DunzoManagedObjectContext

@synthesize model = _model;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    // Read in AppName.xcdatamodeld
    // NSManagedObjectModel holds entity information
    _model = [NSManagedObjectModel mergedModelFromBundles: nil];

    // The NSManagedObjectContext uses an NSPersistentStoreCoordinator
    // You ask the persistent store coordinator to open
    // a SQLite database at a particular filename
    NSPersistentStoreCoordinator *psc = 
      [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: _model];

    // Where does the SQLite file go?
    NSString *path  = [self itemArchivePath];
    NSURL *storeURL = [NSURL fileURLWithPath: path];
    NSError *error  = nil;
    
    if (![psc addPersistentStoreWithType: NSSQLiteStoreType configuration: nil
      URL: storeURL options: nil error: &error]) {

      [NSException raise: @"Open failed" format: @"Reason: %@",
        error.localizedDescription];
    }

    // Create the managed object context
    // Use this persistent store coordinator to save and load objects
    // context = [[NSManagedObjectContext alloc] init];
    [self setPersistentStoreCoordinator: psc];

    // The Managed object context can manage undo, but we don't need it
    [self setUndoManager: nil];
  }
  return self;
}

#pragma mark - Methods

+ (DunzoManagedObjectContext *) sharedContext
{
  static DunzoManagedObjectContext *context = nil;
  if (!context) {
    context = [[DunzoManagedObjectContext alloc] init];
  }
  return context;
}

- (NSString *) itemArchivePath
{
  // Searches the filesystem for a path that meets the criteria
  NSArray *documentDirectories = 
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
      NSUserDomainMask, YES);

  // Get one and only document directory from that list
  NSString *documentDirectory = [documentDirectories objectAtIndex: 0];

  return [documentDirectory stringByAppendingPathComponent: @"Dunzo.sqlite"];
}

@end
