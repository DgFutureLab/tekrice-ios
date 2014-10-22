//
//  TabBarController.m
//  Techrice
//
//  Created by 藤賀 雄太 on 10/17/14.
//  Copyright (c) 2014 Future Lab. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate =self;
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    TableViewController *tableViewController = [[TableViewController alloc] init];
    [viewControllers addObject:tableViewController];
    ViewController *viewController = [[ViewController alloc] init];
    [viewControllers addObject:viewController];
    [self setViewControllers:viewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
