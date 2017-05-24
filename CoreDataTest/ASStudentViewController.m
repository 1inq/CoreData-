//
//  ASStudentViewController.m
//  CoreDataTest
//
//  Created by Александр Сорокин on 02.05.17.
//  Copyright © 2017 Александр Сорокин. All rights reserved.
//

#import "ASStudentViewController.h"
#import "CoreDataTest+CoreDataModel.h"


@interface ASStudentViewController ()

@end

@implementation ASStudentViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Students";
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
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ASStudent"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor1, sortDescriptor2]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"courses CONTAINS %@", self.course];
    [fetchRequest setPredicate:predicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.context
                                          sectionNameKeyPath:@"university.name"
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
    
    ASStudent *student = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString *studentName = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    
    NSLog(@"Student name: %@", studentName);
    cell.textLabel.text = studentName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%1.2f", student.score];
    
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo name];
}

@end
