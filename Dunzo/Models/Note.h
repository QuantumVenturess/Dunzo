//
//  Note.h
//  Dunzo
//
//  Created by Tommy DANGerous on 9/9/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface Note : NSManagedObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSNumber *done;
@property (nonatomic, strong) NSDate *doneDate;
@property (nonatomic, strong) NSDate *dueDate;
@property (nonatomic, strong) NSDate *updatedAt;

@end
