//
//  ASDataManager.h
//  CoreDataTest
//
//  Created by Александр Сорокин on 28.04.17.
//  Copyright © 2017 Александр Сорокин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ASDataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic, strong) NSManagedObjectContext *context;

- (void) saveContext;
- (void) generateAndAddUniversity;

+ (ASDataManager*) sharedManager;


@end
