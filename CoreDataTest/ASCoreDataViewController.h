//
//  ASCoreDataViewController.h
//  CoreDataTest
//
//  Created by Александр Сорокин on 28.04.17.
//  Copyright © 2017 Александр Сорокин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ASCoreDataViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *context;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (NSFetchedResultsController *) fetchedResultsController;

@end
