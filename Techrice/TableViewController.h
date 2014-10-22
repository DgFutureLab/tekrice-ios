//
//  TableViewController.h
//  Techrice
//
//  Created by 藤賀 雄太 on 10/17/14.
//  Copyright (c) 2014 Future Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DetailViewController.h"

@interface TableViewController : UITableViewController<UITabBarControllerDelegate>{
    NSArray *nodeArray;
    NSArray *distanceArray;
    NSArray *tableArray;
    AppDelegate *appDelegate;
}

@end
