//
//  AppDelegate.m
//  CoreDataTest
//
//  Created by Александр Сорокин on 18.04.17.
//  Copyright © 2017 Александр Сорокин. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataTest+CoreDataModel.h"

static NSString* carModelNames[] = {
    
    @"Lada", @"BMW", @"Dodge", @"Ford",
    @"Honda", @"Toyota",@"Mersedes-BENS",
    @"Nissan",@"Audi",@"Volkswagen"
};


@interface AppDelegate ()

@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.context = self.persistentContainer.viewContext;
    
    NSArray *courses = @[[self addCourseWithName:@"iOS"],
                         [self addCourseWithName:@"HTML"],
                         [self addCourseWithName:@"Android"],
                         [self addCourseWithName:@"JavaScript"],
                         [self addCourseWithName:@"PHP"]];
    
    [self clearCoreData];
    [self saveContext];
    
    ASUniversity *university = [self addUniversity];
    [university addCourses:[NSSet setWithArray:courses]];
    
    for (int i = 0; i < 100; i++) {
        
        ASStudent *student = [self getRandomStudent];
        ASCar *c1 = [self getRandomCar];
        
        student.car = c1;
        student.university = university;
        [university addStudentsObject:student];
        NSInteger number = arc4random_uniform(5);
        
        while ([student.courses count] < number) {
            ASCourse *course = [courses objectAtIndex:arc4random_uniform(5)];
            if (![student.courses containsObject:course]) {
                [student addCoursesObject:course];
            }
        }
    }
    
    /*ASCourse *course = [NSEntityDescription insertNewObjectForEntityForName:@"ASCourse" inManagedObjectContext:self.context];
    course.name = @"iOS";
     */
    
    [self saveContext];
    [self printAllObjects];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Mothods 

- (void) clearCoreData {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ASObject"];
    NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    NSError *error = nil;
    [self.context executeRequest:deleteRequest error:&error];
    [self saveContext];
    
    return;
}

- (float) getRandomScore {
    float score = 0.f;
    score = ((float)(arc4random_uniform(100) % 99) / 100) + (float)arc4random_uniform(5);
    return score;
}

- (ASStudent*) getRandomStudent {
    
    ASStudent *student = [NSEntityDescription
                           insertNewObjectForEntityForName:@"ASStudent" inManagedObjectContext:self.context];
    
    student.score = [self getRandomScore];
    student.firstName = [NSString stringWithFormat:@"%f", student.score];
    student.lastName = [NSString stringWithFormat:@"%f", student.score];
    student.dateOfBirth = [NSDate dateWithTimeIntervalSince1970:60*60*24*365*arc4random_uniform(31)];
    
    return student;
}

- (ASCar*) getRandomCar {
    
    ASCar *car = [NSEntityDescription insertNewObjectForEntityForName:@"ASCar" inManagedObjectContext:self.context];
    
    int countTotalNames;
    //countTotalNames = [carModelNames count];
    countTotalNames = arc4random_uniform(10);
    
    car.model = carModelNames[countTotalNames];
    
    return car;
    
}

- (ASUniversity*) addUniversity {
    
    ASUniversity *university = [NSEntityDescription
                                insertNewObjectForEntityForName:@"ASUniversity"
                                inManagedObjectContext:self.context];
    university.name = @"SUSU";
    
    return university;
    
}

- (ASCourse*) addCourseWithName:(NSString*) name {
    
    ASCourse *course = [NSEntityDescription insertNewObjectForEntityForName:@"ASCourse" inManagedObjectContext:self.context];
    course.name = name;
    
    return course;
    
}

- (void) printAllObjects {
    
    NSError *error = nil;
    NSArray *resultArray = [self allObjects];
    
    if (!resultArray) {
        NSLog(@"Error fetching ASSTudent objects: %@ \n%@",[error localizedDescription], [error userInfo]);
        abort();
    } else {
        
        NSLog(@"Total Objects in result array: %d", (int)[resultArray count]);
        
        for (id object in resultArray) {
            if ([object isKindOfClass:[ASStudent class]]) {
                
                ASStudent *student = (ASStudent*)object;
                NSLog(@"->> ! Student in CoreData: %@ %@ - Score: %1.2f ; courses: %l",
                      student.firstName, student.lastName, student.score, [student.courses count]);
                
            } else if ([object isKindOfClass:[ASCar class]]) {
                
                ASCar *car = (ASCar*)object;
                NSLog(@"->> ! Car in CoreData: %@ - owner: %@ %@", car.model, car.owner.firstName, car.owner.lastName);
                
            } else if ([object isKindOfClass:[ASUniversity class]]) {
                
                ASUniversity *university = (ASUniversity*)object;
                NSLog(@"->> ! University in CoreData : %@ with students: %l",
                      university.name, (int)[university.students count]);
                
            } else if ([object isKindOfClass:[ASCourse class]]) {
                
                ASCourse *course = (ASCourse*) object;
                NSLog(@"Course: %@ Students: %l", course.name, (int)[course.students count]);
                
            }
        }
        
    }
    
}

- (NSArray*) allObjects {
    
    NSError *error = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ASObject"];
    
    //sort:
    /*
     NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    */
    
    //filter:
    /*
    float resultBorder = 0.f;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"score >= %f", resultBorder];
    [request setPredicate:predicate];
    */
    
    NSArray *resultArray = [self.context executeFetchRequest:request error:&error];
    
    return resultArray;
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"CoreDataTest"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    
                    //[NSFileManager defaultManager] removeItem
                    
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    
    NSError *error = nil;
    if ([self.context hasChanges] && ![self.context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
