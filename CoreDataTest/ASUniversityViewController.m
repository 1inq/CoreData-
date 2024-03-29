//
//  ASUniversityViewController.m
//  CoreDataTest
//
//  Created by Александр Сорокин on 28.04.17.
//  Copyright © 2017 Александр Сорокин. All rights reserved.
//

#import "ASUniversityViewController.h"
#import "CoreDataTest+CoreDataModel.h"
#import "ASCourseViewController.h"


@interface ASUniversityViewController ()

@end

@implementation ASUniversityViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Universities";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSFetchedResultsController *) fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ASUniversity"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.context
                                          sectionNameKeyPath:nil
                                                   cacheName:@"Master"];
    
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    
    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}

#pragma mark - UITableViewDataSource

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    ASUniversity *university = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSLog(@"University name: %@", university.name);
    cell.textLabel.text = university.name;
    cell.detailTextLabel.text = nil;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ASUniversity *university = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    ASCourseViewController *vc = [[ASCourseViewController alloc] init];
    vc.university = university;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
