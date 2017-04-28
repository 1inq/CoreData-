//
//  AppDelegate.h
//  CoreDataTest
//
//  Created by Александр Сорокин on 18.04.17.
//  Copyright © 2017 Александр Сорокин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@end

