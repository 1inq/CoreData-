//
//  ASDataManager.m
//  CoreDataTest
//
//  Created by Александр Сорокин on 28.04.17.
//  Copyright © 2017 Александр Сорокин. All rights reserved.
//

#import "ASDataManager.h"
#import "CoreDataTest+CoreDataModel.h"

static NSString* carModelNames[] = {
    
    @"Lada", @"BMW", @"Dodge", @"Ford",
    @"Honda", @"Toyota",@"Mersedes-BENS",
    @"Nissan",@"Audi",@"Volkswagen"
};

@implementation ASDataManager


+ (ASDataManager*) sharedManager{
    
    static ASDataManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ASDataManager alloc] init];
        
    });
    
    return manager;
    
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

- (void) printArray:(NSArray*) array  {
    
    for (id object in array) {
        if ([object isKindOfClass:[ASStudent class]]) {
            
            ASStudent *student = (ASStudent*)object;
            NSLog(@"->> ! Student in CoreData: %@ %@ - Score: %1.2f ; courses: %d",
                  student.firstName, student.lastName, student.score, (int)[student.courses count]);
            
        } else if ([object isKindOfClass:[ASCar class]]) {
            
            ASCar *car = (ASCar*)object;
            NSLog(@"->> ! Car in CoreData: %@ - owner: %@ %@", car.model, car.owner.firstName, car.owner.lastName);
            
        } else if ([object isKindOfClass:[ASUniversity class]]) {
            
            ASUniversity *university = (ASUniversity*)object;
            NSLog(@"->> ! University in CoreData : %@ with students: %d",
                  university.name, (int)[university.students count]);
            
        } else if ([object isKindOfClass:[ASCourse class]]) {
            
            ASCourse *course = (ASCourse*) object;
            NSLog(@"Course: %@ Students: %d", course.name, (int)[course.students count]);
            
        }
    }
}

- (void) printAllObjects {
    
    NSError *error = nil;
    NSArray *resultArray = [self allObjects];
    
    if (!resultArray) {
        NSLog(@"Error fetching ASSTudent objects: %@ \n%@",[error localizedDescription], [error userInfo]);
        abort();
    } else {
        
        NSLog(@"Total Objects in result array: %d", (int)[resultArray count]);
        
        [self printArray:resultArray];
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

- (void) generateAndAddUniversity {
    
     NSArray *courses = @[[self addCourseWithName:@"iOS"],
                         [self addCourseWithName:@"HTML"],
                         [self addCourseWithName:@"Android"],
                         [self addCourseWithName:@"JavaScript"],
                         [self addCourseWithName:@"PHP"]];
    
    [self clearCoreData];
    [self saveContext];
    
    ASUniversity *university = [self addUniversity];
    
    //[self saveContext];
    
    [university addCourses:[NSSet setWithArray:courses]];
    
    for (int i = 0; i < 100; i++) {
        
        ASStudent *student = [self getRandomStudent];
        ASCar *c1 = [self getRandomCar];
        
        student.car = c1;
        student.university = university;
        [university addStudentsObject:student];
        NSInteger number = arc4random_uniform(4)+1;
        //NSLog(@"Should generated %d courses", (int)number);
        
        while ([student.courses count] < number) {
            
            ASCourse *course = [courses objectAtIndex:arc4random_uniform(5)];
            if (![student.courses containsObject:course]) {
                [student addCoursesObject:course];
                
            }
        }
    }
    
    [self saveContext];
    [self printAllObjects];
    
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"CoreDataTest"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    //self.context = self.persistentContainer.viewContext;
    
    return _persistentContainer;
}

- (NSManagedObjectContext*) context {
    
    if (_context == nil) {
        _context = self.persistentContainer.viewContext;
    }
    return _context;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    
    NSError *error = nil;
    if ([self.context hasChanges] && ![self.context save:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
