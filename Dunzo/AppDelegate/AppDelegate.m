//
//  AppDelegate.m
//  Dunzo
//
//  Created by Tommy DANGerous on 9/8/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "AppDelegate.h"
#import "MFSideMenu.h"
#import "NoteDetailViewController.h"
#import "NoteDoneViewController.h"
#import "NoteNotDoneViewController.h"
#import "NoteStore.h"
#import "UIColor+Extensions.h"

@implementation AppDelegate

@synthesize centerViewController;
@synthesize leftViewController;
@synthesize rightViewController;

@synthesize panel;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL) application: (UIApplication *) application 
didFinishLaunchingWithOptions: (NSDictionary *) launchOptions
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  self.window   = [[UIWindow alloc] initWithFrame: screen];

  // Override point for customization after application launch.

  // Core Data
  // NSManagedObjectContext *context = [self managedObjectContext];
  // if (!context) {
  //   NSLog(@"NSManagedObjectContext error");
  // }
  NoteDetailViewController *noteDetailViewController = 
    [[NoteDetailViewController alloc] init];
  NoteDoneViewController *noteDoneViewController = 
    [[NoteDoneViewController alloc] init];
  NoteNotDoneViewController *noteNotDoneViewController =
    [[NoteNotDoneViewController alloc] init];

  self.centerViewController = noteDetailViewController;
  self.leftViewController   = noteNotDoneViewController;
  self.rightViewController  = noteDoneViewController;

  self.panel = 
    [MFSideMenuContainerViewController containerWithCenterViewController: 
      self.centerViewController 
        leftMenuViewController: self.leftViewController 
          rightMenuViewController: self.rightViewController];
  [self.panel setMenuWidth: screen.size.width];
  [self.panel setShadowEnabled: NO];

  // Set the status bar style
  [[UIApplication sharedApplication] setStatusBarStyle:
    UIStatusBarStyleDefault];

  self.window.backgroundColor    = [UIColor black];
  self.window.rootViewController = self.panel;
  [self.window makeKeyAndVisible];

  return YES;
}

- (void) applicationWillResignActive: (UIApplication *) application
{
  NSLog(@"applicationWillResignActive");
  [self removeAndSaveNotes];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  NSLog(@"applicationDidEnterBackground");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  NSLog(@"applicationWillEnterForeground");
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void) applicationDidBecomeActive: (UIApplication *) application
{
  NSLog(@"applicationDidBecomeActive");
  [self switchToNoteViewController];
  [self.leftViewController reloadTable];
  [self.rightViewController reloadTable];
}

- (void) applicationWillTerminate: (UIApplication *) application
{
  NSLog(@"applicationWillTerminate");
  // Saves changes in the application's 
  // managed object context before the application terminates.
  [self removeAndSaveNotes];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Dunzo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Dunzo.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Methods

- (void) removeAndSaveNotes
{
  [[NoteStore sharedStore] removeEmptyNotes];
  [[NoteStore sharedStore] saveChanges];
  NSLog(@"Remove and save notes");
}

- (void) switchToNoteViewController
{
  [self.panel setMenuState: MFSideMenuStateClosed completion: ^{}];
  [self.centerViewController addNoteRegardless];
}

@end
