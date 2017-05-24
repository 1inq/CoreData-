//
//  ASStudentViewController.h
//  CoreDataTest
//
//  Created by Александр Сорокин on 02.05.17.
//  Copyright © 2017 Александр Сорокин. All rights reserved.
//

#import "ASCoreDataViewController.h"


@class ASCourse;

@interface ASStudentViewController : ASCoreDataViewController

@property (nonatomic, strong) ASCourse *course;

@end
