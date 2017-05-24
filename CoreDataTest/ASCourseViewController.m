//
//  ASCourseViewController.m
//  CoreDataTest
//
//  Created by Александр Сорокин on 02.05.17.
//  Copyright © 2017 Александр Сорокин. All rights reserved.
//

#import "ASCourseViewController.h"
#import "CoreDataTest+CoreDataModel.h"
#import "ASStudentViewController.h"

@interface ASCourseViewController ()

@end

@implementation ASCourseViewController
@synthesize fetchedResultsController = _fetchedResultsController;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Courses";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ASCourse"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"university = %@", self.university];
    [fetchRequest setPredicate:predicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.context
                                          sectionNameKeyPath:nil
                                                   cacheName:@"Master"];
    
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    
    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}

#pragma mark - UITableViewDataSource

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    ASCourse *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSLog(@"Course name: %@", course.name);
    cell.textLabel.text = course.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", (int)[course.students count]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ASCourse *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
   
    ASStudentViewController *vc = [[ASStudentViewController alloc] init];
    vc.course = course;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
